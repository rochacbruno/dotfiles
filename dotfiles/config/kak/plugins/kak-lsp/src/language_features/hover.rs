use crate::capabilities::attempt_server_capability;
use crate::capabilities::CAPABILITY_HOVER;
use crate::context::*;
use crate::diagnostics::format_related_information;
use crate::markup::*;
use crate::position::*;
use crate::types::*;
use crate::util::editor_quote;
use indoc::formatdoc;
use itertools::Itertools;
use lsp_types::request::*;
use lsp_types::*;
use serde::Deserialize;
use url::Url;

pub fn text_document_hover(meta: EditorMeta, params: EditorParams, ctx: &mut Context) {
    if meta.fifo.is_none() && !attempt_server_capability(ctx, &meta, CAPABILITY_HOVER) {
        return;
    }

    let HoverDetails {
        hover_client: maybe_hover_client,
    } = HoverDetails::deserialize(params.clone()).unwrap();

    let hover_type = match maybe_hover_client {
        Some(client) => HoverType::HoverBuffer { client },
        None => HoverType::InfoBox,
    };

    let params = EditorHoverParams::deserialize(params).unwrap();
    let (range, cursor) = parse_kakoune_range(&params.selection_desc);
    let req_params = HoverParams {
        text_document_position_params: TextDocumentPositionParams {
            text_document: TextDocumentIdentifier {
                uri: Url::from_file_path(&meta.buffile).unwrap(),
            },
            position: get_lsp_position(&meta.buffile, &cursor, ctx).unwrap(),
        },
        work_done_progress_params: Default::default(),
    };
    ctx.call::<HoverRequest, _>(meta, req_params, move |ctx: &mut Context, meta, result| {
        editor_hover(meta, hover_type, cursor, range, params.tabstop, result, ctx)
    });
}

