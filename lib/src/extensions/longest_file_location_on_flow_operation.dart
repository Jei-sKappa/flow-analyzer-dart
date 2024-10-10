import 'dart:math';

import 'package:flow_analyzer/src/flow_analyzer.dart';

extension LongestFileLocation on FlowOperation {
  int getLongestStartFlowLocationLength() {
    final subFlowsLengths = subFlows
        .map((subFlow) => subFlow.getLongestStartFlowLocationLength())
        .toList();

    final longestSubFlowLength =
        subFlowsLengths.isNotEmpty ? subFlowsLengths.reduce(max) : 0;

    return max(startFlowLocation.fileLocation.length, longestSubFlowLength);
  }

  int getLongestEndFlowLocationLength() {
    final subFlowsLengths = subFlows
        .map((subFlow) => subFlow.getLongestEndFlowLocationLength())
        .toList();

    final longestSubFlowLength =
        subFlowsLengths.isNotEmpty ? subFlowsLengths.reduce(max) : 0;

    return max(endFlowLocation.fileLocation.length, longestSubFlowLength);
  }
}
