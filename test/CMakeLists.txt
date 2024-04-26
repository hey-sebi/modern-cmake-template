
add_executable(example_test
  example_test.cpp
)

target_link_libraries(example_test
  PUBLIC
  GTest::Main
  GTest::GTest
)

gtest_add_tests(TARGET example_test)