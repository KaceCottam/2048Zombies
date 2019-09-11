#ifndef GET_PLAYER_INPUT_HPP
#define GET_PLAYER_INPUT_HPP

#include <iostream>
#include <string>

#include <player_input_t.hpp>

auto get_direction_input() -> DirectionInputType {
  using namespace std;

  cout << "Available inputs: UP, DOWN, LEFT, RIGHT\n"
       << "---------------------------------------\n"
       << "Please enter an available input: ";

  string input;

  getline(cin, input);

  for (auto& c : input) c = toupper(c);

  if (input != "UP" && input != "DOWN" && input != "LEFT" && input != "RIGHT") {
    cout << "Invalid Response." << std::endl;
    return get_direction_input();
  }

  if (input == "UP")
    return DirectionInputType::UP;
  else if (input == "DOWN")
    return DirectionInputType::DOWN;
  else if (input == "LEFT")
    return DirectionInputType::LEFT;
  return DirectionInputType::RIGHT;
}

auto get_menu_input() -> MenuInputType {
  using namespace std;

  cout << "Available inputs: PLAY, EXIT\n"
       << "----------------------------\n"
       << "Please enter an available input: ";

  string input;

  getline(cin, input);

  for (auto& c : input) c = toupper(c);

  if (input != "PLAY" && input != "EXIT") {
    cout << "Invalid Response." << std::endl;
    return get_menu_input();
  }

  if (input == "PLAY") return MenuInputType::PLAY;
  return MenuInputType::EXIT;
}

#endif  // ! GET_PLAYER_INPUT_HPP
