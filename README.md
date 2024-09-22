# Setup Rust Without Visual Studio

## [ Requirement & Installation ]
- https://www.msys2.org/

### Step 1
Inside MYSYS2, write the following code:
```bash
pacman -Sy && pacman -Syu
pacman -S --needed base-devel mingw-w64-x86_64-toolchain mingw-w64-x86_64-rust-src rust-analyzer mingw-w64-x86_64-rust
```

- `base-devel`: Minimal package set for building packages with makepkg
- `mingw-w64-x86_64-toolchain`: Toolchain for cross-compiling to 64-bit Windows
-  `mingw-w64-x86_64-rust-src`: Source code for the Rust standard library (mingw-w64)
-  `rust-analyzer`: A Rust compiler front-end for IDEs (mingw-w64)
-  `mingw-w64-x86_64-rust`: Systems programming language focused on safety, speed and concurrency (mingw-w64)

### Step 2
Open Environment Variables with `Windows + R`, then type `sysdm.cpl`. Add a new PATH inside `Path`.
```bash
# Add this
C:\msys64\usr\bin

# Then add this
C:\msys64\mingw64\bin
```

Okay, just these two steps and you can enjoy Rust.

But IT'S NOT OVER YET even though Rust is up and running.

You will see that there is an error like this when you try to use the rust-analyzer extension in visual studio code. This issue is related to Rust Analyzer not being able to find the appropriate Rust source.

```bash
Caused by:
  failed to read D:\<Directory>\<Directory>\<Program>\Cargo.toml

Caused by:
  The system cannot find the path specified. (os error 3)

2024-09-22T05:50:11.408584Z ERROR error="can't load standard library from sysroot\n{sysroot_path}\n(discovered via rustc --print sysroot)\ntry installing the Rust source the same way you installed rustc"
2024-09-22T05:50:12.183249Z ERROR error="can't load standard library from sysroot\n{sysroot_path}\n(discovered via rustc --print sysroot)\ntry installing the Rust source the same way you installed rustc"
```

### Step 3 (additional)
Add this in the `settings.json` vscode.
```json
{
  "rust-analyzer.server.extraEnv": {
      "RUST_SRC_PATH": "C:\\msys64\\mingw64\\lib\\rustlib\\src\\rust\\library"
  },
  "rust-analyzer.cargo.sysroot": "C:\\msys64\\mingw64",
  "rust-analyzer.checkOnSave.command": "check"
}
```

Set the environment variable manually:
Open PowerShell as administrator and run it:
```bash
[Environment]::SetEnvironmentVariable("RUST_SRC_PATH", "C:\msys64\mingw64\lib\rustlib\src\rust\library", "User")
[Environment]::SetEnvironmentVariable("CARGO_HOME", "C:\msys64\home\YourUsername\.cargo", "User")
[Environment]::SetEnvironmentVariable("RUSTUP_HOME", "C:\msys64\home\YourUsername\.rustup", "User")
```

Replace `YourUsername` with your username in MSYS2.
and you'll see Rust works perfectly ✨

## [ Troubleshoting ]

### My MSYS2 cannot run vscode
Add this into `.bashrc` in  MSYS2:
```bash
export PATH=$PATH:/c/Users/Admin/AppData/Local/Programs/Microsoft\ VS\ Code/bin
```

reapply the changes to the .bashrc file:
```bash
source ~/.bashrc
```
