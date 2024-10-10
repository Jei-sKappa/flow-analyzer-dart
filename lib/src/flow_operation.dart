part of 'flow_analyzer.dart';

class FlowOperation {
  FlowOperation._({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.subFlows,
    required this.startFlowLocation,
    required this.endFlowLocation,
  });

  final String? name;
  final DateTime startTime;
  final DateTime endTime;
  final List<FlowOperation> subFlows;
  final CallLocation startFlowLocation;
  final CallLocation endFlowLocation;
  late final DateTime _internalOperationEndTime;

  bool get _areCallMethodsNameEquals =>
      startFlowLocation.method == endFlowLocation.method;

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

  bool get isLeaf => subFlows.isEmpty;

  /// Represent the actual duration of the operation performed between
  /// [FlowAnalyzer.startFlow] and [FlowAnalyzer.endFlow]
  Duration getOperationDuration() =>
      getRealDuration() - getTotalInternalEndFlowDuration();

  Duration getSubFlowsRealDuration() {
    if (isLeaf) return getRealDuration();

    Duration total = Duration.zero;
    for (final flow in subFlows) {
      total += flow.getRealDuration();
    }
    return total;
  }

  Duration getOperationDurationWithoutSubFlows() =>
      getOperationDuration() - getSubFlowsOperationDuration();

  Duration getSubFlowsOperationDuration() {
    if (isLeaf) return getRealDurationWithoutInternalEndFlowDuration();

    Duration total = Duration.zero;
    for (final flow in subFlows) {
      total += flow.getOperationDuration();
    }
    return total;
  }

  Duration getRealOperationDurationWithoutSubFlows() =>
      getRealDuration() - getSubFlowsRealDuration();

  /// Represent [...]
  ///
  /// It's the same as ([getRealDuration] -
  /// [getInternalEndFlowDuration])
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
