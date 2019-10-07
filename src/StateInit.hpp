#ifndef STATEINIT_HPP
#define STATEINIT_HPP

#include "MapInfo.hpp"

#include <nlohmann/json.hpp>
using json = nlohmann::json;

#include <optional>

class StateInit {
public:
  explicit StateInit(const char *mapName) : mapName{mapName} {}

  auto LoadMap() const -> std::optional<MapInfo> {
    // TODO: load map with nlohmann json
    return {};
  }

private:
  const char *mapName;
};
#endif // ! STATEINIT_HPP
