import 'package:flow_analyzer/src/flow_analyzer.dart';

/// The `FlowOperationOutputMode` class is responsible for outputting the
/// results of a [FlowOperation] to the console or other output medium.
///
/// You can implement your own output mode by implementing this class:
///
/// ```dart
/// class CustomFlowOutputMode extends FlowOperationOutputMode {
///   @override
///   void output(FlowOperation operation) {
///     // Your custom output logic here
///   }
/// }
///```
/// And then set it as the output mode for the [FlowAnalyzer]:
///
///```dart
/// void main() {
///   FlowAnalyzer.outputMode = CustomFlowOutputMode();
/// }
/// ```
abstract interface class FlowOperationOutputMode {
  /// Outputs the [flowResult] to the console or other output medium.
  void output(FlowOperation flowResult);
}
