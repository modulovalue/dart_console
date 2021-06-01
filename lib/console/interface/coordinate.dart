/// A screen position, measured in rows and columns from the top-left origin
/// of the screen. Coordinates are zero-based, and converted as necessary
/// for the underlying system representation (e.g. one-based for VT-style
/// displays).
abstract class Coordinate {
  int get row;

  int get col;
}
