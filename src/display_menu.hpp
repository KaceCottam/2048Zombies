#ifndef DISPLAY_MENU_HPP
#define DISPLAY_MENU_HPP

#include <iostream>

auto display_menu() -> void {
  std::cout << "Welcome to 2048 Zombies!\n"
            << "PLAY\n"
            << "EXIT" << std::endl;
}

auto display_lose() -> void {
  std::cout << "You lose!" << std::endl;
}

auto display_win() -> void {
  std::cout << "You win!" << std::endl;
}

#endif  // ! DISPLAY_MENU_HPP
