#!/bin/bash

#  Usage: setup_project.sh <your_project_name>
#         or
#         setup_project.sh --help
#
#  This script must be run on the repository's top level directory.
#  It replaces file names, directory names and strings in files that match the string
#  "replaceme" in a case preserving manner.
#  It also deletes the .git directory to make room for your own source code versioning.

# Get the absolute path of the script directory
working_dir=$(pwd)

# Check if script is run in the top-level directory of a Git repository
if [ "$(git -C "$working_dir" rev-parse --is-inside-work-tree 2>/dev/null)" != "true" ]; then
    echo "Error: This script must be run within a Git repository's top-level directory."
    exit 1
fi

# Check if project name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

if [ $1 == "help" ]  || [ $1 == "--help" ] || [ $1 == "-h" ]; then
    echo "Usage: $0 <project_name>"
    echo ""
    echo "This script must be run on the repository's top level directory."
    echo "It replaces file names, directory names and strings in files that match the string"
    echo "\"replaceme\" in a case preserving manner."
    echo "It also deletes the .git directory to make room for your own source code versioning."
    exit 0
fi

# Replaces all template strings in a file.
# Expects one parameter: the filename.
replace_in_file() {
    local filename="$1"
    echo "Replacing lowercase occurrances in $filename"
    sed -i "s/replaceme/$project_name/g" "$filename"
    echo "Replacing uppercase occurrances in $filename"
    sed -i "s/REPLACEME/${project_name^^}/g" "$filename"
}

# Get project name from command line argument
project_name="$1"

# replace file contents
replace_in_file "CMakeLists.txt"
replace_in_file "cmake/version.cmake"
replace_in_file "include/replaceme/version.h"

# rename directories
echo "renaming include/replaceme/"
mv ./include/replaceme/ ./include/$project_name

echo "Replacement completed."

echo "Deleting repository git information"
rm -rf ".git"

echo "Done. Happy coding!"
