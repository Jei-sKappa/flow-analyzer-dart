import 'dart:math';

import 'package:flow_analyzer/src/extensions/extensions.dart';
import 'package:flow_analyzer/src/output/output.dart';
import 'package:flow_analyzer/src/flow_analyzer.dart';

/// The [IndentedFlowOperationOutputMode] class is responsible for outputting
/// the results of a [FlowOperation] to the console in an indented format.
class IndentedFlowOperationOutputMode implements FlowOperationOutputMode {
  /// Creates an instance of [IndentedFlowOperationOutputMode].
  const IndentedFlowOperationOutputMode({
    this.indent = 2,
    this.threshold,
    this.showFileStartLocation = true,
    this.showFileEndLocation = false,
  });

  /// The number of spaces to indent nested operations. Defaults to `2`.
  final int indent;

  /// The minimum time threshold for an operation to be displayed. Defaults to
  /// `null`.
  final Duration? threshold;

  /// Whether to display the file location, line, and column where the operation
  /// started. Defaults to `true`
  final bool showFileStartLocation;

  /// Whether to display the file location, line, and column where the operation
  /// ended. Defaults to `false`
  final bool showFileEndLocation;

  /// Checks if the duration of the given [FlowOperation] is below a specified threshold.
  ///
  /// Returns `true` if the [threshold] is not `null` and the duration of the [op]
  /// is less than the [threshold], otherwise returns `false`.
  ///
  /// - Parameter [op]: The [FlowOperation] whose duration is to be checked.
  bool isBelowThreshold(FlowOperation op) =>
      threshold != null && op.getOperationDuration() < threshold!;

