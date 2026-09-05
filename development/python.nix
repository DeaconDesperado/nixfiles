{ inputs, lib, config, pkgs, ... }:
with lib;
let
  cfg = config.development.python;
  pyenvVirtualenvRev = "3057e1549bb3998eb54ba0810f3e0effce00ff70";
  pyenvVirtualenv = pkgs.fetchFromGitHub {
    owner = "pyenv";
    repo = "pyenv-virtualenv";
    rev = pyenvVirtualenvRev;
    hash = "sha256-b2mmO7jqn9lusdWmhO0nPDCik12b5XCTPGbatoEd8iE=";
  };
in {

  options.development.python = {
    enable = mkEnableOption "Enable Python development";
  };

  config = mkIf cfg.enable {

    neovim-lsps.lsp-setups = {
      pyright = builtins.readFile (./config/neovim/lsp/pyright.lua);
    };

    neovim-treesitter.grammars = [ "python" ];

    # Nix manages the pyenv executable, while Python installations, shims and
    # plugins remain mutable under ~/.pyenv.
    programs.pyenv = {
      enable = true;
      enableZshIntegration = false;
      rootDirectory = "${config.home.homeDirectory}/.pyenv";
    };

    home.sessionPath = [ "${config.home.homeDirectory}/.pyenv/shims" ];

    # pyenv discovers plugins below PYENV_ROOT/plugins. Home Manager links this
    # pinned source there while Python installations and virtualenvs stay mutable.
    home.file.".pyenv/plugins/pyenv-virtualenv".source = pyenvVirtualenv;

    # Generating these snippets launches pyenv several times. Cache their
    # output until either pyenv or the mutable virtualenv plugin changes.
    # virtualenv-init itself is left intact, including its precmd hook, so
    # automatic activation semantics remain unchanged.
    programs.zsh.initContent = lib.mkOrder 550 ''
      export PYENV_ROOT="${config.home.homeDirectory}/.pyenv"
      path=("${lib.getBin pkgs.pyenv}/bin" "$PYENV_ROOT/shims" $path)

      _pyenv_cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/pyenv"
      _pyenv_init_cache="$_pyenv_cache_dir/init-${pkgs.pyenv.version}-${builtins.substring 0 8 pyenvVirtualenvRev}.zsh"
      _pyenv_virtualenv_init="$PYENV_ROOT/plugins/pyenv-virtualenv/bin/pyenv-virtualenv-init"

      if [[ ! -s "$_pyenv_init_cache" ||
            ( -e "$_pyenv_virtualenv_init" && "$_pyenv_virtualenv_init" -nt "$_pyenv_init_cache" ) ]]; then
        command mkdir -p "$_pyenv_cache_dir"
        _pyenv_init_tmp="$_pyenv_init_cache.tmp.$$"

        if {
          ${lib.getExe pkgs.pyenv} init - --no-rehash zsh
          if [[ -e "$_pyenv_virtualenv_init" ]]; then
            ${lib.getExe pkgs.pyenv} virtualenv-init - zsh
          fi
        } >| "$_pyenv_init_tmp"; then
          command mv -f "$_pyenv_init_tmp" "$_pyenv_init_cache"
        fi
      fi

      [[ ! -r "$_pyenv_init_cache" ]] || source "$_pyenv_init_cache"

      unset _pyenv_cache_dir _pyenv_init_cache _pyenv_init_tmp _pyenv_virtualenv_init
    '';

    home.packages = with pkgs; [
      (python3.withPackages (ps:
        with ps; [
          pip
          readline
          sqlparse
          pudb
          python-lsp-server
          pylatexenc
        ]))
      pyright
      uv
    ];
  };

}
