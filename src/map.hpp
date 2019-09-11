#ifndef MAP_HPP
#define MAP_HPP

#include <iomanip>
#include <iostream>
#include <vector>

#include <json.hpp>

#include <player_input_t.hpp>

enum class TileType { EMPTY, ZOMBIE, CIVILLIAN, MILITARY, BLOCK };

struct Tile {
  TileType type;
  int exponent;

  friend std::ostream& operator<<(std::ostream& stream, const Tile& t) {
    stream << "[";
    switch (t.type) {
      case TileType::EMPTY:
        return stream << "     ]";
      case TileType::ZOMBIE:
        stream << "Z";
        break;
      case TileType::CIVILLIAN:
        stream << "C";
        break;
      case TileType::MILITARY:
        stream << "M";
        break;
      case TileType::BLOCK:
        return stream << "@@@@@]";
    }
    return stream << std::setw(4) << t.exponent << "]";
  }
};

struct Map {
  struct {
    int x;
    int y;
  } size;
  std::vector<Tile> tiles;
  int civillian_size;
  std::vector<int> military_chance;
  int threat;
};

/**
 * @brief constructs a map from a json that has defaults set
 *
 * @param json
 * @note json needs to have all options already.
 *
 * @return the constructed map
 */
auto construct_map(const nlohmann::json& json) -> Map {
  std::vector<Tile> tiles;
  tiles.reserve(json["size"]["m"].get<int>() * json["size"]["n"].get<int>());

  Map map = {{json["size"]["m"].get<int>(), json["size"]["n"].get<int>()},
             tiles,
             json["civillian_size"].get<int>(),
             json["military_chance"].get<std::vector<int>>(),
             json["threat_initial"]};

  for (auto block : json["blocks"]) {
    map.tiles[block["x"].get<int>() + block["y"].get<int>() * map.size.x].type =
        TileType::BLOCK;
  }

  map.tiles[json["zombie_initial"]["x"].get<int>() +
            json["zombie_initial"]["y"].get<int>() * map.size.x]
      .type = TileType::ZOMBIE;

  return map;
}

auto find_empty(const Map& map, std::mt19937& random) -> int {
  std::vector<const Tile*> empty_tiles;
  for (const auto& i : map.tiles) {
    if (i.type == TileType::EMPTY) {
      empty_tiles.push_back(&i);
    }
  }

  auto tile_ptr = empty_tiles[random() % empty_tiles.size()];
  auto iter =
      std::find_if(map.tiles.begin(), map.tiles.end(), [&tile_ptr](auto& t) {
        if (&t == tile_ptr) return true;
        return false;
      });
  return std::distance(map.tiles.begin(), iter);
}

auto place_civillian(const Map& map, const int index) -> Map {
  auto new_tiles = map.tiles;
  new_tiles[index].type = TileType::CIVILLIAN;
  new_tiles[index].exponent = 1;
  return {map.size, new_tiles, map.civillian_size - 2, map.military_chance,
          map.threat};
}

auto place_police(const Map& map, const int index) -> Map {
  auto new_tiles = map.tiles;
  new_tiles[index].type = TileType::MILITARY;
  new_tiles[index].exponent = 1;
  return {map.size, new_tiles, map.civillian_size, map.military_chance,
          map.threat};
}

auto upgrade_police(const Map& map) -> Map {
  auto new_tiles = map.tiles;
  for (auto& i : new_tiles) {
    if (i.type == TileType::MILITARY) ++i.exponent;
  }
  return {map.size, new_tiles, map.civillian_size, map.military_chance, map.threat};
}

auto rotate_board(const Map& map, const DirectionInputType& dir) -> Map {
  auto new_map = map;
  std::rotate(new_map.tiles.begin(),
              new_map.tiles.begin() + new_map.size.x * (int)dir,
              new_map.tiles.end());
  return new_map;
}

// TODO
auto merge_board(const Map& map) -> Map { return map; }

auto display_map(const Map& map) -> void {
  std::cout << "Map:\n";
  for (unsigned i = 0; i < map.tiles.size(); i++) {
    if (i % map.size.x == 1) {
      std::cout << '\n';
    }
    std::cout << map.tiles[i];
  }
}

#endif  // ! MAP_HPP
