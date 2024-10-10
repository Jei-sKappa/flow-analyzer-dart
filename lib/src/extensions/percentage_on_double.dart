/// Extension on `double` to provide percentage-related utility methods.
extension Percentage on double {
  /// Converts the double value to a percentage by multiplying it by 100.
  ///
  /// Returns the percentage value as a double.
  double toPercentage() => this * 100;

  /// Converts the double value to a percentage string with 2 decimal places.
  ///
  /// Returns the percentage value as a string formatted to 2 decimal places,
  /// padded to the left to ensure a minimum width of 5 characters, followed by a `%` sign.
  String toPercentageString() =>
      '${toPercentage().toStringAsFixed(2).padLeft(5)}%';
}
