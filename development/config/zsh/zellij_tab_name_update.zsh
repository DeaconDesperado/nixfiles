typeset -g _zellij_last_tab_title

function _zellij_update_tab_name() {
    local title=${PWD:t}
    [[ $PWD == $HOME ]] && title='~'

    [[ $title == ${_zellij_last_tab_title-} ]] && return

    if zellij action rename-tab -- "$title" >/dev/null 2>&1; then
        _zellij_last_tab_title=$title
    fi
}

if [[ -n $ZELLIJ ]]; then
    add-zsh-hook chpwd _zellij_update_tab_name
    _zellij_update_tab_name
fi
