import 'dart:math';

import 'package:flow_analyzer/src/constants/constants.dart';
import 'package:flow_analyzer/src/flow_analyzer.dart';

extension NotTrackedSubFlowsDurationInfo on FlowOperation {
  Duration? getNotTrackedSubFlowsDuration() {
    if (isLeaf) return null;

    final operationDuration = getOperationDuration();
    final subFlowsOperationDuration = getSubFlowsOperationDuration();
    return operationDuration - subFlowsOperationDuration;
  }

  double? getNotTrackedSubFlowsRatio() {
    final notTrackedDuration = getNotTrackedSubFlowsDuration();
    if (notTrackedDuration == null) return null;

    final operationDuration = getOperationDuration();
    final ratio =
        notTrackedDuration.inMicroseconds / operationDuration.inMicroseconds;

    return max(0.0, ratio - errorThreshold);
  }
}
