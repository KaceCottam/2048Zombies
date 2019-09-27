#ifndef MAP_HPP
#define MAP_HPP
#include <nlohmann/json.hpp>

#include <fstream>
#include <optional>
using json = nlohmann::json;

/**
 * @brief a struct that will hold data for tiles
 */
struct Tile {
  enum class TileType {
    EMPTY,
    ZOMBIE,
    CIVILLIAN,
    MILITARY,
    BLOCK
  } tile = TileType::EMPTY;
  int value = 0;
};

/**
 * @brief Mapinfo that is passed around in the game state
 */
class MapInfo {
public:
  MapInfo(int x, int y) : size{x, y}, tile_grid{new Tile[x * y]} {}

  struct {
    int x, y;
  } size;
  Tile *tile_grid;
};

/**
 * @brief loads a json file from a filename
 *
 * @param filename
 *
 * @return json
 */
auto load_map(const char *filename) -> std::optional<json> {
  std::ifstream file(filename);
  if (!file.good())
    return {};
  try {
    return json::parse(file);

  } catch (...) { // Unexpected error while parsing
    return {};
  }
}
#endif // ! MAP_HPP