pub fn editor_hover(
    meta: EditorMeta,
    hover_type: HoverType,
    cursor: KakounePosition,
    range: KakouneRange,
    tabstop: usize,
    result: Option<Hover>,
    ctx: &mut Context,
) {
    let doc = &ctx.documents[&meta.buffile];
    let lsp_range = kakoune_range_to_lsp(&range, &doc.text, ctx.offset_encoding);
    let for_hover_buffer = matches!(hover_type, HoverType::HoverBuffer { .. });
    let diagnostics = ctx.diagnostics.get(&meta.buffile);
    let diagnostics = diagnostics
        .map(|x| {
            x.iter()
                .filter(|x| ranges_touch_same_line(x.range, lsp_range))
                .filter(|x| !x.message.is_empty())
                .map(|x| {
                    // Indent line breaks to the same level as the bullet point
                    let message = (x.message.trim().to_string()
                        + &format_related_information(x, ctx)
                            .map(|s| "\n  ".to_string() + &s)
                            .unwrap_or_default())
                        .replace('\n', "\n  ");
                    if for_hover_buffer {
                        // We are typically creating Markdown, so use a standard Markdown enumerator.
                        return format!("* {}", message);
                    }

                    let face = x
                        .severity
                        .map(|sev| match sev {
                            DiagnosticSeverity::ERROR => FACE_INFO_DIAGNOSTIC_ERROR,
                            DiagnosticSeverity::WARNING => FACE_INFO_DIAGNOSTIC_WARNING,
                            DiagnosticSeverity::INFORMATION => FACE_INFO_DIAGNOSTIC_INFO,
                            DiagnosticSeverity::HINT => FACE_INFO_DIAGNOSTIC_HINT,
                            _ => {
                                warn!("Unexpected DiagnosticSeverity: {:?}", sev);
                                FACE_INFO_DEFAULT
                            }
                        })
                        .unwrap_or(FACE_INFO_DEFAULT);

                    format!(
                        "• {{{}}}{}{{{}}}",
                        face,
                        escape_kakoune_markup(&message),
                        FACE_INFO_DEFAULT,
                    )
                })
                .join("\n")
        })
        .unwrap_or_else(String::new);

    let code_lenses = ctx
        .code_lenses
        .get(&meta.buffile)
        .map(|lenses| {
            lenses
                .iter()
                .filter(|lens| ranges_touch_same_line(lens.range, lsp_range))
                .map(|lens| {
                    lens.command
                        .as_ref()
                        .map(|cmd| cmd.title.as_str())
                        .unwrap_or("(unresolved)")
                })
                .map(|title| {
                    if for_hover_buffer {
                        // We are typically creating Markdown, so use a standard Markdown enumerator.
                        return format!("* {}", &title);
                    }
                    format!(
                        "• {{{}}}{}{{{}}}",
                        FACE_INFO_DIAGNOSTIC_HINT,
                        escape_kakoune_markup(title),
                        FACE_INFO_DEFAULT,
                    )
                })
                .join("\n")
        })
        .unwrap_or_default();

    let marked_string_to_hover = |ms: MarkedString| {
        if for_hover_buffer {
            match ms {
                MarkedString::String(markdown) => markdown,
                MarkedString::LanguageString(LanguageString { language, value }) => formatdoc!(
                    "```{}
                     {}
                     ```",
                    &language,
                    &value,
                ),
            }
        } else {
            marked_string_to_kakoune_markup(ms)
        }
    };

    let (is_markdown, mut contents) = match result {
        None => (false, "".to_string()),
        Some(result) => match result.contents {
            HoverContents::Scalar(contents) => (true, marked_string_to_hover(contents)),
            HoverContents::Array(contents) => (
                true,
                contents
                    .into_iter()
                    .map(marked_string_to_hover)
                    .filter(|markup| !markup.is_empty())
                    .join(&if for_hover_buffer {
                        "\n---\n".to_string()
                    } else {
                        format!("\n{{{}}}---{{{}}}\n", FACE_INFO_RULE, FACE_INFO_DEFAULT)
                    }),
            ),
            HoverContents::Markup(contents) => match contents.kind {
                MarkupKind::Markdown => (
                    true,
                    if for_hover_buffer {
                        contents.value
                    } else {
                        markdown_to_kakoune_markup(contents.value)
                    },
                ),
                MarkupKind::PlainText => (false, contents.value),
            },
        },
    };

    if !for_hover_buffer && contents.contains('\t') {
        // TODO also expand tabs in the middle.
        contents = contents
            .split('\n')
            .map(|line| {
                let n = line.bytes().take_while(|c| *c == b'\t').count();
                " ".repeat(tabstop * n) + &line[n..]
            })
            .join("\n");
    }

    match hover_type {
        HoverType::InfoBox => {
            if contents.is_empty() && diagnostics.is_empty() && code_lenses.is_empty() {
                return;
            }

            let command = format!(
                "lsp-show-hover {} %§{}§ %§{}§ %§{}§",
                cursor,
                contents.replace('§', "§§"),
                diagnostics.replace('§', "§§"),
                code_lenses.replace('§', "§§"),
            );
            ctx.exec(meta, command);
        }
        HoverType::Modal {
            modal_heading,
            do_after,
        } => {
            show_hover_modal(meta, ctx, modal_heading, do_after, contents, diagnostics);
        }
        HoverType::HoverBuffer { client } => {
            if contents.is_empty() && diagnostics.is_empty() {
                return;
            }

            show_hover_in_hover_client(meta, ctx, client, is_markdown, contents, diagnostics);
        }
    };
}

fn show_hover_modal(
    meta: EditorMeta,
    ctx: &Context,
    modal_heading: String,
    do_after: String,
    contents: String,
    diagnostics: String,
) {
    let contents = format!("{}\n---\n{}", modal_heading, contents);
    let command = format!(
        "lsp-show-hover modal %§{}§ %§{}§ ''",
        contents.replace('§', "§§"),
        diagnostics.replace('§', "§§"),
    );
    let command = formatdoc!(
        "evaluate-commands %§
             {}
             {}
         §",
        command.replace('§', "§§"),
        do_after.replace('§', "§§")
    );
    ctx.exec(meta, command);
}

fn show_hover_in_hover_client(
    meta: EditorMeta,
    ctx: &Context,
    hover_client: String,
    is_markdown: bool,
    contents: String,
    diagnostics: String,
) {
    let contents = if diagnostics.is_empty() {
        contents
    } else {
        formatdoc!(
            "{}

             ## Diagnostics
             {}",
            contents,
            diagnostics,
        )
    };

    let command = format!(
        "%[ edit! -scratch *hover*; \
             set-option buffer=*hover* filetype {}; \
             try %[ add-highlighter buffer/lsp_wrap wrap -word ]; \
             execute-keys Rgk \
         ]",
        if is_markdown { "markdown" } else { "''" },
    );

    let command = formatdoc!(
        "set-register dquote {}
         try %[ delete-buffer! *hover* ]
         try %[
             evaluate-commands -client {hover_client} {command}
         ] catch %[
             new %[
                 rename-client {hover_client}
                 evaluate-commands {command}
                 focus {}
             ]
         ]",
        editor_quote(&contents),
        meta.client.as_ref().unwrap(),
    );

    let command = format!(
        "evaluate-commands -save-regs '\"' {}",
        &editor_quote(&command)
    );
    ctx.exec(meta, command);
}