  /// Outputs the [op] to the console in an indented format.
  @override
  void output(FlowOperation op) {
    if (isBelowThreshold(op)) return;

    final maxOperationDuration = op.getLongestOperationDuration();
    final maxNonTrackedDuration = op.getLongestNonTrackedSubFlowsDuration();

    final prettyTimeFormat = PrettyFormat.fromDuration(maxOperationDuration);
    final prettyNonTrackedTimeFormat =
        PrettyFormat.fromDuration(maxNonTrackedDuration);

    final maxNameSpace = _getLongestNameLengthWithIndentation(op);
    final maxTimeSpace = prettyTimeFormat.getLenght();
    // +10 because there is also the percentage e.g. ' (100.00%)'
    final maxNonTrackedTimeSpace = prettyNonTrackedTimeFormat.getLenght() + 10;
    final maxStartFlowLocationSpace = op.getLongestStartFlowLocationLength();
    final maxEndFlowLocationSpace = op.getLongestEndFlowLocationLength();

    // - 1st +1 for the overlapping '+' at the heder with the '|' at the
    //   beginning of every operation
    // - +2 for the two ' ' at the start and at the end of the operation name
    // - 2th +1 for the overlapping '+' at the heder with the '|' at the
    //   end of every operation
    const operationCommonCharsCount = 1 + 2 + 1;
    const operationLeft = "+-- Operation ";
    const operationRight = "--+";
    const operationHeaderBaseLength =
        operationLeft.length + operationRight.length;
    final operationCellPadding = max(0,
        operationHeaderBaseLength - maxNameSpace - operationCommonCharsCount);
    final operationHeaderMissingSpace =
        (maxNameSpace + operationCommonCharsCount) - operationHeaderBaseLength;
    final operationHeader =
        '$operationLeft${'-' * operationHeaderMissingSpace}$operationRight';

    // - +2 for the two ' ' at the start and at the end of the time
    // - 1st +1 for the overlapping '+' at the heder with the '|' at the
    //   end of every time
    const timeCommonCharsCount = 2 + 1;
    const timeLeft = '-- Time ';
    const timeRight = '--+';
    const timeHeaderBaseLength = timeLeft.length + timeRight.length;
    final timeCellPadding =
        max(0, timeHeaderBaseLength - maxTimeSpace - timeCommonCharsCount);
    final timeHeaderMissingSpace =
        (maxTimeSpace + timeCommonCharsCount) - timeHeaderBaseLength;
    final timeHeader = '$timeLeft${'-' * timeHeaderMissingSpace}$timeRight';

    // - +2 for the two ' ' at the start and at the end of the non tracked time
    // - 1st +1 for the overlapping '+' at the heder with the '|' at the
    //   end of every non tracked time
    const nonTrackedTimeCommonCharsCount = 2 + 1;
    const nonTrackedTimeLeft = '-- Non tracked ';
    const nonTrackedTimeRight = '--+';
    const nonTrackedTimeHeaderBaseLength =
        nonTrackedTimeLeft.length + nonTrackedTimeRight.length;
    final nonTrackedTimeCellPadding = max(
        0,
        nonTrackedTimeHeaderBaseLength -
            maxNonTrackedTimeSpace -
            nonTrackedTimeCommonCharsCount);
    final nonTrackedTimeHeaderMissingSpace =
        (maxNonTrackedTimeSpace + nonTrackedTimeCommonCharsCount) -
            nonTrackedTimeHeaderBaseLength;
    final nonTrackedTimeHeader =
        '$nonTrackedTimeLeft${'-' * nonTrackedTimeHeaderMissingSpace}$nonTrackedTimeRight';

    // - +2 for the two ' ' at the start and at the end of the start location
    // - 1st +1 for the overlapping '+' at the heder with the '|' at the
    //   end of every start location
    const startLocationCommonCharsCount = 2 + 1;
    const startLocationLeft = "-- Start Location ";
    const startLocationRight = "--+";
    const startLocationBaseLength =
        startLocationLeft.length + startLocationRight.length;
    final startLocationCellPadding = max(
        0,
        startLocationBaseLength -
            maxStartFlowLocationSpace -
            startLocationCommonCharsCount);
    final startLocationHeaderMissingSpace =
        (maxStartFlowLocationSpace + startLocationCommonCharsCount) -
            startLocationBaseLength;
    var startLocationHeader = showFileStartLocation
        ? '$startLocationLeft${'-' * startLocationHeaderMissingSpace}$startLocationRight'
        : '';

    // - +2 for the two ' ' at the start and at the end of the end location
    // - 1st +1 for the overlapping '+' at the heder with the '|' at the
    //   end of every end location
    const endLocationCommonCharsCount = 2 + 1;
    const endLocationLeft = "-- End Location ";
    const endLocationRight = "--+";
    const endLocationBaseLength =
        endLocationLeft.length + endLocationRight.length;
    final endLocationCellPadding = max(
        0,
        endLocationBaseLength -
            maxEndFlowLocationSpace -
            endLocationCommonCharsCount);
    final endLocationHeaderMissingSpace =
        (maxEndFlowLocationSpace + endLocationCommonCharsCount) -
            endLocationBaseLength;
    final endLocationHeader = showFileEndLocation
        ? '$endLocationLeft${'-' * endLocationHeaderMissingSpace}$endLocationRight'
        : '';

    print('');
    print(
      '$operationHeader'
      '$timeHeader'
      '$nonTrackedTimeHeader'
      '$startLocationHeader'
      '$endLocationHeader ',
    );
    _printOperation(
      op,
      maxNameSpace: maxNameSpace,
      operationCellPadding: operationCellPadding,
      maxTimeSpace: maxTimeSpace,
      timeCellPadding: timeCellPadding,
      maxNonTrackedTimeSpace: maxNonTrackedTimeSpace,
      nonTrackedTimeCellPadding: nonTrackedTimeCellPadding,
      maxStartFlowLocationSpace: maxStartFlowLocationSpace,
      startLocationCellPadding: startLocationCellPadding,
      maxEndFlowLocationSpace: maxEndFlowLocationSpace,
      endLocationCellPadding: endLocationCellPadding,
    );

    final topHeaderLenght = operationHeader.length +
        timeHeader.length +
        nonTrackedTimeHeader.length +
        startLocationHeader.length +
        endLocationHeader.length;
    print('+${'-' * (topHeaderLenght - 2)}+');
  }

