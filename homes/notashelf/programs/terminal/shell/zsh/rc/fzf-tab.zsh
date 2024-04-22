# Fzf-tab
# <https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#configure>
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions'   format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*'                list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*'                menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*'       fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*'                   switch-group '<' '>'
# appearance
zstyle ':fzf-tab:complete:cd:*'       popup-pad 20 0
zstyle ':completion:*'                file-sort modification
zstyle ':completion:*:eza'            sort false
zstyle ':completion:files'            sort false
