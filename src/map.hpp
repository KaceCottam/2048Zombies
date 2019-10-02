#ifndef MAP_HPP
#define MAP_HPP
#include <nlohmann/json.hpp>

#include <optional>
#include <vector>

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
  unsigned value = 0;
};

/**
 * @brief Mapinfo that is passed around in the game state
 */
class MapInfo {
public:
  MapInfo(const json &j);

  unsigned win;
  std::vector<int> police_chance;

  struct {
    unsigned x, y;
  } size;
  std::vector<Tile> tile_grid{size.x * size.y, {Tile::TileType::BLOCK}};
};

/**
 * @brief loads a json file from a filename
 *
 * @param filename
 *
 * @return json
 */
auto load_map(const char *filename) -> std::optional<json>;

#endif // ! MAP_HPP

