part of 'flow_analyzer.dart';

/// The `FlowOperation` class represents an operation within a flow, capturing
/// details such as its name, start and end times, sub-flows, and locations
/// where the flow starts and ends. This class provides various methods to
/// calculate durations related to the flow and its sub-flows.
class FlowOperation {
  FlowOperation._({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.subFlows,
    required this.startFlowLocation,
    required this.endFlowLocation,
  });

  /// The name of the operation.
  final String? name;

  /// The start time of the operation.
  final DateTime startTime;

  /// The end time of the operation.
  final DateTime endTime;

  /// The sub-flows of the operation.
  final List<FlowOperation> subFlows;

  /// The location where the flow starts.
  final CallLocation startFlowLocation;

  /// The location where the flow ends.
  final CallLocation endFlowLocation;

  late final DateTime _internalOperationEndTime;

  bool get _areCallMethodsNameEquals =>
      startFlowLocation.method == endFlowLocation.method;

  /// The string representation of the flow operation.
  String get flowID {
    if (name != null) {
      if (FlowAnalyzer()._forceShowMethodName) {
        if (_areCallMethodsNameEquals) {
          return '${startFlowLocation.method} : $name';
        } else {
          return '${startFlowLocation.method} '
              ': $name '
              ': ${endFlowLocation.method}';
        }
      } else {
        return name!;
      }
    } else {
      if (_areCallMethodsNameEquals) {
        return startFlowLocation.method;
      } else {
        return '${startFlowLocation.method} : ${endFlowLocation.method}';
      }
    }
  }

  /// Whether the flow does not have any sub-flows.
  bool get isLeaf => subFlows.isEmpty;

  /// Represent the actual duration of the operation performed between
  /// [FlowAnalyzer.startFlow] and [FlowAnalyzer.endFlow]
  Duration getOperationDuration() =>
      getRealDuration() - getTotalInternalEndFlowDuration();

  /// Calculates the total real duration of all sub-flows.
  ///
  /// If the current flow is a leaf (i.e., it has no sub-flows), it returns the real duration of the current flow.
  /// Otherwise, it iterates through all sub-flows and sums their real durations.
  ///
  /// Returns:
  ///   A [Duration] representing the total real duration of all sub-flows.
  Duration getSubFlowsRealDuration() {
    if (isLeaf) return getRealDuration();

    Duration total = Duration.zero;
    for (final flow in subFlows) {
      total += flow.getRealDuration();
    }
    return total;
  }

  /// Returns the duration of the operation excluding the durations of any sub-flows.
  ///
  /// This method calculates the total duration of the operation by subtracting
  /// the duration of all sub-flows from the overall operation duration.
  ///
  /// Returns:
  ///   A [Duration] representing the operation duration without sub-flows.
  Duration getOperationDurationWithoutSubFlows() =>
      getOperationDuration() - getSubFlowsOperationDuration();

  /// Calculates the total duration of all sub-flows' operations.
  ///
  /// If the current flow is a leaf (i.e., it has no sub-flows), it returns the
  /// real duration without the internal end flow duration. Otherwise, it sums
  /// up the durations of all sub-flows' operations and returns the total.
  ///
  /// Returns:
  ///   A [Duration] representing the total duration of all sub-flows' operations.
  Duration getSubFlowsOperationDuration() {
    if (isLeaf) return getRealDurationWithoutInternalEndFlowDuration();

    Duration total = Duration.zero;
    for (final flow in subFlows) {
      total += flow.getOperationDuration();
    }
    return total;
  }

  /// Returns the real operation duration excluding the duration of sub-flows.
  ///
  /// This method calculates the real duration of the operation by subtracting
  /// the total duration of all sub-flows from the overall real duration of the
  /// operation.
  ///
  /// Returns:
  ///   A [Duration] representing the real operation duration without sub-flows.
  Duration getRealOperationDurationWithoutSubFlows() =>
      getRealDuration() - getSubFlowsRealDuration();

  /// Calculates the real duration between the start time and end time,
  /// excluding any internal end flow duration.
  ///
  /// It's the same as ([getRealDuration] - [getInternalEndFlowDuration])
  ///
  /// Returns:
  ///   A [Duration] object representing the difference between the end time and
  /// start time.
  Duration getRealDurationWithoutInternalEndFlowDuration() =>
      endTime.difference(startTime);

  /// Represent the actual elapsed time from [FlowAnalyzer.startFlow] to
  /// [FlowAnalyzer.endFlow]
  Duration getRealDuration() => _internalOperationEndTime.difference(startTime);

  /// Represent the elapsed time from the start of [FlowAnalyzer.endFlow] to its
  /// end
  Duration getInternalEndFlowDuration() =>
      _internalOperationEndTime.difference(endTime);

  /// Represent all the elapsed time from the start of [FlowAnalyzer.endFlow] to
  /// its end for every subflow plus the current flow
  Duration getTotalInternalEndFlowDuration() {
    if (isLeaf) return getInternalEndFlowDuration();

    Duration total = getInternalEndFlowDuration();
    for (final flow in subFlows) {
      total += flow.getTotalInternalEndFlowDuration();
    }
    return total;
  }
}
