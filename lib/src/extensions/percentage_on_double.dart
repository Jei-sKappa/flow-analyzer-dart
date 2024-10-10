extension Percentage on double {
  double toPercentage() => this * 100;

  String toPercentageString() =>
      '${toPercentage().toStringAsFixed(2).padLeft(5)}%';
}
