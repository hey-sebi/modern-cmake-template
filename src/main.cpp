#include <iostream>
#include <replaceme/replaceme.h>
#include <replaceme/version.h>

int main(int argc, char const *argv[]) {
  (void)argc;
  (void)argv;

  std::cout << replaceme::get_greeting() << std::endl;
  std::cout << "Version: " << REPLACEME_VERSION_MAJOR << "."
            << REPLACEME_VERSION_MINOR << "."
            << REPLACEME_VERSION_PATCH << std::endl;
  std::cout << "1 + 2 = " << replaceme::add(1, 2) << std::endl;

  return 0;
}
