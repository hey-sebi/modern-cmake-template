# modern-cmake-template
Template for starting a C/C++ CMake project.

Goal of the template is to provide a starting point for a C/C++ CMake projekt and to
reduce repetitive boilerplate that is necessary every time a new project is started. The
template aims to be configurable for your needs and provides examples for e.g. finding
packages or adding CMake targets. Some parts can simply be activated by uncommenting the
code, others can be enabled or disabled in a config section / by passing some arguments
when calling cmake.

Feel free to use the template and adjust it to your needs.

## Configuration

There is a section called "Configuration" in the toplevel `CMakeLists.txt` where you can
see different aspects that can be configured. Alternatively you can overwrite the configured
values by passing `-D<the-value>=off` or `-D<the-value>=on` respecively.

The configuration section can also be extended to contain options for your project.

## Template values

The template uses `replace-me` as indicator that this file / directory / string should be
yet replaced by your project name. You don't have to do that manually, there are scripts
that can do that. See [Installation](#installation).

## Directory structure

```
├── ci                   # For continuous integration files
├── cmake                # For CMake macros / scripts
├── doc                  # For documentation
├── example              # For example programs
├── script               # For utility bash/powershell scripts
├── include
|     └── replace-me     # For public header files
├── src                  # For .cpp files and private headers
└── test                 # For unit tests
```

## Installation

1. Clone this repository into an empty directory:<br>
   Using HTTPS: ``git clone https://github.com/hey-sebi/modern-cmake-template.git``<br>
   Using SSH: ``git clone git@github.com:hey-sebi/modern-cmake-template.git``
2. Use a script matching your operating system in order to replace template values /
   directory names with the name of your project. These scripts will ask you for the
   project name and also delete the `.git` directory so that you can setup your own
   version control.<br>
   From the repository root directory run<br>
   * `./script/setup_project.sh` on Linux/MacOS
   * `./script/setup_project.ps1` on Windows
3. Delete the `script/setup_project.*` files as you probably don't need them anymore.

