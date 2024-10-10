import 'package:flow_analyzer/flow_analyzer.dart';

import 'other_file.dart' as other_file;

void main() {
  flowExample();
}

// Future<void> flowExample() async {
//   print('RUNNING FLOW ANALYZER...');

//   FlowAnalyzer.forceShowMethodName = true;

//   FlowAnalyzer.startFlow('Operation 1');

//   // FlowAnalyzer.startFlow('Operation 1.1');
//   // await Future.delayed(Duration(milliseconds: 100));
//   // FlowAnalyzer.endFlow(); // End Operation 1,1

//   FlowAnalyzer.startFlow('Operation 1.2');

//   await Future.delayed(Duration(seconds: 1)); // Untracked operation inside 1.2

//   FlowAnalyzer.startFlow('Operation 1.2.1');
//   await Future.delayed(Duration(milliseconds: 100));
//   FlowAnalyzer.endFlow(); // End Operation 1.2.1

//   FlowAnalyzer.endFlow(); // End Operation 1.2

//   // FlowAnalyzer.startFlow('Operation 1.3');
//   // await Future.delayed(Duration(milliseconds: 100));
//   // FlowAnalyzer.endFlow(); // End Operation 1.2

//   // FlowAnalyzer.startFlow('Operation 1.4');

//   // FlowAnalyzer.startFlow('Operation 1.4.1');
//   // await Future.delayed(Duration(milliseconds: 100));
//   // FlowAnalyzer.endFlow(); // End Operation 1.4.1

//   // FlowAnalyzer.startFlow('Operation 1.4.2');

//   // FlowAnalyzer.startFlow('Operation 1.4.2.1');
//   // await Future.delayed(Duration(milliseconds: 100));
//   // FlowAnalyzer.endFlow(); // End Operation 1.4.2.1

//   // FlowAnalyzer.startFlow('Operation 1.4.2.2');
//   // await Future.delayed(Duration(milliseconds: 100));
//   // FlowAnalyzer.endFlow(); // End Operation 1.4.2.2
//   // FlowAnalyzer.startFlow('Operation 1.4.2.3');
//   // await Future.delayed(Duration(milliseconds: 100));
//   // FlowAnalyzer.endFlow(); // End Operation 1.4.2.3

//   // FlowAnalyzer.endFlow(); // End Operation 1.4.2

//   // FlowAnalyzer.endFlow(); // End Operation 1.4

//   // Advanced usage with FlowAnalyzer.run
//   // await FlowAnalyzer.run(() async {
//   //   await Future.delayed(Duration(milliseconds: 100));
//   // }, 'Operation 1.5');

//   FlowAnalyzer.startFlow('Operations 1.6 - 1.7');
//   await other_file.runSomething();
//   FlowAnalyzer.endFlow(); // End Operations 1.6 - 1.7

//   FlowAnalyzer
//       .startFlow(); // This operation has no name so it will be named as the function name
//   await Future.delayed(Duration(milliseconds: 100));
//   FlowAnalyzer.endFlow(); // End unnamed operation

//   FlowAnalyzer.startFlow('Run Operation 1.8 in other file');
//   await other_file.runSomethingAndEndExternalFlow();
//   // Notice that the external flow is ended in the other file

//   FlowAnalyzer.endFlow(); // End Operation 1
// }
Future<void> flowExample() async {
  // Set forceShowMethodName to true to show the method name in the output
  FlowAnalyzer.forceShowMethodName = true;

  FlowAnalyzer.startFlow('A');

  FlowAnalyzer.startFlow('B');

  await Future.delayed(Duration(seconds: 1)); // Untracked operation inside B

  FlowAnalyzer.startFlow('C');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End C

  FlowAnalyzer.endFlow(); // End B

  FlowAnalyzer.startFlow('D');
  await other_file.runSomething(); // Inside there is E and F
  FlowAnalyzer.endFlow(); // End D

  FlowAnalyzer
      .startFlow(); // This operation has no name so it will be named as the function name
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End unnamed operation

  FlowAnalyzer.startFlow('G');
  await other_file.runSomethingAndEndExternalFlow();
  // Notice that we must not call endFlow here because it was already ended in the other file

  FlowAnalyzer.endFlow(); // End Operation 1
}
