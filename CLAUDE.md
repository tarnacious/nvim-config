# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal Neovim configuration built with Nix flakes. The configuration uses Nix overlays to package Neovim with custom plugins and settings, creating a self-contained development environment.

## Key Commands

### Building and Running
- `nix run` - Start the custom Neovim configuration
- `nix run github:tarnacious/nvim-config` - Run from GitHub directly

### Testing
- `<leader>tf` - Run test command on current file (uses `mpb test` for Python files, `npm test` for others)

### Development Tools
- `ruff` - Python linting and formatting (available in runtime)
- Language servers included: typescript-language-server, pyright, nil (Nix), ruff-lsp

## Architecture

### Nix Configuration Structure
- `flake.nix` - Main flake definition with overlays for supported systems
- `custom-neovim.nix` - Neovim package configuration with plugins and runtime dependencies
- `load-config.nix` - Dynamic configuration loader that processes files from `config/` directory

### Configuration Loading System
The configuration uses a custom Nix function in `load-config.nix` that:
- Automatically loads all files from `config/lua/` and `config/vim/` directories
- Handles `.nix` files by importing them as Nix expressions
- Processes regular files by reading their content directly
- Generates appropriate `luafile` or `source` commands

### Plugin Architecture
All plugins are defined in `custom-neovim.nix` and include:
- File management: NerdTree, Telescope
- LSP: nvim-lspconfig with TypeScript, Python (pyright/ruff), and Nix support
- Completion: nvim-cmp with LSP and buffer sources
- Git integration: gitsigns
- Custom JIRA tools integration for project management

### Custom JIRA Integration
The configuration includes comprehensive JIRA ticket management:
- Ticket detection under cursor with `[A-Z]+-\d+` pattern
- Commands: `:JiraOpen`, `:JiraEdit`, `:JiraImprove`, `:JiraUpdate`
- Requires external jira-tools project at `/Users/tarn.barford/projects/lovelace/projects/jira-tools`

### Key Mappings
- Leader key: `,` (comma)
- `<leader>y`/`<leader>p` - System clipboard operations
- `<leader>jo` - Open JIRA ticket under cursor
- `<leader>je` - Edit JIRA ticket under cursor
- `<leader>tf` - Run tests on current file
- `<leader>fn` - Copy full file path to clipboard

## Important Notes
- The configuration auto-removes trailing whitespace on save
- Uses Tokyo Night color scheme
- Treesitter folding enabled with high fold level (99)
- Terminal buffers can be cleaned with `:DeleteTerminals` command
- Python files use `mpb test` command, others use `npm test`