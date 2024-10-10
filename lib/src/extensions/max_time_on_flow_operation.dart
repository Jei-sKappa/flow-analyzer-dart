import 'package:flow_analyzer/src/extensions/extensions.dart';
import 'package:flow_analyzer/src/flow_analyzer.dart';

extension MaxTime on FlowOperation {
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
