# Linux Kernel Module Development Environment

A Nix-based development environment for Linux kernel module development, with LSP (Language Server Protocol) support for enhanced code intelligence.

## Overview

This project provides a ready-to-use development environment for building Linux kernel modules using Nix. It includes:

- A preconfigured development environment with all necessary tools
- Helper scripts for generating compile commands database
- Example kernel module code to get started

## Requirements

- [Nix package manager](https://nixos.org/download.html) with flakes enabled
- Git

## Getting Started

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd kernel-dev
   ```

2. Enter the development shell:
   ```bash
   # Basic development shell
   nix develop
   
   # Or, for enhanced LSP support
   nix develop .#lsp
   ```

3. Build the example module:
   ```bash
   cd src
   make
   ```

4. If using the LSP shell, generate compile commands for code intelligence:
   ```bash
   generate-compile-commands
   ```

## Project Structure

```
.
├── compile_commands.json  # Generated for LSP support
├── flake.lock             # Nix flake lock file
├── flake.nix              # Nix flake configuration
├── kernel-headers         # Symlink to kernel headers
└── src/                   # Source code directory
    ├── example.c          # Example kernel module
    └── Makefile           # Build configuration
```

## Development Shells

This project provides two development shells:

1. **Default Shell** (`nix develop`):
   - Basic kernel module development environment
   - Includes essential tools like gcc, make, and kernel headers

2. **LSP Shell** (`nix develop .#lsp`):
   - Enhanced environment with LSP support
   - Includes clang, clangd, and other tools for better code intelligence
   - Provides the `generate-compile-commands` script

## Creating Your Own Kernel Module

1. Copy the example module as a starting point:
   ```bash
   cp src/example.c src/mymodule.c
   ```

2. Update the Makefile to build your new module:
   ```makefile
   obj-m := mymodule.o
   ```

3. Implement your module functionality in the new file

4. Build your module:
   ```bash
   make
   ```

## Testing Your Module

To test your kernel module:

```bash
# Load the module
sudo insmod example.ko

# Check if it's loaded
lsmod | grep example

# View kernel logs
dmesg | tail

# Unload the module
sudo rmmod example
```

## LSP Configuration

The `.clangd` file is automatically generated when using the LSP shell. This configuration helps clangd understand kernel code better by:

- Adjusting compiler flags
- Setting diagnostic levels
- Configuring indexing behavior

## License

This project is licensed under the GPL License - see the LICENSE file for details.

