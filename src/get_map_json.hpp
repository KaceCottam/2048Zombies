#ifndef GET_MAP_JSON_HPP
#define GET_MAP_JSON_HPP

#include <fstream>

#include <json.hpp>

auto get_map_json(const char* filename) {
  std::ifstream file(filename);
  auto json = nlohmann::json::parse(file);
  return json;
}

#endif  // ! GET_MAP_JSON_HPP
