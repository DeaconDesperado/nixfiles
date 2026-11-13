{ inputs, lib, config, pkgs, ... }:
with lib;
let
  cfg = config.development.doc;

  # Minimal TeX distribution; latexmk drives compilation for vimtex
  texlive-latexmk = pkgs.texlive.withPackages (ps:
    with ps; [
      scheme-basic
      latexmk
      collection-fontsrecommended
      collection-latexrecommended
      # todo notes and colored boxes for research docs;
      # deps (pgf, environ, xkeyval, ...) resolve automatically
      environ
      enumitem
      pdfcol
      tcolorbox
      todonotes
      trimspaces
    ]);

  # sioyek 2.0.0 resolves default configs, tutorial and shaders from
  # sioyek.app/Contents/Resources, but the nixpkgs darwin build ships them
  # in Contents/MacOS — without the shaders the viewer renders blank pages.
  # Mirror the resources into Resources/ until the package catches up.
  sioyek-fixed = pkgs.sioyek.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + optionalString
      pkgs.stdenv.hostPlatform.isDarwin ''
        RES=$out/Applications/sioyek.app/Contents/Resources
        MAC=$out/Applications/sioyek.app/Contents/MacOS
        mkdir -p $RES
        cp -r $MAC/shaders $RES/shaders
        cp $MAC/prefs.config $MAC/prefs_user.config $MAC/keys.config $MAC/keys_user.config $MAC/tutorial.pdf $RES/
      '';
  });
in {

  options.development.doc = {
    enable = mkEnableOption "Enable doc development";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      ltex-ls
      sioyek-fixed
      texlab
      texlive-latexmk
    ];

    # Vimtex: editing, compilation (latexmk) and viewing (sioyek)
    programs.neovim.plugins = with pkgs; [
      {
        plugin = vimPlugins.vimtex;
        type = "lua";
        config = builtins.readFile (./config/neovim/lsp/vimtex.lua);
      }
    ];

    # texlab for completion, hover and diagnostics;
    # compilation stays with vimtex
    neovim-lsps.lsp-setups = {
      texlab = builtins.readFile (./config/neovim/lsp/texlab.lua);
    };
  };
}
