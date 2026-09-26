#!/usr/bin/env bash
#  Usage: setup_project.sh [<project_name>] [--cleanup] [--no-git] [--amend] [--reset-git]
#
#  This script must be run on the repository's top level directory.
#  It configures the template for your new project:
#  - Replaces "replaceme" / "REPLACEME" / "Replaceme" across all project files.
#  - Renames files and directories to match your project name.
#  - Generates a fresh, project-specific README.md.
#  - Smart Git management: preserves remote if cloned via GitHub template,
#    or re-initializes if directly cloned from modern-cmake-template.
#  - Offers to clean up the setup scripts.

set -euo pipefail

if [ ! -f "CMakeLists.txt" ]; then
    echo "Error: This script must be run from the repository root directory (where CMakeLists.txt is located)."
    exit 1
fi

project_name=""
cleanup=false
no_git=false
amend=false
reset_git=false

for arg in "$@"; do
    case "$arg" in
        --cleanup)
            cleanup=true
            ;;
        --no-git)
            no_git=true
            ;;
        --amend)
            amend=true
            ;;
        --reset-git)
            reset_git=true
            ;;
        -h|--help|help)
            echo "Usage: $0 [<project_name>] [--cleanup] [--no-git] [--amend] [--reset-git]"
            exit 0
            ;;
        *)
            if [ -z "$project_name" ]; then
                project_name="$arg"
            fi
            ;;
    esac
done

if [ -z "$project_name" ]; then
    read -rp "Enter your project name (lowercase, no spaces, e.g. 'myproject'): " project_name
fi

if [ -z "$project_name" ]; then
    echo "Error: Project name cannot be empty."
    exit 1
fi

project_upper=$(echo "$project_name" | tr '[:lower:]' '[:upper:]')
project_title="$(tr '[:lower:]' '[:upper:]' <<< "${project_name:0:1}")${project_name:1}"

echo "Configuring template for project: $project_name..."

