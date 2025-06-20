# Nushell Config File
#
# version = "0.97.2"

# The default config record. This is where much of your global configuration is setup.
$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup

    ls: {
        use_ls_colors: true # use the LS_COLORS environment variable to colorize output
        clickable_links: true # enable or disable clickable links. Your terminal has to support links.
    }

    table: {
        mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
        index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
        show_empty: true # show 'empty list' and 'empty record' placeholders for command output
        padding: { left: 1, right: 1 } # a left right padding of each column in a table
        trim: {
            methodology: wrapping # wrapping or truncating
            wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
            truncating_suffix: "..." # A suffix used by the 'truncating' methodology
        }
        header_on_separator: false # show header text on separator/border line
        # abbreviated_row_count: 10 # limit data rows from top and bottom after reaching a set point
    }

    error_style: "fancy" # "fancy" or "plain" for screen reader-friendly error messages

    # Whether an error message should be printed if an error of a certain kind is triggered.
    display_errors: {
        exit_code: false # assume the external command prints an error message
        # Core dump errors are always printed, and SIGPIPE never triggers an error.
        # The setting below controls message printing for termination by all other signals.
        termination_signal: true
    }

    # datetime_format determines what a datetime rendered in the shell would look like.
    # Behavior without this configuration point will be to "humanize" the datetime display,
    # showing something like "a day ago."
    datetime_format: {
        # normal: '%a, %d %b %Y %H:%M:%S %z'    # shows up in displays of variables or other datetime's outside of tables
        # table: '%m/%d/%y %I:%M:%S%p'          # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
    }

    history: {
        max_size: 100_000 # Session has to be reloaded for this to take effect
        sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
        file_format: "plaintext" # "sqlite" or "plaintext"
        isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
    }

    completions: {
        case_sensitive: false # set to true to enable case-sensitive completions
        quick: true    # set this to false to prevent auto-selecting completions when only one remains
        partial: true    # set this to false to prevent partial filling of the prompt
        algorithm: "prefix"    # prefix or fuzzy
        sort: "smart" # "smart" (alphabetical for prefix matching, fuzzy score for fuzzy matching) or "alphabetical"
        use_ls_colors: true # set this to true to enable file/path/directory completions using LS_COLORS
    }

    cursor_shape: {
        emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
        vi_insert: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
        vi_normal: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
    }

    float_precision: 2 # the precision for displaying floats in tables
    buffer_editor: 'nvim' # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
    use_ansi_coloring: true
    bracketed_paste: true # enable bracketed paste, currently useless on windows
    edit_mode: 'vi' # emacs, vi
    render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
    use_kitty_protocol: false # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this.
    highlight_resolved_externals: false # true enables highlighting of external commands in the repl resolved by which.
    plugins: {} # Per-plugin configuration. See https://www.nushell.sh/contributor-book/plugins.html#configuration.
    plugin_gc: {
        # Configuration for plugin garbage collection
        default: {
            enabled: true # true to enable stopping of inactive plugins
            stop_after: 10sec # how long to wait after a plugin is inactive to stop it
        }
        }
  keybindings: [
    {
      name: delete-chars-before-cursor
      modifier: control
      keycode: char_u
      mode: vi_insert # Options: emacs vi_normal vi_insert
      event: { edit: CutFromLineStart }
    }
  ]
}

def --env fzf_with [tool: string, query?: string] {
  mut file = ""
  if ($query | is-empty) {
    $file = (fzf --reverse)
  } else {
    $file = (fzf --reverse --query $query)
  }

  if ($file | is-empty) { return }
  if ($file | path exists) {
    let abspath = ($file | path expand)
    let folder = ($file | path dirname)
    match $tool {
      "cd" => { cd $folder }
      _ => { ^$tool $abspath }
    }
  }
}
def --env fv [query?: string] { fzf_with $env.EDITOR $query }
def --env fcd [query?: string] { fzf_with cd $query }
def --env fz [query?: string] { fzf_with $env.PDFVIEWER $query }
def --env fr [query?: string] { fzf_with $env.FILE_MANAGER $query }

def --env vv [query?: string] {
  let pwd = $env.PWD
  cd (echo '~' | path expand | path join 'projects' 'dotfiles')
  fzf_with $env.EDITOR $query
  cd $pwd
}

def --env mm [query?: string] {
  let pwd = $env.PWD
  cd (echo '~' | path expand | path join 'docx' 'memorandum')
  fzf_with $env.EDITOR $query
  cd $pwd
}

def nq [...pattern: string] {
    if ($pattern | is-empty) {
        print "usage: nq <pattern>"
        return
    }
    let temp_file = (mktemp | str trim)
    rg --vimgrep --smart-case ...$pattern | save --force $temp_file
    nvim -q $temp_file
    rm $temp_file
}

def activate [] {
    let cwd = ($env.PWD | path expand)
    let home = (echo '~' | path expand)
    mut venv_path = ""
    # Recursive search upward for .venv directory
    mut current_dir = $cwd
    while ($current_dir != $home and $current_dir != "") {
        let potential_venv = ($current_dir | path join ".venv")
        if ($potential_venv | path exists) {
            $venv_path = ($potential_venv | path expand)
            break
        }
        $current_dir = ($current_dir | path dirname)
    }
    if ($venv_path != "") {
        if ($venv_path | path type) == dir {
            for folder in ["Scripts", "bin"] {
              let activate_script = ($venv_path | path join $folder "activate.nu")
                if ($activate_script | path exists) {
                  commandline edit $"overlay use ($activate_script)"
                  return
                }
              }
              print $"Found .venv at ($venv_path), but could not find activate.nu"
        } else {
            print $"Found .venv at ($venv_path), but it is not a valid directory"
        }
    } else {
        print "Could not find .venv directory"
    }
}

alias va = activate
alias vd = overlay hide activate

alias c = clear
alias pt = python
alias v = nvim
alias g = git
alias ga = lazygit
alias r = lf
alias jobs = job list
alias fg = job unfreeze
alias lb = libreoffice
# alias . = cd ..
source ~/.zoxide.nu
