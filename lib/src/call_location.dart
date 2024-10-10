class CallLocation {
  late final String file;
  late final String method;
  late final int line;
  late final int colum;

  CallLocation.fromStackTrace(StackTrace stackTrace) {
    final traceString = getTraceString(stackTrace);
    final locationInfo = _parseTraceString(traceString);
    file = locationInfo['file']!;
    method = locationInfo['method']!;
    line = int.parse(locationInfo['line']!);
    colum = int.parse(locationInfo['column']!);
  }

  @override
  String toString() => '$method ($file:$line:$colum)';

  String get fileLocation => '$file:$line:$colum';

  String getTraceString(StackTrace trace) {
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
