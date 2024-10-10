# Flow Analyzer - Track & Measure Execution Flows in Dart

[![Dart CI](https://github.com/Jei-sKappa/flow-analyzer-dart/actions/workflows/ci.yml/badge.svg)](https://github.com/Jei-sKappa/flow-analyzer-dart/actions/workflows/ci.yml)
[![pub package](https://img.shields.io/pub/v/flow_analyzer.svg)](https://pub.dev/packages/flow_analyzer)
![pub points](https://img.shields.io/pub/points/flow_analyzer)
![pub Popularity](https://img.shields.io/pub/popularity/flow_analyzer)
![pub Likes](https://img.shields.io/pub/likes/flow_analyzer)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**Flow Analyzer** is a lightweight Dart library designed to help you track, measure, and visualize the performance of nested operations in your codebase. With this tool, you can monitor the execution time of your application, spot potential bottlenecks, and optimize your code flows effectively.

## Features
- **Track nested operations**: Analyze operations, including subflows and their execution times.
- **Detailed reporting**: Get a detailed breakdown of tracked operations with timings and file locations.
- **Supports both synchronous and asynchronous code**: Easily track async flows alongside sync code.
- **Customizable output**: Configure how results are displayed for better readability.
- **Non-intrusive flow tracking**: Minimal performance overhead and flexible integration into existing codebases.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flow_analyzer: ^0.1.0
```

and then run:

```bash
flutter pub get
```

Or just install the latest version using the CLI:

For dart projects:

```bash
dart pub add flow_analyzer
```

For flutter projects:

```bash
flutter pub add flow_analyzer
```

## Usage

### Basic Usage

Before running your code, start the flow using `FlowAnalyzer.startFlow()` and after the operation ends, call `FlowAnalyzer.endFlow()`:

```dart
FlowAnalyzer.startFlow(); // Or give it a name using FlowAnalyzer.startFlow('Operation Name');
// Your code here
FlowAnalyzer.endFlow();
```

### Advanced Usage

You can also entirely wrap your code with `FlowAnalyzer.run()` to track the execution time of a block of code:

```dart
final result = FlowAnalyzer.run(() {
  return "Hello, World!";
}, 'Optional operation name');

print(result); // Hello, World!
```

There is also support for asynchronous operations:

```dart
final result = await FlowAnalyzer.run(() async {
  await Future.delayed(Duration(seconds: 1));
  return "Thanks for waiting!";
});

print(result); // Thanks for waiting!
```

### Detailed example

```dart
// flow_analyzer_example.dart
Future<void> main() async {
  print('RUNNING FLOW ANALYZER...');

  FlowAnalyzer.startFlow('Operation 1');

  FlowAnalyzer.startFlow('Operation 1.1');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End Operation 1,1

  FlowAnalyzer.startFlow('Operation 1.2');

  await Future.delayed(Duration(seconds: 1)); // Untracked operation inside 1.2

  FlowAnalyzer.startFlow('Operation 1.2.1');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End Operation 1.2.1

  FlowAnalyzer.endFlow(); // End Operation 1.2

  FlowAnalyzer.startFlow('Operation 1.3');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End Operation 1.2

  FlowAnalyzer.startFlow('Operation 1.4');

  FlowAnalyzer.startFlow('Operation 1.4.1');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End Operation 1.4.1

  FlowAnalyzer.startFlow('Operation 1.4.2');

  FlowAnalyzer.startFlow('Operation 1.4.2.1');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End Operation 1.4.2.1

  FlowAnalyzer.startFlow('Operation 1.4.2.2');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End Operation 1.4.2.2
  FlowAnalyzer.startFlow('Operation 1.4.2.3');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End Operation 1.4.2.3

  FlowAnalyzer.endFlow(); // End Operation 1.4.2

  FlowAnalyzer.endFlow(); // End Operation 1.4

  // Advanced usage with FlowAnalyzer.run
  await FlowAnalyzer.run(() async {
    await Future.delayed(Duration(milliseconds: 100));
  }, 'Operation 1.5');

  FlowAnalyzer.startFlow('Operations 1.6 - 1.7');
  await other_file.runSomething();
  FlowAnalyzer.endFlow(); // End Operations 1.6 - 1.7

  FlowAnalyzer.startFlow(); // This operation has no name so it will be named as the function name
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End unnamed operation

  FlowAnalyzer.endFlow(); // End Operation 1
}
```

```dart
// other_file.dart
Future<void> runSomething() async {
  FlowAnalyzer.startFlow('Operation 1.6');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End Operation 1.6

  FlowAnalyzer.startFlow('Operation 1.7');
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End Operation 1.7
}
```

The output provides a detailed breakdown of each operation:

```shell
+-- Operation ------------+-- Time ---------+-- Non tracked ------------+-- Start Location ----------------------------------+ 
| Operation 1             |  2s 135ms  80µs |           842µs   (0.00%) | file:///your_path/flow_analyzer_example.dart:12:16 |
|   Operation 1.1         |     105ms 532µs |                         / | file:///your_path/flow_analyzer_example.dart:14:16 |
|   Operation 1.2         |  1s 105ms 255µs |  1s   2ms 735µs  (90.22%) | file:///your_path/flow_analyzer_example.dart:18:16 |
|     Operation 1.2.1     |     102ms 520µs |                         / | file:///your_path/flow_analyzer_example.dart:22:16 |
|   Operation 1.3         |     102ms 308µs |                         / | file:///your_path/flow_analyzer_example.dart:28:16 |
|   Operation 1.4         |     409ms 402µs |             7µs   (0.00%) | file:///your_path/flow_analyzer_example.dart:32:16 |
|     Operation 1.4.1     |     102ms  92µs |                         / | file:///your_path/flow_analyzer_example.dart:34:16 |
|     Operation 1.4.2     |     307ms 303µs |            32µs   (0.00%) | file:///your_path/flow_analyzer_example.dart:38:16 |
|       Operation 1.4.2.1 |     102ms 450µs |                         / | file:///your_path/flow_analyzer_example.dart:40:16 |
|       Operation 1.4.2.2 |     102ms 325µs |                         / | file:///your_path/flow_analyzer_example.dart:44:16 |
|       Operation 1.4.2.3 |     102ms 496µs |                         / | file:///your_path/flow_analyzer_example.dart:47:16 |
|   Operation 1.5         |     104ms 107µs |                         / | file:///your_path/flow_analyzer_example.dart:56:22 |
|   Operations 1.6 - 1.7  |     205ms 289µs |           355µs   (0.00%) | file:///your_path/flow_analyzer_example.dart:60:16 |
|     Operation 1.6       |     102ms 602µs |                         / | file:///your_path/other_file.dart:4:16             |
|     Operation 1.7       |     102ms 332µs |                         / | file:///your_path/other_file.dart:8:16             |
|   flowExample           |     102ms 345µs |                         / | file:///your_path/flow_analyzer_example.dart:64:16 |
+----------------------------------------------------------------------------------------------------------------------------+

```
> **Note:** As you can see the execution time is not exactly the time awaited by the `Future.delayed`, this is due to how Dart handles Futures and not by this package. Operations other than `Future.delayed` will have a more _realistic_ time measurement.


<!-- You can modify the output format by changing the `FlowAnalyzer.outputMode` and `FlowAnalyzer.forceShowMethodName` properties:

```dart
FlowAnalyzer.outputMode = CustomFlowOutputMode();  // Implement your own output formatting
FlowAnalyzer.forceShowMethodName = true;  // Force displaying the method name in output
``` -->
## Customizations

### Output Mode

You can customize how the output is displayed by implementing your own `FlowOperationOutputMode` and setting it to `FlowAnalyzer.outputMode`:

```dart
class CustomFlowOutputMode extends FlowOperationOutputMode {
  @override
  void output(FlowOperation operation) {
    // Your custom output logic here
  }
}

void main() {
  FlowAnalyzer.outputMode = CustomFlowOutputMode();
}
```

#### Default Mode: IndentedFlowOperationOutputMode

By default, the output is displayed using `IndentedFlowOperationOutputMode`, which provides a detailed breakdown of each operation with nested operation indetation.

It has a few parameters that you can customize:

- `indent`: The number of spaces to indent nested operations. Default is `2`.
- `threshold`: The minimum time threshold for an operation to be displayed. Default is `null`.
- `showFileStartLocation`: Whether to display the file location, line, and column where the operation started. Default is `true`.
- `showFileEndLocation`: Whether to display the file location, line, and column where the operation ended. Default is `false`.

##### Output Breakdown
Each operation is measured for:
- **Execution time**: The total time spent on the operation.
- **Untracked time**: Time spent in unmonitored code (e.g., delays).
- **Start location**: The file and line number where the flow started, making it easy to trace.

### Force Show Method Name

By default, the method name is only displayed if the operation is not named. You can force the method name to be displayed by setting `FlowAnalyzer.forceShowMethodName` to `true`:

```dart
// flow_analyzer_example.dart
Future<void> main() async {
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

  FlowAnalyzer.startFlow(); // This operation has no name so it will be named as the function name
  await Future.delayed(Duration(milliseconds: 100));
  FlowAnalyzer.endFlow(); // End unnamed operation

  FlowAnalyzer.startFlow('G');
  await other_file.runSomethingAndEndExternalFlow();
  // Notice that we must not call endFlow here because it was already ended in the other file

  FlowAnalyzer.endFlow(); // End Operation 1
}
```

```dart
// other_file.dart
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
```

```shell
+-- Operation --------------------------------+-- Time ---------+-- Non tracked ------------+-- Start Location -----------------------------------+ 
| main : A                                    |  1s 529ms 623µs |           100µs   (0.00%) | file:///your_path/flow_analyzer_example.dart:81:16  |
|   main : B                                  |  1s 112ms 594µs |  1s   8ms 571µs  (90.15%) | file:///your_path/flow_analyzer_example.dart:83:16  |
|     main : C                                |     104ms  23µs |                         / | file:///your_path/flow_analyzer_example.dart:87:16  |
|   main : D                                  |     211ms 791µs |       1ms  92µs   (0.02%) | file:///your_path/flow_analyzer_example.dart:93:16  |
|     runSomething : E                        |     102ms 229µs |                         / | file:///your_path/other_file.dart:14:16             |
|     runSomething : F                        |     108ms 470µs |                         / | file:///your_path/other_file.dart:18:16             |
|   main                                      |     102ms 159µs |                         / | file:///your_path/flow_analyzer_example.dart:97:16  |
|   main : G : runSomethingAndEndExternalFlow |     102ms 979µs |           557µs   (0.04%) | file:///your_path/flow_analyzer_example.dart:101:16 |
|     runSomethingAndEndExternalFlow : H      |     102ms 422µs |                         / | file:///your_path/other_file.dart:24:16             |
+-------------------------------------------------------------------------------------------------------------------------------------------------+
```

> **Note:** The operation "G" also has a method name and the right, this is because the flow is ended in a method different from where it started.

## Contributing

We welcome contributions! Please open an issue or submit a pull request on [GitHub](https://github.com/Jei-sKappa/flow-analyzer-dart).

## License

This project is licensed under the [MIT License](LICENSE).

## Stay Connected

For more updates and news, follow the repository and give us a ⭐️ if you find this package useful!

---

Made with ❤️ by [Jei-sKappa](https://github.com/Jei-sKappa)
