# Modern CMake Template

A modern, production-ready starter template for C/C++ projects using CMake (3.19+).

## Features

- **Standard Modern CMake Architecture**:
  - Modular target layout: Core Library (`replaceme`) + CLI Application
    (`replaceme_cli`) + Unit Tests (`replaceme_test`).
  - Target include directories separated cleanly via `$<BUILD_INTERFACE:...>` and
    `$<INSTALL_INTERFACE:...>`.
  - Namespaced alias targets (`replaceme::replaceme`).
- **CMake Presets (`CMakePresets.json`)**:
  - Pre-configured `relwithdebinfo` (default), `debug`, and `release` presets for
    configure, build, and test steps.
  - Native integration with Visual Studio, CLion, and the command line.
- **Zero-Friction Unit Testing**:
  - Automated dependency fetching with `FetchContent` for
    [Google Test](https://github.com/google/googletest) (no system installation required).
  - Test discovery via CTest (`gtest_discover_tests`).
- **Strict Warnings & Analysis**:
  - Modular compiler warnings (`cmake/warnings.cmake`) for MSVC, GCC, and Clang.
  - Optional `ENABLE_WARNINGS_AS_ERRORS` flag.
- **Code Formatting**:
  - Clang-format configuration (`.clang-format`) with Google style.
  - Built-in CMake targets: `format` and `format-check`.
- **Packaging & Installation**:
  - CMake package export (`<Project>Config.cmake`, `<Project>ConfigVersion.cmake`,
    `<Project>Targets.cmake`).
  - GNU standard directory installation (`GNUInstallDirs`).
- **Continuous Integration**:
  - Multi-platform GitHub Actions workflow (`.github/workflows/ci.yml`) testing Linux
    (GCC/Clang), Windows (MSVC), and macOS.
- **End-to-End Setup Script**:
  - Renames all tokens, files, and directories.
  - Generates a fresh project README.
  - Automatically re-initializes Git with a clean initial commit.
  - Cleans up setup scripts automatically.

---

## Quick Start / Setup

1. **Clone this repository**:

   ```console
   git clone https://github.com/hey-sebi/modern-cmake-template.git my-awesome-project
   cd my-awesome-project
   ```

2. **Run the setup script**:
   - **Linux / macOS**:

     ```console
     ./script/setup_project.sh myproject
     ```

   - **Windows (PowerShell)**:

     ```console
     ./script/setup_project.ps1 myproject
     ```

   The script will:
   - Replace template names across all project files.
   - Rename headers and source files to match your project.
   - Generate a clean project `README.md`.
   - Initialize a fresh Git repository on branch `main` with an initial commit.
   - Offer to delete the setup scripts.

---

## Building and Running

### Using CMake Presets (CMake 3.19+)

Configure:

```console
cmake --preset default
```

Build:

```console
cmake --build --preset default
```

Run tests:

```console
ctest --preset default
```

Run the CLI app:

- **Windows**: `.\build\default\Debug\replaceme_cli.exe`
- **Linux/macOS**: `./build/default/replaceme_cli`

### Manual Invocation

```console
cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build
ctest --test-dir build --output-on-failure
```

---

## Directory Structure

```
├── .github/
│   └── workflows/ci.yml   # Multi-platform CI pipeline
├── cmake/
│   ├── format.cmake       # Clang-format targets
│   ├── version.cmake      # Semantic version parsing
│   └── warnings.cmake    # Compiler warning presets
├── include/
│   └── replaceme/
│       ├── replaceme.h    # Public library headers
│       └── version.h      # Semantic version header
├── src/
│   ├── main.cpp           # CLI application entry point
│   └── replaceme.cpp      # Library implementation
├── test/
│   ├── CMakeLists.txt     # Test target & FetchContent GTest
│   └── example_test.cpp   # Sample unit tests
├── .clang-format          # Formatting rules
├── CMakeLists.txt         # Root CMakeLists
└── CMakePresets.json      # Standard build & test presets
```

---

## Configuration Options

Configure these in `CMakeLists.txt` or via `-D<OPTION>=<ON|OFF>`:

| Option                      | Default | Description                                               |
| :-------------------------- | :------ | :-------------------------------------------------------- |
| `ENABLE_TESTING`            | `ON`    | Builds unit tests using GoogleTest & CTest                |
| `USE_SYSTEM_GTEST`          | `OFF`   | Uses system-installed GoogleTest instead of FetchContent  |
| `ENABLE_INSTALL`            | `ON`    | Generates install and package config export targets       |
| `ENABLE_CCACHE`             | `ON`    | Uses CCache if available on system PATH                   |
| `ENABLE_WARNINGS_AS_ERRORS` | `OFF`   | Treats compiler warnings as fatal errors                  |
| `BUILD_SHARED_LIBS`         | `OFF`   | Builds library as shared (`.so`/`.dll`) instead of static |
