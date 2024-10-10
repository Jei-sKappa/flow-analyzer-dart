part of 'flow_analyzer.dart';

class _RunningFlow {
  _RunningFlow(this.name, this.startTime, this.trace);

  final String? name;
  final DateTime startTime;
  final List<FlowOperation> subFlows = [];
  final StackTrace trace;

  FlowOperation toResult(
    DateTime endTime,
    CallLocation endFlowLocation,
  ) =>
      FlowOperation._(
        name: name,
        startTime: startTime,
        endTime: endTime,
        subFlows: subFlows,
        startFlowLocation: CallLocation.fromStackTrace(trace),
        endFlowLocation: endFlowLocation,
      );
}
