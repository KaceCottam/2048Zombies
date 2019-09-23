#include <fmt/core.h>

#include <nlohmann/json.hpp>
using json = nlohmann::json;

#include "load_map.hpp"

/**
 * @brief Plays a game called 2048 Zombies on the command line
 *
 * @param argc :required to be 1
 * @param argv[] :argv[1] required to be a string pointing to a json map
 *
 * @return ec
 */
int main(int argc, char *argv[]) {

  char *mapName;
  if (argc == 1) { // No map specified
    fmt::print("arg 1 needs to be a string declaring the map to load!\n");
    return 1;
  } else {
    mapName = argv[1];
  }

  fmt::print("Loading {0}...\n", mapName);
  // Load map here
  auto _game_map = load_map(mapName);
  if (!_game_map) {
    fmt::print("{0} is not a valid map!\n", mapName);
    return 1;
  }
  fmt::print("...Done\n");

  auto game_map = *_game_map;

  // TODO continue using game map
}
