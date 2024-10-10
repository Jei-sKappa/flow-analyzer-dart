import 'dart:async';

import 'package:flow_analyzer/src/call_location.dart';
import 'package:flow_analyzer/src/output/output.dart';

part 'running_flow.dart';
part 'flow_operation.dart';

/// The `FlowAnalyzer` class is responsible for analyzing the flow of data
/// within the application. It provides methods and properties to inspect,
/// monitor, and manipulate the flow of data to ensure it meets the desired
/// criteria and performance standards.
class FlowAnalyzer {
  FlowAnalyzer._();

  factory FlowAnalyzer() => _instance;

  static final FlowAnalyzer _instance = FlowAnalyzer._();

  FlowOperationOutputMode _outputMode = const IndentedFlowOperationOutputMode();
  bool _forceShowMethodName = false;

  final List<_RunningFlow> _flowStack = [];

  /// Sets the output mode for the FlowAnalyzer.
  ///
  /// Defaults to [IndentedFlowOperationOutputMode].
  ///
  /// You can also implement your own output mode by implementing
  /// [FlowOperationOutputMode]:
  ///
  /// ```dart
  /// class CustomFlowOutputMode extends FlowOperationOutputMode {
  ///   @override
  ///   void output(FlowOperation operation) {
  ///     // Your custom output logic here
  ///   }
  /// }
  ///
  /// void main() {
  ///   FlowAnalyzer.outputMode = CustomFlowOutputMode();
  /// }
  /// ```
  static set outputMode(FlowOperationOutputMode outputMode) =>
      FlowAnalyzer()._outputMode = outputMode;

  /// Whether to force showing the method name in the output.
  ///
  /// If set to `true`, the [FlowOperation.flowID] will include the method name
  ///
  /// Example:
  /// ```dart
  /// FlowAnalyzer.forceShowMethodName = true;
  /// ```
  static set forceShowMethodName(bool forceShowMethodName) =>
      FlowAnalyzer()._forceShowMethodName = forceShowMethodName;

  /// Starts a flow with an optional [flowName].
  ///
  /// This method should be called to mark the start of a flow.
  ///
  /// Example:
  /// ```dart
  /// // With flow name
  /// FlowAnalyzer.startFlow('Operation 1');
  /// // Your code here
  /// FlowAnalyzer.endFlow();
  ///
  /// // Without flow name
  /// FlowAnalyzer.startFlow();
  /// // Your code here
  /// FlowAnalyzer.endFlow();
  /// ```
  ///
  /// You can also nest flows by calling `startFlow` within a flow.
  ///
  /// Example:
  /// ```dart
  /// FlowAnalyzer.startFlow('Operation 1');
  ///
  /// FlowAnalyzer.startFlow('Operation 1.1');
  /// // Your code here
  /// FlowAnalyzer.endFlow(); // End Operation 1.1
  ///
  /// FlowAnalyzer.run(() {
  ///  // Your code here
  /// }, 'Operation 1.2');
  ///
  /// FlowAnalyzer.endFlow(); // End Operation 1
  static void startFlow([String? flowName]) =>
      _instance._startFlow(flowName, StackTrace.current);

  /// Ends the current flow and captures the current stack trace.
  ///
  /// This method should be called to mark the end of a flow.
  ///
  /// Example:
  /// ```dart
  /// FlowAnalyzer.startFlow();
  /// // Your code here
  /// FlowAnalyzer.endFlow(); // End flow here
  /// ```
  static void endFlow() => _instance._endFlow(StackTrace.current);

  /// Runs the provided callback function within a flow context.
  ///
  /// This method executes the given [callback] and associates it with an
  /// optional [flowName].
  ///
  /// Example:
  /// ```dart
  /// // Synchronous code
  /// final sRes = FlowAnalyzer.run(() {
  ///  // Your synchronous code here
  /// });
  ///
  /// // Asynchronous code
  /// final aRes = await FlowAnalyzer.run(() async {
  ///   // Your asynchronous code here
  /// });
  /// ```
  ///
  /// Returns the result of the callback function.
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
