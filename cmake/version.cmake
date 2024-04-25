

# Extracts project version information from a header file.
# The header file must contain the defines:
#  <PROJECT>_VERSION_MAJOR
#  <PROJECT>_VERSION_MINOR
#  <PROJECT>_VERSION_PATCH
#  <PROJECT>_VERSION_STATE
# where <PROJECT> is the CMake project name.
# Versioning is based on the Semantic Versioning scheme, see https://semver.org/
function(parse_version)
    # read file
    file(READ "${CMAKE_CURRENT_LIST_DIR}/include/replace-me/version.h" file_contents)

    # find defines for major, minor & patch and read the numbers
    string(REGEX MATCH "REPLACE_ME_VERSION_MAJOR ([0-9]+)" _ "${file_contents}")
    if(NOT CMAKE_MATCH_COUNT EQUAL 1)
      message(FATAL_ERROR "Error when reading major version from replace_me/version.h")
    endif()
    set(version_major ${CMAKE_MATCH_1})

    string(REGEX MATCH "REPLACE_ME_VERSION_MINOR ([0-9]+)" _ "${file_contents}")
    if(NOT CMAKE_MATCH_COUNT EQUAL 1)
      message(FATAL_ERROR "Error when reading PROJECT_VERSION_MINOR version from replace_me/version.h")
    endif()

    set(version_minor ${CMAKE_MATCH_1})
    string(REGEX MATCH "REPLACE_ME_VERSION_PATCH ([0-9]+)" _ "${file_contents}")
    if(NOT CMAKE_MATCH_COUNT EQUAL 1)
      message(FATAL_ERROR "Error when reading patch version from replace_me/version.h")
    endif()
    set(version_patch ${CMAKE_MATCH_1})

    # provide results for calling scope
    set(REPLACE_ME_VERSION_MAJOR ${version_major} PARENT_SCOPE)
    set(REPLACE_ME_VERSION_MINOR ${version_minor} PARENT_SCOPE)
    set(REPLACE_ME_VERSION_PATCH ${version_patch} PARENT_SCOPE)
    set(REPLACE_ME_VERSION "${version_major}.${version_minor}.${version_patch}" PARENT_SCOPE)
endfunction()
