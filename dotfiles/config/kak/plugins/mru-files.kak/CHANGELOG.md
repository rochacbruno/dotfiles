* v0.1.4
  * `mru-files`
    * `mru-files-related` (`=` in `*mru*`): move related files to top of `*mru*`
    * `mru_files_session_autosave` (default: true)
    * fixes; faster; tests for installation from scratch via `plug`, basic functionality
  * k9s0ke-shlib:
    * tested using [t3st](https://gitlab.com/kstr0k/t3st) (test branch); several fixes
    * Kakoune commands: `def-sh-with-prelude-cmd`; `k9s0ke-file2*` no-shell loaders
    * shell functions (new & revised):
      * strings: `str_subst`, `str_repeat`, `strip_[trail|lead]`
      * paths: `abspath1`, `realpath1`, `dirandbasename`, `mkdirp`
      * filters: `tail`, `tac`, `echo_lines`, `grepF` / grepSHPAT`
    * `_r4`, `_ref` versions preferred (optimize away pipes / subshells / external calls)
* v0.1.3
  * added [kakhist](kakhist)
  * mru-files[-list] honors an optional count (3 :mru-file &mdash; easy cycling)
* v0.1.2
  * `<a-ret>` in `*mru*` opens files in the background
  * added `mru-files-session-{load,save}`
  * `_igore_sh` now appendable
  * suggest mapping on `g <a-f>`
* v0.1.1
  * every file visit updates MRU, not just BufCreate
  * write history in idle hook
  * `mru-files <TAB>` completion
  * `*mru*` buffer editable, '`>`' = save
  * add `ClientClose` hook for history sync, not just KakEnd
  * `k9s0ke-shlib` moved to top-level folder
  * fixes:
    * `<ret>` for paths with spaces in `*mru*`
    * `tmp` in /run/.../kakoune-tmp (`kak` confused it for session)
* v0.1.0
  * [announcement](https://discuss.kakoune.com/t/mru-files-kak-persistent-most-recently-used-files-history/1787)
