import 'dart:math';

import 'package:flow_analyzer/src/constants/constants.dart';
import 'package:flow_analyzer/src/flow_analyzer.dart';

/// Extension on FlowOperation to calculate the duration of subflows that are
/// not tracked within the current flow operation.
extension NotTrackedSubFlowsDurationInfo on FlowOperation {
  /// Calculates the duration of subflows that are not tracked within the
  /// current flow operation.
  ///
  /// If the current flow operation is a leaf (i.e., it has no subflows), this
  /// method returns `null`.
  /// Otherwise, it computes the duration by subtracting the total duration of
  /// subflows from the
  /// overall operation duration.
  ///
  /// Returns:
  /// - `Duration?`: The duration of untracked subflows, or `null` if the
  /// current operation is a leaf.
  Duration? getNotTrackedSubFlowsDuration() {
    if (isLeaf) return null;

    final operationDuration = getOperationDuration();
    final subFlowsOperationDuration = getSubFlowsOperationDuration();
    return operationDuration - subFlowsOperationDuration;
  }

  /// Calculates the ratio of the duration of subflows that are not tracked
  /// relative to the total operation duration, adjusted by an error threshold.
  ///
  /// Returns `null` if the duration of not tracked subflows is `null`.
  /// Otherwise, returns the ratio of not tracked subflows duration to the
  /// operation duration, adjusted by subtracting an error threshold and
  /// ensuring the result is not negative.
  double? getNotTrackedSubFlowsRatio() {
    final notTrackedDuration = getNotTrackedSubFlowsDuration();
    if (notTrackedDuration == null) return null;

    final operationDuration = getOperationDuration();
    final ratio =
        notTrackedDuration.inMicroseconds / operationDuration.inMicroseconds;

    return max(0.0, ratio - errorThreshold);
  }
}
