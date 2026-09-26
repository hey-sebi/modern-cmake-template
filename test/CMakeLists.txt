if(USE_SYSTEM_GTEST)
  find_package(GTest REQUIRED)
else()
  find_package(GTest QUIET)
  if(NOT GTest_FOUND)
    include(FetchContent)
    FetchContent_Declare(
      googletest
      URL https://github.com/google/googletest/archive/refs/tags/v1.15.2.zip
      DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    )
    # For Windows: Prevent overriding the parent project's compiler/linker settings
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    # Disable install rules for googletest when fetched
    set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)
  endif()
endif()

add_executable(example_test
  example_test.cpp
)

target_link_libraries(example_test
  PRIVATE
  replaceme::replaceme
  $<BUILD_INTERFACE:replaceme_warnings>
  GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(example_test)