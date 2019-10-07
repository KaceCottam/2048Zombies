#ifndef STATEPLAY_HPP
#define STATEPLAY_HPP

#include "MapInfo.hpp"

class StatePlay {
  public:
    explicit StatePlay(const MapInfo& info) : info{info} {}

  private:
    MapInfo info;
};
#endif // ! STATEPLAY_HPP

