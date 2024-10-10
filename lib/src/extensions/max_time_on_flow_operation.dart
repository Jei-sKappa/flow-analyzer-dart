import 'package:flow_analyzer/src/extensions/extensions.dart';
import 'package:flow_analyzer/src/flow_analyzer.dart';

/// Extension on `FlowOperation` to provide methods for calculating the longest durations.
///
/// This extension includes methods to determine the longest operation duration
/// and the longest non-tracked sub-flows duration within a `FlowOperation`.
extension MaxTime on FlowOperation {
  /// Returns the longest duration of any operation within the flow.
  ///
  /// This method recursively calculates the longest duration by comparing the
  /// duration of the current operation with the longest duration of its sub-flows.
  ///
  /// - Returns: The longest `Duration` of the operation or its sub-flows.
  Duration getLongestOperationDuration() {
    final subFlowsDurations = subFlows
        .map((subFlow) => subFlow.getLongestOperationDuration())
        .toList();

    final longestSubFlowDuration = subFlowsDurations.isNotEmpty
        ? subFlowsDurations.reduce(
            (d1, d2) => d1.inMicroseconds >= d2.inMicroseconds ? d1 : d2,
          )
        : Duration.zero;

    final operationDuration = getOperationDuration();
    final res = operationDuration.inMicroseconds >=
            longestSubFlowDuration.inMicroseconds
        ? operationDuration
        : longestSubFlowDuration;
    return res;
  }

  /// Returns the longest duration of non-tracked sub-flows within the flow.
  ///
  /// This method recursively calculates the longest duration of non-tracked sub-flows
  /// by comparing the duration of the current operation's non-tracked sub-flows with
  /// the longest duration of its sub-flows' non-tracked sub-flows.
  ///
  /// - Returns: The longest `Duration` of non-tracked sub-flows, or `Duration.zero` if none exist.
  Duration getLongestNonTrackedSubFlowsDuration() {
    final subFlowsDurations = subFlows
        .map((subFlow) => subFlow.getLongestNonTrackedSubFlowsDuration())
        .toList();

    final longestSubFlowDuration = subFlowsDurations.isNotEmpty
        ? subFlowsDurations.reduce(
            (d1, d2) => d1.inMicroseconds >= d2.inMicroseconds ? d1 : d2,
          )
        : Duration.zero;

    final nonTrackedSubFlowsDuration = getNotTrackedSubFlowsDuration();

    if (nonTrackedSubFlowsDuration == null) return longestSubFlowDuration;

    return nonTrackedSubFlowsDuration.inMicroseconds >=
            longestSubFlowDuration.inMicroseconds
        ? nonTrackedSubFlowsDuration
        : longestSubFlowDuration;
  }
}
