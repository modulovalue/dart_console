import '../interface/coordinate.dart';

class SneathCoordinateImpl implements SneathCoordinate {
  @override
  final int row;
  @override
  final int col;

  const SneathCoordinateImpl({
    required final this.row,
    required final this.col,
  });
}