replace_in_file() {
    local file="$1"
    if [ -f "$file" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/replaceme/$project_name/g" "$file"
            sed -i '' "s/REPLACEME/$project_upper/g" "$file"
            sed -i '' "s/Replaceme/$project_title/g" "$file"
        else
            sed -i "s/replaceme/$project_name/g" "$file"
            sed -i "s/REPLACEME/$project_upper/g" "$file"
            sed -i "s/Replaceme/$project_title/g" "$file"
        fi
    fi
}

files_to_update=(
    "CMakeLists.txt"
    "CMakePresets.json"
    "replacemeConfig.cmake"
    "cmake/version.cmake"
    "cmake/warnings.cmake"
    "cmake/format.cmake"
    "include/replaceme/version.h"
    "include/replaceme/replaceme.h"
    "src/replaceme.cpp"
    "src/main.cpp"
    "test/CMakeLists.txt"
    "test/example_test.cpp"
    ".github/workflows/ci.yml"
)

for file in "${files_to_update[@]}"; do
    replace_in_file "$file"
done

# Rename files
echo "Renaming files..."
if [ -f "replacemeConfig.cmake" ]; then
    mv replacemeConfig.cmake "${project_name}Config.cmake"
fi

if [ -f "include/replaceme/replaceme.h" ]; then
    mv include/replaceme/replaceme.h "include/replaceme/${project_name}.h"
fi

if [ -f "src/replaceme.cpp" ]; then
    mv src/replaceme.cpp "src/${project_name}.cpp"
fi

# Rename include directory
if [ -d "include/replaceme" ]; then
    mv include/replaceme "include/${project_name}"
fi

# Generate clean README.md
echo "Generating project README.md..."
cat << EOF > README.md
# $project_title

A modern C++ project.

## Requirements

- CMake 3.19 or higher
- C++17 compatible compiler (GCC, Clang, or MSVC)
- Ninja or Make (optional, recommended)

## Building & Testing

### Using CMake Presets (Recommended)

Configure:
\`\`\`console
cmake --preset default
\`\`\`

Build:
\`\`\`console
cmake --build --preset default
\`\`\`

Run tests:
\`\`\`console
ctest --preset default
\`\`\`

### Manual Build

\`\`\`console
cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build
ctest --test-dir build --output-on-failure
\`\`\`

## Project Structure

\`\`\`
├── cmake/                # CMake modules (warnings, format, version)
├── include/$project_name/  # Public headers
├── src/                  # Library sources and CLI entrypoint
├── test/                 # GoogleTest unit tests (auto-fetched)
├── .clangd               # Clangd LSP configuration
├── CMakeLists.txt        # Root CMake configuration
└── CMakePresets.json     # Standardized build presets
\`\`\`

## Code Formatting

\`\`\`console
cmake --build --preset default --target format
\`\`\`

## Configuration Options

| Option | Default | Description |
| :--- | :--- | :--- |
| \`ENABLE_TESTING\` | \`ON\` | Builds unit tests using GoogleTest & CTest |
| \`USE_SYSTEM_GTEST\` | \`OFF\` | Uses system-installed GoogleTest instead of FetchContent |
| \`ENABLE_INSTALL\` | \`ON\` | Generates install and package config export targets |
| \`ENABLE_CCACHE\` | \`ON\` | Uses CCache if available on system PATH |
| \`ENABLE_WARNINGS_AS_ERRORS\` | \`OFF\` | Treats compiler warnings as fatal errors |
| \`BUILD_SHARED_LIBS\` | \`OFF\` | Builds library as shared (\`.so\`/\`.dll\`) instead of static |
EOF

# Smart Git repository handling
if [ "$no_git" = false ]; then
    is_git=false
    origin_url=""
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        is_git=true
        origin_url=$(git remote get-url origin 2>/dev/null || echo "")
    fi

    is_template_clone=false
    if [[ "$origin_url" =~ "modern-cmake-template" ]] || [ "$reset_git" = true ] || [ -z "$origin_url" ]; then
        is_template_clone=true
    fi

    if [ "$is_git" = false ]; then
        echo "Initializing fresh Git repository..."
        git init -b main
        git add .
        git commit -m "Initial commit for $project_name"
        echo "Git repository initialized on branch 'main'."
    elif [ "$is_template_clone" = true ]; then
        echo "Detected direct clone of modern-cmake-template. Re-initializing fresh Git repository..."
        rm -rf ".git"
        git init -b main
        git add .
        git commit -m "Initial commit for $project_name"
        echo "Git repository initialized on branch 'main'."
        echo ""
        echo "To link to your own GitHub repository:"
        echo "  git remote add origin <your-repo-url>"
        echo "  git push -u origin main"
    else
        echo "Detected user repository cloned from GitHub template (origin: $origin_url)."
        echo "Preserving remote and existing git history."

        do_amend="$amend"
        if [ "$amend" = false ] && [ -t 0 ]; then
            echo ""
            echo "How would you like to commit the setup changes?"
            echo "  [C] New commit (Recommended: push with standard 'git push')"
            echo "  [a] Amend initial commit (Creates a single clean root commit, requires 'git push --force')"
            read -rp "Choose commit mode [C/a]: " choice
            if [[ "$choice" =~ ^[aA] ]]; then
                do_amend=true
            fi
        fi

        git add .
        if [ "$do_amend" = true ]; then
            git commit --amend -m "Initial commit for $project_name"
            echo "Amended initial commit. To push your changes, run:"
            echo "  git push --force"
        else
            git commit -m "Initialize project $project_name from template"
            echo "Committed setup changes. To push your changes, run:"
            echo "  git push"
        fi
    fi
fi

# Self-cleanup option
if [ "$cleanup" = false ] && [ -t 0 ]; then
    echo ""
    read -rp "Do you want to delete the setup scripts now? [Y/n] " reply
    if [[ -z "$reply" || "$reply" =~ ^[yY] ]]; then
        cleanup=true
    fi
fi

if [ "$cleanup" = true ]; then
    echo "Cleaning up setup scripts..."
    rm -f script/setup_project.sh script/setup_project.ps1
    rmdir script 2>/dev/null || true
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git add -A
        git commit --amend --no-edit >/dev/null 2>&1 || true
    fi
fi

echo -e "\nSetup complete! Happy coding!"