  void _printOperation(
    FlowOperation op, {
    required int maxNameSpace,
    required int operationCellPadding,
    required int maxTimeSpace,
    required int timeCellPadding,
    required int maxNonTrackedTimeSpace,
    required int nonTrackedTimeCellPadding,
    required int maxStartFlowLocationSpace,
    required int startLocationCellPadding,
    required int maxEndFlowLocationSpace,
    required int endLocationCellPadding,
    int level = 0,
  }) {
    if (isBelowThreshold(op)) return;

    // Operation Name
    final iName = _getIndentedName(op, level: level);
    final nameSpace = ' ' * (maxNameSpace - iName.length);
    final operationCellPaddingSpace = ' ' * operationCellPadding;
    final operationNameCell = '| $operationCellPaddingSpace$iName$nameSpace |';

    // Operation Duration
    final operationDuration = op.getOperationDuration().pretty;
    final timeCellPaddingSpace = ' ' * timeCellPadding;
    final timeSpace = ' ' * (maxTimeSpace - operationDuration.length);
    final operationDurationCell =
        ' $timeCellPaddingSpace$timeSpace$operationDuration |';

    // Non Tracked Duration + Percentage
    final notTrackedDuration = op.getNotTrackedSubFlowsDuration();
    final nonTrackedDurationRatio = op.getNotTrackedSubFlowsRatio();
    late String notTrackedDurationString;
    if (notTrackedDuration != null && nonTrackedDurationRatio != null) {
      String percentageString =
          nonTrackedDurationRatio.toPercentageString().trim();
      if (percentageString.length == 5) {
        percentageString = '  ($percentageString)';
      } else if (percentageString.length == 6) {
        percentageString = ' ($percentageString)';
      } else if (percentageString.length == 7) {
        percentageString = '($percentageString)';
      }
      notTrackedDurationString =
          '${notTrackedDuration.pretty} $percentageString';
    } else {
      notTrackedDurationString = '/';
    }
    final nonTrackedSpace =
        ' ' * (maxNonTrackedTimeSpace - notTrackedDurationString.length);
    final nonTrackedTimeCellPaddingSpace = ' ' * nonTrackedTimeCellPadding;
    final notTrackedDurationCell =
        ' $nonTrackedTimeCellPaddingSpace$nonTrackedSpace$notTrackedDurationString |';

    // Start Location
    final startLocation = op.startFlowLocation.fileLocation;
    final startLocationSpace =
        ' ' * (maxStartFlowLocationSpace - startLocation.length);
    final startLocationCellPaddingSpace = ' ' * startLocationCellPadding;
    final startLocationCell = showFileStartLocation
        ? ' $startLocationCellPaddingSpace$startLocation$startLocationSpace |'
        : '';

    // End Location
    final endLocation = op.endFlowLocation.fileLocation;
    final endLocationSpace =
        ' ' * (maxEndFlowLocationSpace - endLocation.length);
    final endLocationCellPaddingSpace = ' ' * endLocationCellPadding;
    final endLocationCell = showFileEndLocation
        ? ' $endLocationCellPaddingSpace$endLocation$endLocationSpace |'
        : '';

    print(
      '$operationNameCell'
      '$operationDurationCell'
      '$notTrackedDurationCell'
      '$startLocationCell'
      '$endLocationCell',
    );

    for (final subFlow in op.subFlows) {
      _printOperation(
        subFlow,
        maxNameSpace: maxNameSpace,
        operationCellPadding: operationCellPadding,
        maxTimeSpace: maxTimeSpace,
        timeCellPadding: timeCellPadding,
        maxNonTrackedTimeSpace: maxNonTrackedTimeSpace,
        nonTrackedTimeCellPadding: nonTrackedTimeCellPadding,
        maxStartFlowLocationSpace: maxStartFlowLocationSpace,
        startLocationCellPadding: startLocationCellPadding,
        maxEndFlowLocationSpace: maxEndFlowLocationSpace,
        endLocationCellPadding: endLocationCellPadding,
        level: level + 1,
      );
    }
  }

  String _getIndentedName(FlowOperation op, {int level = 0}) =>
      '${' ' * (indent * level)}${op.flowID}';

  int _getLongestNameLengthWithIndentation(
    FlowOperation op, {
    int level = 0,
  }) {
    final subFlowLengths = op.subFlows
        .map((subFlow) =>
            _getLongestNameLengthWithIndentation(subFlow, level: level + 1))
        .toList();

    final longestSubFlowLength =
        subFlowLengths.isNotEmpty ? subFlowLengths.reduce(max) : 0;

    if (isBelowThreshold(op)) return longestSubFlowLength;

    final nameWithIndentation = _getIndentedName(op, level: level);
    return max(nameWithIndentation.length, longestSubFlowLength);
  }
}
