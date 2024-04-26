#include <gtest/gtest.h>


/// Calculates the sum of two the integers @p a and @p b
int Sum(int a, int b)
{
  return a + b;
}


TEST(ExampleTest, TestSum)
{
  const int a = 2;
  const int b = 4;
  EXPECT_EQ(Sum(a, b), a + b);
}