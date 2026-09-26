#  Usage: setup_project.ps1 [<project_name>] [-Cleanup] [-NoGit]
#
#  This script must be run on the repository's top level directory.
#  It configures the template for your new project:
#  - Replaces "replaceme" / "REPLACEME" / "Replaceme" across all project files.
#  - Renames files and directories to match your project name.
#  - Generates a fresh, project-specific README.md.
#  - Re-initializes a clean Git repository with an initial commit.
#  - Offers to clean up the setup scripts.

param (
    [Parameter(Position = 0)]
    [string]$ProjectName,
    [switch]$Cleanup,
    [switch]$NoGit
)

$ErrorActionPreference = "Stop"

# Ensure run from repository root
if (-not (Test-Path "CMakeLists.txt")) {
    Write-Error "Error: This script must be run from the repository root directory (where CMakeLists.txt is located)."
    exit 1
}

# Prompt for project name if not provided
if (-not $ProjectName) {
    $ProjectName = Read-Host "Enter your project name (lowercase, no spaces, e.g. 'myproject')"
}

if (-not $ProjectName) {
    Write-Error "Error: Project name cannot be empty."
    exit 1
}

# Trim whitespace
$ProjectName = $ProjectName.Trim()
$ProjectUpper = $ProjectName.ToUpper()
$ProjectTitle = (Get-Culture).TextInfo.ToTitleCase($ProjectName)

Write-Host "Configuring template for project: $ProjectName..." -ForegroundColor Cyan

function Replace-InFile {
    param ([string]$Path)
    if (Test-Path $Path) {
        $content = Get-Content -Raw $Path
        $content = $content -creplace 'replaceme', $ProjectName
        $content = $content -creplace 'REPLACEME', $ProjectUpper
        $content = $content -creplace 'Replaceme', $ProjectTitle
        Set-Content -Path $Path -Value $content -NoNewline
    }
}

# Update file contents
$filesToUpdate = @(
    "CMakeLists.txt",
    "CMakePresets.json",
    "replacemeConfig.cmake",
    "cmake/version.cmake",
    "cmake/warnings.cmake",
    "cmake/format.cmake",
    "include/replaceme/version.h",
    "include/replaceme/replaceme.h",
    "src/replaceme.cpp",
    "src/main.cpp",
    "test/CMakeLists.txt",
    "test/example_test.cpp",
    ".github/workflows/ci.yml"
)

foreach ($file in $filesToUpdate) {
    Replace-InFile $file
}

# Rename files
Write-Host "Renaming files..."
if (Test-Path "replacemeConfig.cmake") {
    Move-Item -Path "replacemeConfig.cmake" -Destination "${ProjectName}Config.cmake"
}

if (Test-Path "include/replaceme/replaceme.h") {
    Move-Item -Path "include/replaceme/replaceme.h" -Destination "include/replaceme/${ProjectName}.h"
}

if (Test-Path "src/replaceme.cpp") {
    Move-Item -Path "src/replaceme.cpp" -Destination "src/${ProjectName}.cpp"
}

# Rename include directory
if (Test-Path "include/replaceme") {
    Move-Item -Path "include/replaceme" -Destination "include/${ProjectName}"
}

# Generate clean README.md
Write-Host "Generating project README.md..."
$readmeContent = @"
# $ProjectTitle

A modern C++ project.

## Requirements

- CMake 3.19 or higher
- C++17 compatible compiler (GCC, Clang, or MSVC)
- Ninja or Make (optional, recommended)

## Building & Testing

### Using CMake Presets (Recommended)

Configure:
````console
cmake --preset default
````

Build:
````console
cmake --build --preset default
````

Run tests:
````console
ctest --preset default
````

### Manual Build

````console
cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build
ctest --test-dir build --output-on-failure
````

## Project Structure

````
├── cmake/                # CMake modules (warnings, format, version)
├── include/$ProjectName/  # Public headers
├── src/                  # Library sources and CLI entrypoint
├── test/                 # GoogleTest unit tests (auto-fetched)
├── CMakeLists.txt        # Root CMake configuration
└── CMakePresets.json     # Standardized build presets
````

## Code Formatting

````console
cmake --build --preset default --target format
````

## Configuration Options

| Option | Default | Description |
| :--- | :--- | :--- |
| `ENABLE_TESTING` | `ON` | Builds unit tests using GoogleTest & CTest |
| `USE_SYSTEM_GTEST` | `OFF` | Uses system-installed GoogleTest instead of FetchContent |
| `ENABLE_INSTALL` | `ON` | Generates install and package config export targets |
| `ENABLE_CCACHE` | `ON` | Uses CCache if available on system PATH |
| `ENABLE_WARNINGS_AS_ERRORS` | `OFF` | Treats compiler warnings as fatal errors |
| `BUILD_SHARED_LIBS` | `OFF` | Builds library as shared (`.so`/`.dll`) instead of static |
"@

Set-Content -Path "README.md" -Value $readmeContent

# Reset Git repository
if (-not $NoGit) {
    Write-Host "Re-initializing fresh Git repository..." -ForegroundColor Cyan
    if (Test-Path ".git") {
        Remove-Item -Path ".git" -Recurse -Force
    }
    try {
        git init -b main
        git add .
        git commit -m "Initial commit for $ProjectName"
        Write-Host "Git repository initialized on branch 'main'." -ForegroundColor Green
    } catch {
        Write-Warning "Could not initialize Git repository automatically: $_"
    }
}

# Self-cleanup option
$doCleanup = $Cleanup
if (-not $Cleanup -and [Environment]::UserInteractive) {
    $reply = Read-Host "Do you want to delete the setup scripts now? [Y/n]"
    if ($reply -eq "" -or $reply -match "^[yY]") {
        $doCleanup = $true
    }
}

if ($doCleanup) {
    Write-Host "Cleaning up setup scripts..."
    Remove-Item -Path "script/setup_project.ps1", "script/setup_project.sh" -Force -ErrorAction SilentlyContinue
    if ((Get-ChildItem -Path "script" -Force | Measure-Object).Count -eq 0) {
        Remove-Item -Path "script" -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path ".git") {
        git add -A
        git commit -m "Remove setup scripts" --amend --no-edit 2>$null
    }
}

Write-Host "`nSetup complete! Happy coding!" -ForegroundColor Green
