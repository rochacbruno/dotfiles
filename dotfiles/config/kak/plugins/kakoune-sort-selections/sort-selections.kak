provide-module sort-selections %{

define-command sort-selections -params .. -docstring '
sort-selections [<switches>]: sort the selections based on their content
Sorting is done numerically if possible, otherwise lexicographically
Switches:
    -reverse: reverse the sort order
    -register <register>: sort the register content instead, and apply the order to the selections
                          the number of elements in the register must match the number of selections
    -force-numeric: force sorting by numeric order, and fail if not all input are numbers
    -force-lexicographic: force sorting by lexicographic order, even if all input are numbers
    -dry-run: only check if input parameters are valid, do not sort
' -shell-script-candidates %{
    printf '%s\n' -reverse -force-numeric -force-lexicographic -register -dry-run
} %{
    try %{
        exec -draft '<a-space><esc><a-,><esc>'
    } catch %{
        fail 'Only one selection, cannot sort'
    }
    eval %sh{
        reverse=0
        type=0        # 0=auto / 1=numeric / 2=lexicographic
        register=''
        dry_run=0
        while [ $# -ne 0 ]; do
            arg_num=$((arg_num + 1))
            arg=$1
            shift
            if [ "$arg" = '-reverse' ]; then
                reverse=1
            elif [ "$arg" = '-force-numeric' ]; then
                type=1
            elif [ "$arg" = '-force-lexicographic' ]; then
                type=2
            elif [ "$arg" = '-register' ]; then
                if [ $# -eq 0 ]; then
                    echo 'fail "Missing argument to -register"'
                    exit 1
                fi
                arg_num=$((arg_num + 1))
                register=$1
                [ "$register" = "'" ] && register="''"
                printf "nop -- %%reg'%s'\n" "$register"
                shift
            elif [ "$arg" = '-dry-run' ]; then
                dry_run=1
            else
                printf "fail \"Unrecognized argument '%%arg{%s}'\"" "$arg_num"
                exit 1
            fi
        done
        printf "sort-selections-impl '%s' '%s' '%s' '%s'" "$reverse" "$type" "$register" "$dry_run"
    }
}

define-command reverse-selections -docstring '
reverse-selections: reverses the order of all selections
' %{ sort-selections -reverse -register '#' }

define-command shuffle-selections -docstring '
shuffle-selections: randomizes the order of all selections
' %{
    eval -save-regs '"' %{
        eval reg dquote %sh{ seq "$kak_selection_count" | shuf | tr '\n' ' ' }
        sort-selections -register dquote
    }
}

define-command sort-selections-impl -hidden -params 4 %{
    eval -save-regs '"' %sh{
perl - "$1" "$2" "$3" "$4" <<'EOF'
use strict;
use warnings;
use Scalar::Util "looks_like_number";

my $reverse = shift;
my $type = shift;
my $register = shift;
my $dry_run = shift;

my $command_fifo_name = $ENV{"kak_command_fifo"};
my $response_fifo_name = $ENV{"kak_response_fifo"};

sub parse_shell_quoted {
    my $str = shift;
    my @res;
    my $elem = "";
    while (1) {
        if ($str !~ m/\G'([\S\s]*?)'/gc) {
            print("echo -debug error1");
            exit;
        }
        $elem .= $1;
        if ($str =~ m/\G *$/gc) {
            push(@res, $elem);
            $elem = "";
            last;
        } elsif ($str =~ m/\G\\'/gc) {
            $elem .= "'";
        } elsif ($str =~ m/\G */gc) {
            push(@res, $elem);
            $elem = "";
        } else {
            print("echo -debug error2");
            exit;
        }
    }
    return @res;
}

sub read_array {
    my $what = shift;

    open (my $command_fifo, '>', $command_fifo_name);
    print $command_fifo "echo -quoting shell -to-file $response_fifo_name -- $what";
    close($command_fifo);

    # slurp the response_fifo content
    open (my $response_fifo, '<', $response_fifo_name);
    my $response_quoted = do { local $/; <$response_fifo> };
    close($response_fifo);
    return parse_shell_quoted($response_quoted);
}

sub are_all_numbers {
    my $array_ref = shift;
    for my $val (@$array_ref) {
        if (not looks_like_number($val)) {
            return 0;
        }
    }
    return 1;
}

sub should_sort_by_number {
    my $wanted_sort_type = shift;
    my $array_ref = shift;
    if ($wanted_sort_type == 0) { # auto
        return are_all_numbers($array_ref);
    } elsif ($wanted_sort_type == 1) { # want numeric, need to check, can fail
        if (are_all_numbers($array_ref) == 1) {
            return 1;
        } else {
            return -1;
        }
    } elsif ($wanted_sort_type == 2) { # want lexicographic, no check
        return 0;
    } else {
        print("echo -debug error3");
        exit;
    }
}

my @selections = read_array("%val{selections}");
my $by_number;

if ($register eq '') {
    my @sorted;
    $by_number = should_sort_by_number($type, \@selections);
    if ($by_number == -1) {
        printf("fail 'The selections must all be valid numbers' ;");
        exit;
    }
    if ($dry_run == 0) {
        if ($reverse == 1) {
            if ($by_number == 1) {
                @sorted = sort { $b <=> $a; } @selections;
            } else {
                @sorted = sort { $b cmp $a; } @selections;
            }
        } else {
            if ($by_number == 1) {
                @sorted = sort { $a <=> $b; } @selections;
            } else {
                @sorted = sort { $a cmp $b; } @selections;
            }
        }
        print("reg dquote");
        for my $sel (@sorted) {
            $sel =~ s/'/''/g;
            print(" '$sel'");
        }
        print(" ;");
        print("exec R ;");
    }
} else {
    my @indices = read_array("%reg'$register'");

    if (scalar(@indices) != scalar(@selections)) {
        print("fail 'The register must contain as many values as selections' ;");
        exit;
    }
    $by_number = should_sort_by_number($type, \@indices);
    if ($by_number == -1) {
        printf("fail 'The register values must all be valid numbers' ;");
        exit;
    }
    if ($dry_run == 0) {
        my @pairs;
        for my $i (0 .. scalar(@indices) - 1) {
            push(@pairs, [ $indices[$i], $selections[$i] ] );
        }
        my @sorted;
        if ($reverse == 1) {
            if ($by_number == 1) {
                @sorted = sort { @$b[0] <=> @$a[0]; } @pairs;
            } else {
                @sorted = sort { @$b[0] cmp @$a[0]; } @pairs;
            }
        } else {
            if ($by_number == 1) {
                @sorted = sort { @$a[0] <=> @$b[0]; } @pairs;
            } else {
                @sorted = sort { @$a[0] cmp @$b[0]; } @pairs;
            }
        }
        print("reg dquote");
        for my $pair (@sorted) {
            my $sel = @$pair[1];
            $sel =~ s/'/''/g;
            print(" '$sel'");
        }
        print(" ;");
        print("exec R ;");
    }
}

my $how = ($by_number == 1 ? "numerically" : "lexicographically");
my $target = ($register eq '' ? "content" : "index");
my $count = scalar(@selections);
print("echo -markup '{Information}Sorted $count selections $how by $target");
if ($dry_run != 0) {
    print(" (dry-run)");
}
print("' ;");
EOF
    }
}

}

require-module sort-selections
