#ifndef STATEEXIT_HPP
#define STATEEXIT_HPP

class StateExit {
public:
  enum Status { WIN, LOSE, INVALID };
  explicit StateExit(const Status status) : status{status} {}

  auto GetStatus() const -> Status { return status; }

private:
  Status status;
};
#endif // ! STATEEXIT_HPP
