if status is-interactive
    if test -f ~/.config/fish/tmp.fish
        source ~/.config/fish/tmp.fish
    end

    fish_add_path "$HOME/.local/bin"
    fish_add_path "$HOME/.cargo/bin"
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew
    fish_add_path $ANDROID_HOME/tools
    fish_add_path $ANDROID_HOME/platform-tools

    set -gx PROFILE "$HOME/.config/fish/config.fish"
    set -gx ANDROID_HOME /home/meron/Android/Sdk/
    set -gx GIT_EDITOR nvim
    set -gx SUDO_EDITOR nvim
    set -gx EDITOR nvim
    set -gx GIT_EXTERNAL_DIFF difft
    set -gx PULUMI_CONFIG_PASSPHRASE
    set -gx HOMEBREW_NO_AUTO_UPDATE 1
    set -gx MCAT_TIMEOUT 2

    alias v="nvim"
    alias o="mcat"
    alias pine="PROTONPATH=GE-Proton umu-run"
    alias aerospace-restart='pkill AeroSpace; sleep 0.5; open -a AeroSpace'
    alias ls="eza --icons --group-directories-first"
    alias ll="eza --icons --group-directories-first -lh --git"
    alias la="eza --icons --group-directories-first -lah --git"
    switch (uname)
        case Darwin
            alias scb='pbcopy'
        case Linux
            alias scb='wl-copy'
    end

    function e
        set -l target "."
        if test (count $argv) -gt 0
            set target $argv[1]
        end

        set -l target_path (realpath "$target")

        switch (uname)
            case Darwin
                open "$target_path"
            case Linux
                niri msg action spawn -- nautilus "$target_path"
        end
    end
end
