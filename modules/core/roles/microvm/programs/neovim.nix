{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    configure.customRC = ''
      syntax enable

      set noexpandtab
      set shiftwidth=2
      set tabstop=2

      set cindent
      set smartindent
      set autoindent
      set foldmethod=syntax
      nmap <F2> zA
      nmap <F3> zR
      nmap <F4> zM
    '';
  };
}
