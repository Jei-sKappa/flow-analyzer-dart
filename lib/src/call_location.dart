class CallLocation {
  /// Creates a [CallLocation] instance from a [StackTrace].
  ///
  /// This constructor extracts the trace string from the provided [stackTrace],
  /// parses it to obtain the file, method, line, and column information, and
  /// initializes the corresponding fields of the [CallLocation] instance.
  ///
  /// - Parameters:
  ///   - stackTrace: The [StackTrace] object from which to extract the call location information.
  CallLocation.fromStackTrace(StackTrace stackTrace) {
    final traceString = _getTraceString(stackTrace);
    final locationInfo = _parseTraceString(traceString);
    file = locationInfo['file']!;
    method = locationInfo['method']!;
    line = int.parse(locationInfo['line']!);
    colum = int.parse(locationInfo['column']!);
  }

  /// The file path associated with the call location.
  late final String file;

  /// The method name associated with the call location.
  late final String method;

  /// The line number associated with the call location.
  late final int line;

  /// The column number associated with the call location.
  late final int colum;

  @override
  String toString() => '$method ($file:$line:$colum)';

  /// Returns the file location in the format 'file:line:column'.
  ///
  /// This getter constructs a string that represents the location within a file
  /// by combining the file name, line number, and column number.
  ///
  /// Example:
  /// ```
  /// String location = instance.fileLocation;
  /// print(location); // 'main.dart:10:5'
  /// ```
  String get fileLocation => '$file:$line:$colum';

  String _getTraceString(StackTrace trace) {
    final fixedTraceLines = <String>[];
    for (final line in trace.toString().split('\n')) {
      if (line.startsWith("#")) {
        fixedTraceLines.add(line);
      }
    }

    return fixedTraceLines[1];
  }

  Map<String, String> _parseTraceString(String trace) {
    final regex = RegExp(r'#\d+\s+(.+)\s+\((.+):(\d+):(\d+)\)');
    final match = regex.firstMatch(trace);

    if (match != null) {
      return {
        'method': match.group(1) ?? 'Unknown method',
        'file': match.group(2) ?? 'Unknown file',
        'line': match.group(3) ?? 'Unknown line',
        'column': match.group(4) ?? 'Unknown column',
      };
    }

    return {
      'method': 'Unknown method',
      'file': 'Unknown file',
      'line': 'Unknown line',
      'column': 'Unknown column',
    };
  }
}
