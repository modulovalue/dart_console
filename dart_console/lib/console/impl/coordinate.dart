import '../interface/coordinate.dart';

class SneathCoordinateImpl implements SneathCoordinate {
  @override
  final int row;
  @override
  final int col;

  const SneathCoordinateImpl(
    final this.row,
    final this.col,
  );
}
