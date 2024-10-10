import 'dart:math';

import 'package:flow_analyzer/src/flow_analyzer.dart';

/// Extension on `FlowOperation` to calculate the longest file location length
/// for both start and end flow locations within a flow operation and its
/// subflows.
extension LongestFileLocation on FlowOperation {
  /// Returns the length of the longest start flow location among the current flow
  /// and its sub-flows.
  ///
  /// This method calculates the length of the `fileLocation` of the `startFlowLocation`
  /// for the current flow and compares it with the lengths of the `fileLocation`
  /// of the `startFlowLocation` for each sub-flow. It returns the maximum length
  /// found.
  ///
  /// Returns:
  /// - An integer representing the length of the longest start flow location.
  int getLongestStartFlowLocationLength() {
    final subFlowsLengths = subFlows
        .map((subFlow) => subFlow.getLongestStartFlowLocationLength())
        .toList();

    final longestSubFlowLength =
        subFlowsLengths.isNotEmpty ? subFlowsLengths.reduce(max) : 0;

    return max(startFlowLocation.fileLocation.length, longestSubFlowLength);
  }

  /// Returns the length of the longest end flow location among the current flow
  /// and its sub-flows.
  ///
  /// This method calculates the length of the `fileLocation` of the `endFlowLocation`
  /// for the current flow and compares it with the lengths of the longest end flow
  /// locations of all sub-flows. It returns the maximum length found.
  ///
  /// Returns:
  /// - An `int` representing the length of the longest end flow location.
  int getLongestEndFlowLocationLength() {
    final subFlowsLengths = subFlows
        .map((subFlow) => subFlow.getLongestEndFlowLocationLength())
        .toList();

    final longestSubFlowLength =
        subFlowsLengths.isNotEmpty ? subFlowsLengths.reduce(max) : 0;

    return max(endFlowLocation.fileLocation.length, longestSubFlowLength);
  }
}
