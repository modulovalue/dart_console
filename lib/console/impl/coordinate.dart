import '../interface/coordinate.dart';

class CoordinateImpl implements Coordinate {
  @override
  final int row;
  @override
  final int col;

  const CoordinateImpl(this.row, this.col);
}
