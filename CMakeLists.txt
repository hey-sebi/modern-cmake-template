# ===========================================================================
#  CMake project setup
# ===========================================================================

cmake_minimum_required(VERSION 3.19)

# Provides the version from the version header
include(cmake/version.cmake)
parse_version()

project(replaceme
  LANGUAGES C CXX
  VERSION ${REPLACEME_VERSION}
)

# ---------------------------------------------------------------------------
#  Configuration
#   The project offers some configuration options that may be altered here.
#   In general those can be overwritten by cmake invocation with -D flags
#   or via CMake presets.
#
#   Example: -DENABLE_TESTING=OFF will overwrite the value configured here
# ---------------------------------------------------------------------------

option(ENABLE_INSTALL "Activates support for installing the project" ON)
option(ENABLE_TESTING "Activates support for unit tests" ON)
option(USE_SYSTEM_GTEST "Use system-installed GoogleTest instead of FetchContent" OFF)
option(ENABLE_CCACHE "Enables CCache integration if available" ON)
option(BUILD_SHARED_LIBS "Build libraries as shared instead of static" OFF)

# Set your C++ standard here
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ---------------------------------------------------------------------------
#  Setup for CTest / CCache / install dirs / warnings / formatting
# ---------------------------------------------------------------------------

# Install directories according to GNU standard
if(ENABLE_INSTALL)
  include(GNUInstallDirs)
endif()

# Compiler warnings and formatting targets
include(cmake/warnings.cmake)
include(cmake/format.cmake)

# CCache integration (optional, does not fail if ccache is absent)
if(ENABLE_CCACHE)
  find_program(CCACHE_FOUND ccache)
  if(CCACHE_FOUND)
    message(STATUS "Found CCache: ${CCACHE_FOUND}")
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_FOUND}")
  else()
    message(STATUS "CCache enabled in config, but 'ccache' executable was not found.")
  endif()
endif()

# ---------------------------------------------------------------------------
#  Find additionally required packages
#   If your project requires additional packages, you can add them here.
# ---------------------------------------------------------------------------

## Find threads library. Prefer pthread, if available.
# set(THREADS_PREFER_PTHREAD_FLAG ON)
# find_package(Threads REQUIRED)

## Find boost library with some components
# find_package(Boost REQUIRED
#   COMPONENTS
#   date_time
#   filesystem
#   thread
# )

# ---------------------------------------------------------------------------
#  Setup summary
# ---------------------------------------------------------------------------

message(STATUS "----------------------------------------------------------------------")
message(STATUS "Building ${CMAKE_PROJECT_NAME} in version ${CMAKE_PROJECT_VERSION}")
message(STATUS " C++ standard:       ${CMAKE_CXX_STANDARD}")
message(STATUS " Installing enabled: ${ENABLE_INSTALL}")
message(STATUS " Unit tests enabled: ${ENABLE_TESTING}")
if(ENABLE_TESTING)
  message(STATUS "  System GoogleTest: ${USE_SYSTEM_GTEST}")
endif()
message(STATUS " CCache enabled:     ${ENABLE_CCACHE}")
message(STATUS "----------------------------------------------------------------------")

# ===========================================================================
#  Build targets
# ===========================================================================

# Core library target
add_library(replaceme
  src/replaceme.cpp
  include/replaceme/replaceme.h
  include/replaceme/version.h
)

add_library(replaceme::replaceme ALIAS replaceme)

target_include_directories(replaceme
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_link_libraries(replaceme
  PRIVATE
    $<BUILD_INTERFACE:replaceme_warnings>
)

# CLI executable target
add_executable(replaceme_cli
  src/main.cpp
)

target_link_libraries(replaceme_cli
  PRIVATE
    replaceme::replaceme
    $<BUILD_INTERFACE:replaceme_warnings>
)

# ===========================================================================
#  Unit tests
# ===========================================================================

if(ENABLE_TESTING)
  include(CTest)
  enable_testing()
  add_subdirectory(test)
endif()

# ===========================================================================
#  Installation
# ===========================================================================

if(ENABLE_INSTALL)

  # Install targets and define the export targets
  install(
    TARGETS replaceme replaceme_cli
    EXPORT replacemeTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

  # Install public header directory
  install(
    DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

  # Define the replacemeTargets.cmake file and the namespace for exported targets
  install(
    EXPORT replacemeTargets
    FILE replacemeTargets.cmake
    NAMESPACE replaceme::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/replaceme
  )

  include(CMakePackageConfigHelpers)
  # Generate a replacemeConfigVersion.cmake file
  write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/replacemeConfigVersion.cmake"
    VERSION ${REPLACEME_VERSION}
    COMPATIBILITY SameMajorVersion
  )

  # Install the config files
  install(
    FILES
      "replacemeConfig.cmake"
      "${CMAKE_CURRENT_BINARY_DIR}/replacemeConfigVersion.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/replaceme
  )

endif()
