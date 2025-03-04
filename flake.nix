{
  description = "Kernel module development environment for Linux 6.12";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        targetKernel = pkgs.linuxPackages_6_13;

        # Generate compile_commands.json for the kernel
        # This will allow LSP servers to understand kernel code
      in {
        devShells = {
          # Basic development shell (original)
          default = pkgs.mkShell {
            name = "kernel-dev-environment";

            buildInputs = with pkgs; [
              gnumake
              gcc
              pkg-config
              targetKernel.kernel.dev
            ];

            shellHook = ''
              export KERNELDIR="${targetKernel.kernel.dev}/lib/modules/${targetKernel.kernel.version}/build"
              export KERNEL_VERSION="${targetKernel.kernel.version}"
              echo "Kernel development environment set up for Linux ${targetKernel.kernel.version}"
            '';
          };

          # Enhanced development shell with LSP support
          lsp = pkgs.mkShell {
            name = "kernel-dev-environment-with-lsp";

            buildInputs = with pkgs; [
              # Basic development tools
              gnumake
              gcc
              pkg-config

              # Clang toolchain for LSP support
              clang
              clang-tools # Includes clangd
              llvm
              lldb

              # LSP support tools
              bear # For generating compile_commands.json
              compiledb

              # Kernel specific
              targetKernel.kernel.dev

            ];

            shellHook = ''
              export KERNELDIR="${targetKernel.kernel.dev}/lib/modules/${targetKernel.kernel.version}/build"
              export KERNEL_VERSION="${targetKernel.kernel.version}"
              export PROJECT_DIR="$PWD"

              # Generate .clangd configuration file for kernel development
              cat > .clangd << EOF
              CompileFlags:
                Add: [-ferror-limit=0, -fno-color-diagnostics]
                Remove: [-mno-80387, -mno-fp-ret-in-387, -mpreferred-stack-boundary=3]
              Diagnostics:
                UnusedIncludes: Moderate
                MissingIncludes: None
              Index:
                Background: Build
              EOF

              # Create symlink to kernel headers if not present
              if [ ! -d "./kernel-headers" ]; then
                ln -sf $KERNELDIR/include ./kernel-headers
              fi

              echo "Kernel development environment set up for Linux ${targetKernel.kernel.version}"
              echo "LSP support is enabled with clangd"
              echo "Run 'generate-compile-commands' to create compile_commands.json for LSP"
              echo "Make sure your editor is configured to use clangd"
            '';
          };
        };
      });
}
