# nix-files

My [Nix](https://nixos.org/download.html) / [nix-darwin](https://github.com/LnL7/nix-darwin) / [Home Manager](https://github.com/LnL7/nix-darwin) configuration.

## Use

```sh
darwin-rebuild switch --flake .
```

# Notes:

Not covered in install:

* Docker Desktop
* JDKs + JREs (manually managed)
* Idea
* Vendor internal tools (homebrew'ed)
* qmk ([bug in nix pkg](https://discourse.nixos.org/t/what-is-the-difference-between-aarch64-apple-darwin-and-aarch64-darwin-and-why-are-they-incompatible/27568))

Misc: 

* python environments via [zsh-pyenv](https://github.com/mattberther/zsh-pyenv) 
