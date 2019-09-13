#ifndef GAME_STATE_HPP
#define GAME_STATE_HPP

#include <random>
#include <optional>

#include <json.hpp>

#include <map.hpp>

enum class State { MENU, START, PLAY, WIN, LOSE };

struct game_state {
  std::mt19937& random;
  State type;
  std::optional<nlohmann::json> map_json{};
  std::optional<Map> map{};
};

#endif  // ! GAME_STATE_HPP
