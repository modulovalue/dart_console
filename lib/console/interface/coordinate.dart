/// A screen position, measured in rows and columns from the top-left origin
/// of the screen. Coordinates are zero-based, and converted as necessary
/// for the underlying system representation (e.g. one-based for VT-style
/// displays).
abstract class SneathCoordinate {
  /// Represents the vertical position i.e. the position on the Y axis.
  int get row;

  /// Represents the horizontal position i.e. the position on the X axis.
  int get col;
}
