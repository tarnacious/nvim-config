# Personal Nix Vim Config

I somehow run into this great [blog post about setting up Neovim in a Nix
Flake][neovim-nix]. As I recently had problems getting the ChatGPT-nvim plugin
working with my existing configuration I decided to have a go at (re)building
my Neovim configuration from scratch.

I hope to completely replace my previous configuration and deploy it as part of
my system, but for now just trying some alternate plugin and bring over parts
of my previous configuration I need in the new one.

Start the custom Neovim with:

```
nix run
```

[neovim-nix]: https://primamateria.github.io/blog/neovim-nix
