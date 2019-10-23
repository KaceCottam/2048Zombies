#ifndef STATE_HPP
#define STATE_HPP

#include "StateInit.hpp"

#include "StatePlay.hpp"

#include "StateExit.hpp"

#include <exception>
#include <optional>
#include <string>
#include <variant>

// TODO do I need this?
using GameState = std::variant<StateInit, StatePlay, StateExit>;
using GameStatus = std::optional<std::exception *>;

auto game_loop(const StateExit &state) -> GameStatus {
  auto status = state.GetStatus();
  if (status == StateExit::WIN) {
    // TODO display win
  } else if (status == StateExit::LOSE) {
    // TODO display lose
  } else
    return new std::runtime_error("Game exited wrongly!");
  return {};
}

auto game_loop(const StatePlay &state) -> GameStatus {
  // TODO play
  return game_loop(StateExit(StateExit::WIN));
}

auto game_loop(const StateInit &state) -> GameStatus {
  const auto mapinfo = state.LoadMap();
  if (!mapinfo.has_value())
    return new std::runtime_error(std::string("Invalid file: ") +
                                  state.mapName + "!");

  return game_loop(StatePlay(*mapinfo));
}

#endif // ! STATE_HPP
