#ifndef GAME_LOOP_HPP
#define GAME_LOOP_HPP

#include <json.hpp>

#include <display_menu.hpp>
#include <game_state.hpp>
#include <get_map_json.hpp>
#include <player_input.hpp>

auto game_loop(const game_state& state) {
  switch (state.type) {
    case State::MENU: {
      // retrieve all maps, choose one
      // or allow player to exit game.
      display_menu();
      auto input = get_menu_input();
      if (input == MenuInputType::EXIT) return;

      game_loop({state.random, State::START, get_map_json("data/map1.json")});
    }
break;
    case State::START:
      // initialize map
      // place initial characters
      {
        game_loop({state.random, State::PLAY, state.map_json,
                   construct_map(state.map_json)});
      }
      break;
    case State::PLAY:
      // check if win or lose
      // spawn civilian if there are none
      // spawn police if the chance succeeds
      //
      // display
      //
      // wait for movement - must be wasd or OAODOBOC
      // turn board so that left
      // = up, left, down, right according to keypress
      // merge_left
      //
      // continue playing
      {
        std::vector<Tile> filtered_civs;
        std::copy_if(state.map.tiles.begin(), state.map.tiles.end(),
                     std::back_inserter(filtered_civs), [](const Tile& t) {
                       return t.type == TileType::CIVILLIAN;
                     });

        if (filtered_civs.size() == 0 && state.map.civillian_size == 0) {
          game_loop({state.random, State::WIN});
          return;
        }

        auto map_with_new_civ =
            place_civillian(state.map, find_empty(state.map, state.random));
        auto map_with_better_police = upgrade_police(map_with_new_civ);
        auto map_with_new_police = place_police(
            map_with_better_police, find_empty(state.map, state.random));

        display_map(state.map);

        auto player_input = get_direction_input();
        auto map_rotated = rotate_board(map_with_new_police, player_input);
        auto map_merged = merge_board(map_rotated);

        if (std::find_if(map_merged.tiles.begin(), map_merged.tiles.end(),
                         [](const Tile& t) { return t.type == TileType::ZOMBIE; })
                -> exponent == -1) {
          game_loop({state.random, State::LOSE});
          return;
        }

        game_loop({state.random, State::PLAY, state.map_json, map_merged});
      }
      break;
    case State::WIN:
      // no civillians left on board and civ_status == 0
      // display win
      {
        display_win();
        game_loop({state.random, State::MENU});
      }
      break;
    case State::LOSE:
      // run into police bigger than zombie
      {
        display_lose();
        game_loop({state.random, State::MENU});
      }
      break;
  }
}

#endif
