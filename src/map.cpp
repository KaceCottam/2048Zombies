#include "map.hpp"

#include <cassert>
#include <fstream>

using json = nlohmann::json;

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

template <class T>
auto get_with_default(const json &j, const char *key, const T &d) -> T {
  try {
    return j.at(key).get<T>();
  } catch (const json::exception::out_of_range &) {
    return d;
  }
}

MapInfo::MapInfo(const json &j)
    : win{j["win"].get<unsigned>()},       //
      size{j["size"]["x"].get<unsigned>(), //
           j["size"]["y"].get<unsigned>()} {

  if (j.find("blocks") != j.end()) {
    for (auto i : j["blocks"]) {
      tile_grid[i["x"].get<unsigned>() + size.x * i["y"].get<unsigned>()].tile =
          Tile::TileType::BLOCK;
    }
  }

  if (j.find("zombie_initial") != j.end()) {
    auto initial = j.get<std::tuple<unsigned, unsigned, unsigned>>();

    tile_grid[std::get<0>(initial) + size.x * std::get<1>(initial)].tile =
        Tile::TileType::ZOMBIE;
    tile_grid[std::get<0>(initial) + size.x * std::get<1>(initial)].value =
        std::get<2>(initial);
  } else {
  }

  for (auto i : j["police_chance"]) {
    police_chance.push_back(i.get<unsigned>());
  }

  assert(win - 1 == police_chance.size());
}
