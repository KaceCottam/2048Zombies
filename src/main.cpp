#include <fstream>
#include <iostream>

#include "State.hpp"

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

  if (!std::ifstream(mapName).good()) {
    std::cerr << "ERROR: File \"" << mapName << "\" does not exist! Exiting..."
              << std::endl;
    return EXIT_FAILURE;
  }

  // game good
  if (auto status = game_loop(StateInit(mapName))) {
    std::cerr << "ERROR: " << (*status)->what() << std::endl;
    delete *status;
  }
  return EXIT_SUCCESS;
}
