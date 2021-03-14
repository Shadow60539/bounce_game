class Position {
  double dx;
  double dy;

  Position({this.dx, this.dy});

  factory Position.reset() => Position(dx: -1.0, dy: 1.0);
}
