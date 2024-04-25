# ===========================================================================
#  CMake project setup
# ===========================================================================

cmake_minimum_required(VERSION 3.14)

include(cmake/version.cmake)

parse_version()

project(replace-me
  LANGUAGES C CXX
  VERSION ${REPLACE_ME_VERSION}
)


# ---------------------------------------------------------------------------
#  Configuration
#   The project offers some configuration options that may be altered here.
#   In general those can be overwritten by cmake invokation with -D command
#   line options.
#
#   Example: -DENABLE_TESTING=off will overwrite the value configured here
#
# ---------------------------------------------------------------------------

option(ENABLE_INSTALL "Activates support for installing the project" ON)
option(ENABLE_TESTING "Activates support for unit tests" ON)
# For more information on CCache see https://ccache.dev/
option(ENABLE_CCACHE "Enables CCache integration" ON)

# Set your C++ version here
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


# ---------------------------------------------------------------------------
#  Setup for CTest / CCache / install dirs
# ---------------------------------------------------------------------------

# Install directories according to GNU standard
if(ENABLE_INSTALL)
  include(GNUInstallDirs)
endif()

# Unit testing
if(ENABLE_TESTING)
  include(CTest)
  include(GoogleTest)
  include(FindGTest)
endif()

# CCache integration
if(ENABLE_CCACHE)
  find_program(CCACHE_FOUND ccache REQUIRED)
  if(CCACHE_FOUND)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
  endif()
endif()


# ---------------------------------------------------------------------------
#  Find additionally required packages
#   If your project requires additional packages, you can add them here.
#   Of just uncomment the specific parts of already available snippets.
# ---------------------------------------------------------------------------

## Find threads library. Prefer pthread, if available.
#set(THREADS_PREFER_PTHREAD_FLAG ON)
#find_package(Threads REQUIRED)

## Find boost library with some components
#find_package(Boost REQUIRED
#  COMPONENTS
#  date_time
#  filesystem
#  thread
#)


# ---------------------------------------------------------------------------
#  Setup summary
# ---------------------------------------------------------------------------

message(STATUS "----------------------------------------------------------------------")
message(STATUS "Building ${CMAKE_PROJECT_NAME} in version ${CMAKE_PROJECT_VERSION}")
message(STATUS " C++ standard:       ${CMAKE_CXX_STANDARD}")
message(STATUS " Installing enabled: ${ENABLE_INSTALL}")
message(STATUS " Unit tests enabled: ${ENABLE_TESTING}")
message(STATUS " CCache enabled:     ${ENABLE_CCACHE}")
message(STATUS "----------------------------------------------------------------------")


# ===========================================================================
#  Build targets
#   Put the target definitions for your libraries / executables here.
#   Add them to the INSTALL_TARGETS list if you want them to be installed
#
#   NOTE: Installation requires ENABLE_INSTALL to be active, see config
#         section above.
# ===========================================================================


add_executable(hello
  src/hello.cpp
)

list(APPEND INSTALL_TARGETS hello)


# ===========================================================================
#  Unit tests
# ===========================================================================

if(BUILD_TESTING)
  add_subdirectory(test)
endif()


# ===========================================================================
#  Installation
# ===========================================================================

if(ENABLE_INSTALL)

  install(TARGETS
    ${INSTALL_TARGETS}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  )

endif()

