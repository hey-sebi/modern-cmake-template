#include <gtest/gtest.h>
#include <replaceme/replaceme.h>

TEST(ReplacemeTest, TestGreeting) {
  EXPECT_EQ(replaceme::get_greeting(), "Hello from replaceme!");
}

TEST(ReplacemeTest, TestAdd) {
  EXPECT_EQ(replaceme::add(2, 3), 5);
  EXPECT_EQ(replaceme::add(-1, 1), 0);
  EXPECT_EQ(replaceme::add(0, 0), 0);
}