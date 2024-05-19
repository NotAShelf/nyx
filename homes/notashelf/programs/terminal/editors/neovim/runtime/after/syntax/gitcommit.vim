" Syntax highlighting for git commit messages.
" Set up rules to highlight the summary of the commit
" if it's less than 51 characters and warns
" if the summary exceeds 70 characters
" Adapted from:
"  <https://github.com/b0o/nvim-conf/blob/c7b8000ead9dc7cf9a4fda004a1f7a93097ea810/after/syntax/gitcommit.vim>
syn match gitcommitOverflowWarn ".*\%<75v."  contained containedin=gitcommitFirstLine nextgroup=gitcommitOverflow     contains=@Spell
syn match gitcommitSummary      "^.*\%<51v." contained containedin=gitcommitFirstLine nextgroup=gitcommitOverflowWarn contains=@Spell
hi link gitcommitOverflowWarn SpecialChar
hi link gitcommitOverflow     Comment
