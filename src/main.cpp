#include <chrono>
#include <random>
#include <sstream>

#include <game_loop.hpp>

int main(int argc, char **argv) {
  int seed;
  if(argc == 1) {
    seed = std::chrono::system_clock::now().time_since_epoch().count();
  } else {
    auto stream = std::stringstream(argv[1]);
    stream >> seed;
  }

  std::mt19937 rand(seed);

  game_loop({rand, State::MENU});
}
