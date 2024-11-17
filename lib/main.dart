import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const AdvancedScientificCalculatorApp());
}

class AdvancedScientificCalculatorApp extends StatelessWidget {
  const AdvancedScientificCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Scientific Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const ScientificCalculatorScreen(),
    );
  }
}

class ScientificCalculatorScreen extends StatefulWidget {
  const ScientificCalculatorScreen({super.key});

  @override
  State<ScientificCalculatorScreen> createState() =>
      _ScientificCalculatorScreenState();
}

class _ScientificCalculatorScreenState
    extends State<ScientificCalculatorScreen> {
  String input = ''; // Current input displayed
  String result = '0'; // Current calculation result
  bool isResultShown = false; // Tracks if the result was just shown
  List<String> history = []; // Stores calculation history

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '0';
        isResultShown = false;
      } else if (value == 'DEL') {
        if (input.isNotEmpty && !isResultShown) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == '=') {
        if (input.isNotEmpty) {
          try {
            result = calculateResult(input);
            history.add('$input = $result');
            input = result; // Carry forward the result
            isResultShown = true;
          } catch (e) {
            result = 'Error';
          }
        }
      } else {
        if (isResultShown) {
          if (isOperator(value)) {
            input = result + value; // Append operator to result
          } else {
            input = value; // Reset input for new calculation
          }
          isResultShown = false;
        } else {
          input += value;
        }
      }
    });
  }

  String calculateResult(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
    Parser parser = Parser();
    Expression exp = parser.parse(expression);
    ContextModel contextModel = ContextModel();
    double evalResult = exp.evaluate(EvaluationType.REAL, contextModel);
    return evalResult.toString();
  }

  bool isOperator(String button) {
    return ['+', '-', '×', '÷', '=', 'DEL', 'C', '^', '(', ')'].contains(button);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        children: [
          // Display Section
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[900],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      input,
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    result,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // History Section
          if (history.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey[850],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return Text(
                          history[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white60,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Buttons Section
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: advancedButtons.length,
                itemBuilder: (context, index) {
                  final button = advancedButtons[index];
                  return ElevatedButton(
                    onPressed: () => onButtonPressed(button),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOperator(button)
                          ? Colors.blueAccent
                          : Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text(
                      button,
                      style: TextStyle(
                        fontSize: 18,
                        color: isOperator(button) ? Colors.white : Colors.white70,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const List<String> advancedButtons = [
  'C',
  'DEL',
  '(',
  ')',
  '^',
  'sin',
  'cos',
  'tan',
  '7',
  '8',
  '9',
  '÷',
  '4',
  '5',
  '6',
  '×',
  '1',
  '2',
  '3',
  '-',
  '0',
  '.',
  '+',
  '='
];
