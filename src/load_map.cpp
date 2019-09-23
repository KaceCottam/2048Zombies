#include <fstream>

#include "load_map.hpp"

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
