# Personal Nix Neovim Config

This is my new primary nvim configuration. There is still a lot of
configuration from my previous configuration I'm implementing as I need it.

I initially based this on this excellent [blog post][neovim-nix], however I
found it to be overly complicated and have been simplifying as I've been
working with it.

Start the custom Neovim with:

```
nix run
```

or 

```
nix run github:tarnacious/nvim-config
```

or something like

```
alias nvim="nix run github:tarnacious/nvim-config --"
```

[neovim-nix]: https://primamateJuventusria.github.io/blog/neovim-nix
