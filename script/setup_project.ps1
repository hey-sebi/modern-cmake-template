#  Usage: setup_project.ps1 <your_project_name>
#         or
#         setup_project.ps1 --help
#
#  This script must be run on the repository's top level directory.
#  It replaces file names, directory names and strings in files that match the string
#  "replaceme" in a case preserving manner.
#  It also deletes the .git directory to make room for your own source code versioning.

param (
    [string]$project_name
)

# Function to replace strings in a file
function Replace-InFile {
    param (
        [string]$filename
    )

    Write-Host "Replacing lowercase occurrences in $filename"
    (Get-Content $filename) | ForEach-Object {$_ -replace 'replaceme', $project_name} | Set-Content $filename
    Write-Host "Replacing uppercase occurrences in $filename"
    (Get-Content $filename) | ForEach-Object {$_ -replace 'REPLACEME', $project_name.ToUpper()} | Set-Content $filename
}

# Check if project name is provided
if (-not $project_name) {
    Write-Host "Usage: $MyInvocation.MyCommand <project_name>"
    exit 1
}

# Check if script is run in the top-level directory of a Git repository
$working_dir = Get-Location
if (-not (Test-Path (Join-Path $working_dir ".git"))) {
    Write-Host "Error: This script must be run within a Git repository's top-level directory."
    exit 1
}

# replace file contents
Replace-InFile "CMakeLists.txt"
Replace-InFile "cmake/version.cmake"
Replace-InFile "include/replaceme/version.h"

# rename directories
Write-Host "Renaming include/replaceme/"
Move-Item -Path "./include/replaceme/" -Destination ("./include/$project_name")

Write-Host "Replacement completed."

Write-Host "Deleting repository git information"
Remove-Item -Path ".git" -Recurse -Force

Write-Host "Done. Happy coding!"
