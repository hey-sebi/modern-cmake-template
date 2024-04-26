# modern-cmake-template
Template for starting a C/C++ CMake project.

## Feature summary

*All features are optional*

* Code formatting via clang-format
* Unit testing using CTest & Google Test
* Faster compilation using CCache
* Directory structure prepared for typical use cases
* Example setup for
  * a hello world program
  * finding external packages
  * generating unit tests

## Goal of the template

Goal of all this is to provide a starting point for a C/C++ CMake projekt and to
reduce repetitive boilerplate that is necessary every time a new project is started. The
template aims to be configurable for your needs and provides examples for e.g. finding
packages or adding CMake targets. Some parts can simply be activated by uncommenting the
code, others can be enabled or disabled in a config section / by passing some arguments
when calling cmake.

Feel free to use the template and adjust it to your needs.


## Template values

The template uses `replaceme` as indicator that this file / directory / string should be
yet replaced by your project name. You don't have to do that manually, there are scripts
that can do that. See [Installation](#installation).

## Directory structure

The following directories are already available for the purposes shown below:

```
├── ci/                   # For continuous integration files
├── cmake/                # For CMake macros / scripts
├── doc/                  # For documentation
├── example/              # For example programs
├── script/               # For utility bash/powershell scripts
├── include/
│     └── replaceme/      # For public header files
├── src/                  # For .cpp files and private headers
└── test/                 # For unit tests
```

## Installation

1. Clone this repository into an empty directory:<br>
   Using HTTPS: <br>
   ```console
   $ git clone https://github.com/hey-sebi/modern-cmake-template.git
   ```
   Using SSH: <br>
   ```console
   $ git clone git@github.com:hey-sebi/modern-cmake-template.git
   ```
1. Use a script matching your operating system in order to replace template values /
   directory names with the name of your project. These scripts will ask you for the
   project name and also delete the `.git` directory so that you can setup your own
   version control.<br>
   From the repository root directory run<br>
   * on Linux/MacOS<br>
   ```console
   $ ./script/setup_project.sh <yourprojectname>`
   ```
   * on Windows<br>
   ```console
   $ ./script/setup_project.ps1 <yourprojectname>`
   ```

   *You should use a project name without spaces here.*
1. Delete the `script/setup_project.*` files as you probably don't need them anymore.

## General usage

### Example programs
The repository contains a simple "hello world" program that you can use to test if
  compilation works or as example on how to build an executable. See `src` directory.

In addition there is an example unit test in the `test` directory.

### Versioning
There is a version header file `version.h` which defines the project's version according
  to a semantic versioning scheme (see also https://semver.org/). This way, you can use
  the version number in your code, e.g. for logging or similar. Simply change the numbers
  in this file to modify the version of the project.

### Enabling / disabling features

There is a section called "Configuration" in the top-level `CMakeLists.txt` where you can
  see different aspects that can be configured. Alternatively you can overwrite the
  configured values by passing `-D<the-value>=off` or `-D<the-value>=on` respecively. The
  configuration section can also be extended to contain options for your project.

### Code formatting

Code formatting is setup to be used with [Clang
Format](https://clang.llvm.org/docs/ClangFormat.html). The configuration file is
`.clang-format` and is set to use the Google Style. Adjust it to your needs.

## Getting started with CMake

Skip this section if you are already familiar with CMake.

To trigger CMake, a typical approach would be:
1. Create a build directory: `mkdir build`
2. Go to that directory: `cd build`
3. Call CMake: `cmake ..`

The `cmake` command takes the directory of a CMakeLists.txt as argument, so we provide the
parent directory.

This is called an *out of source build*, as generated files are not mixed with our source
code but instead placed into the `build` directory, which is a good approach. You should
always use out of source builds, as it makes a lot of things easier, e.g. you will always
know what files to delete in order to force a 100% clean build.

You can use different *generators* with CMake. If no generator is provided, CMake works
with Makefiles. A good alternative is using [Ninja](https://ninja-build.org/). In this
case your cmake invokation would look like this:

```console
$ cmake -GNinja ..
```
Other generators exist, e.g. for some IDEs as well. More information can be found at [the
official CMake
website](https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html).

There are many CMake tutorials available online, so I won't go into detail here any
further. A good starting point, especially regarding *modern* CMake style (available since
CMake v3.0), is this digest: https://cliutils.gitlab.io/modern-cmake/
