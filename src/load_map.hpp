#ifndef LOAD_MAP_HPP
#define LOAD_MAP_HPP

#include <optional>

#include <nlohmann/json.hpp>
using json = nlohmann::json;

/**
 * @brief Loads a map
 *
 * @param filename
 *
 * @return maybe a json. If not, then an error occurred.
 *
 * TODO Ensure that all game variables are in place.
 */
auto load_map(const char *filename) -> std::optional<json>;

#endif // ! LOAD_MAP_HPP

