import 'package:flow_analyzer/flow_analyzer.dart';

// Future<void> runSomething() async {
//   FlowAnalyzer.startFlow('Operation 1.6');
//   await Future.delayed(Duration(milliseconds: 100));
//   FlowAnalyzer.endFlow(); // End Operation 1.6

//   FlowAnalyzer.startFlow('Operation 1.7');
//   await Future.delayed(Duration(milliseconds: 100));
//   FlowAnalyzer.endFlow(); // End Operation 1.7
// }

Future<void> runSomething() async {
  FlowAnalyzer.startFlow('E');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End E

  FlowAnalyzer.startFlow('F');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End F
}

Future<void> runSomethingAndEndExternalFlow() async {
  FlowAnalyzer.startFlow('H');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End H

  // Ending external flow is risky, but can be done
  FlowAnalyzer.endFlow(); // End G (External Operation)
}
