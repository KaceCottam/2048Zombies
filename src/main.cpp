#include "map.hpp"

#include <fmt/core.h>

/**
 * @brief Plays a game called 2048 Zombies on the command line
 *
 * @param argc
 * @param argv[] :argv[1] can be a string pointing to a json map
 *
 * @return ec
 */
int main(int argc, char *argv[]) {

  const char *mapName = argc == 1 ? "maps/map0" : argv[1];

  fmt::print("Loading {0}...\n", mapName);
  // Load map here
  auto game_map = load_map(mapName);
  if (!game_map.has_value()) {
    fmt::print("{0} is not a valid map!\n", mapName);
    return -1;
  }
  fmt::print("...Done\n");
}
