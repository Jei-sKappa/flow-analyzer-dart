import 'dart:async';

import 'package:flow_analyzer/src/call_location.dart';
import 'package:flow_analyzer/src/output/output.dart';

part 'running_flow.dart';
part 'flow_operation.dart';

class FlowAnalyzer {
  FlowAnalyzer._();

  factory FlowAnalyzer() => _instance;

  static final FlowAnalyzer _instance = FlowAnalyzer._();

  FlowOperationOutputMode _outputMode = const IndentedFlowOperationOutputMode();
  bool _forceShowMethodName = false;

  final List<_RunningFlow> _flowStack = [];

  static set outputMode(FlowOperationOutputMode outputMode) =>
      FlowAnalyzer()._outputMode = outputMode;

  static set forceShowMethodName(bool forceShowMethodName) =>
      FlowAnalyzer()._forceShowMethodName = forceShowMethodName;

  static void startFlow([String? flowName]) =>
      _instance._startFlow(flowName, StackTrace.current);

  static void endFlow() => _instance._endFlow(StackTrace.current);

  static FutureOr<T> run<T>(FutureOr<T> Function() callback,
          [String? flowName]) =>
      _instance._run(callback, flowName, StackTrace.current);

  void _startFlow(String? flowName, StackTrace trace) {
    final startTime = DateTime.now();
    _flowStack.add(_RunningFlow(flowName, startTime, trace));
  }

  void _endFlow(StackTrace trace) {
    final endTime = DateTime.now();

    if (_flowStack.isEmpty) {
      throw StateError('No flow to end');
    }

    final flow = _flowStack.removeLast();
    final endFlowLocation = CallLocation.fromStackTrace(trace);
    final completedFlow = flow.toResult(endTime, endFlowLocation);

    if (_flowStack.isNotEmpty) {
      final lastFlowIndex = _flowStack.length - 1;
      _flowStack[lastFlowIndex].subFlows.add(completedFlow);
      final lastFlowLastSubFlowIndex =
          _flowStack[lastFlowIndex].subFlows.length - 1;
      _flowStack[lastFlowIndex]
          .subFlows[lastFlowLastSubFlowIndex]
          ._internalOperationEndTime = DateTime.now();
      return;
    }

    completedFlow._internalOperationEndTime = DateTime.now();
    _outputMode.output(completedFlow);
  }

  FutureOr<T> _run<T>(
    FutureOr<T> Function() callback,
    String? flowName,
    StackTrace trace,
  ) async {
    _startFlow(flowName, trace);
    final res = await callback();
    _endFlow(trace);
    return res;
  }
}
