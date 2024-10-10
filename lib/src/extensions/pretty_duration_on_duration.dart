/// The format to use when pretty printing a duration.
enum PrettyFormat {
  /// Includes hours, minutes, seconds, milliseconds, and microseconds.
  fromHours,

  /// Includes minutes, seconds, milliseconds, and microseconds.
  fromMinutes,

  /// Includes seconds, milliseconds, and microseconds.
  fromSeconds,

  /// Includes milliseconds and microseconds.
  fromMilliseconds,

  /// Includes only microseconds.
  fromMicroseconds;

  /// Converts a [Duration] object into a [PrettyFormat] based on the largest
  /// non-zero time unit available. The order of precedence is:
  /// hours, minutes, seconds, milliseconds, and microseconds.
  ///
  /// - If the duration has hours, it returns [PrettyFormat.fromHours].
  /// - If the duration has minutes but no hours, it returns
  /// [PrettyFormat.fromMinutes].
  /// - If the duration has seconds but no minutes or hours, it returns
  /// [PrettyFormat.fromSeconds].
  /// - If the duration has milliseconds but no seconds, minutes, or hours, it
  /// returns [PrettyFormat.fromMilliseconds].
  /// - If the duration has only microseconds, it returns
  /// [PrettyFormat.fromMicroseconds].
  ///
  /// Example:
  /// ```dart
  /// Duration duration = Duration(hours: 1, minutes: 30);
  /// PrettyFormat format = PrettyFormat.fromDuration(duration);
  /// // format will be PrettyFormat.fromHours
  /// ```
  factory PrettyFormat.fromDuration(Duration duration) {
    if (duration.inHours > 0) return PrettyFormat.fromHours;
    if (duration.inMinutes > 0) return PrettyFormat.fromMinutes;
    if (duration.inSeconds > 0) return PrettyFormat.fromSeconds;
    if (duration.inMilliseconds > 0) return PrettyFormat.fromMilliseconds;
    return PrettyFormat.fromMicroseconds;
  }

  /// Returns the length of the formatted duration string based on the
  /// `PrettyFormat` type. The length is calculated by summing the
  /// number of characters required for each component of the duration
  /// (e.g., hours, minutes, seconds, etc.) and the separators between them.
  ///
  /// Returns the total length of the formatted duration string.
  int getLenght() {
    switch (this) {
      case PrettyFormat.fromHours:
        return 3 + 1 + 3 + 1 + 3 + 1 + 5 + 1 + 5;
      case PrettyFormat.fromMinutes:
        return 3 + 1 + 3 + 1 + 5 + 1 + 5;
      case PrettyFormat.fromSeconds:
        return 3 + 1 + 5 + 1 + 5;
      case PrettyFormat.fromMilliseconds:
        return 5 + 1 + 5;
      case PrettyFormat.fromMicroseconds:
        return 5;
    }
  }
}

/// Extension that provides a pretty formatted string representation of a
/// [Duration] object.
extension PrettyDuration on Duration {
  String _twoDigits(int n) => n.toString().padLeft(2);
  String _threeDigits(int n) => n.toString().padLeft(3);

  /// Returns a pretty formatted string representation of the duration.
  String get pretty => prettyFrom(PrettyFormat.fromDuration(this));

  /// Returns a pretty formatted string representation of the duration.
  ///
  /// The format is based on the provided [PrettyFormat].
  String prettyFrom(PrettyFormat format) {
    String negativeSign = isNegative ? '-' : '';

    late String hours;
    late String minutes;
    late String seconds;
    late String milliseconds;
    late String microseconds;

    if (format == PrettyFormat.fromMicroseconds) {
      assert(inMilliseconds == 0,
          'Duration is too long to be represented only as microseconds');
      return "$negativeSign${_threeDigits(inMicroseconds)}µs";
    }
    microseconds = "${_threeDigits(inMicroseconds.remainder(1000).abs())}µs";

    if (format == PrettyFormat.fromMilliseconds) {
      assert(inSeconds == 0,
          'Duration is too long to be represented only as milliseconds');
      return "$negativeSign${_threeDigits(inMilliseconds)}ms $microseconds";
    }
    milliseconds = "${_threeDigits(inMilliseconds.remainder(1000).abs())}ms";

    if (format == PrettyFormat.fromSeconds) {
      assert(inMinutes == 0,
          'Duration is too long to be represented only as seconds');
      return "$negativeSign${_twoDigits(inSeconds)}s "
          "$milliseconds $microseconds";
    }
    seconds = "${_twoDigits(inSeconds.remainder(60).abs())}s";

    if (format == PrettyFormat.fromMinutes) {
      assert(inHours == 0,
          'Duration is too long to be represented only as minutes');
      return "$negativeSign${_twoDigits(inMinutes)}m "
          "$seconds $milliseconds $microseconds";
    }
    minutes = "${_twoDigits(inMinutes.remainder(60).abs())}m";

    hours = "${_twoDigits(inHours)}h";
    return "$negativeSign$hours $minutes $seconds $milliseconds $microseconds";
  }
}
