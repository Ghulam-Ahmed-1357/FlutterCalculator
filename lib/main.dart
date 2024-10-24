// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String output = '0';
  String currentValue = '';
  double? num1;
  String? operator;
  double? result;
  String expression = '';

  void _clear() {
    setState(() {
      output = '0';
      currentValue = '';
      num1 = null;
      operator = null;
      expression = '';
    });
  }

  void _handleOperator(String newOperator) {
    if (currentValue.isNotEmpty) {
      setState(() {
        num1 = double.parse(currentValue);
        operator = newOperator;
        currentValue = '';
        expression += newOperator;
        output = expression;
      });
    }
  }

  void _addDigit(String digit) {
    setState(() {
      if (currentValue.length < 12) {
        currentValue += digit;
        expression += digit;
        output = expression;
      }
    });
  }

  void _calculate() {
    if (expression.isNotEmpty) {
      // Evaluate the full expression
      final exp = Expression.parse(expression);
      final evaluator = const ExpressionEvaluator();
      var result = evaluator.eval(exp, {});

      setState(() {
        if (result is int || result % 1 == 0) {
          output = result.toInt().toString();
        } else {
          output = result.toString();
        }

        expression = result.toString();
        currentValue = result.toString();
      });
    }
    // if (num1 != null && operator != null && currentValue.isNotEmpty) {
    //   double num2 = double.parse(currentValue);

    //   switch (operator!) {
    //     case '%':
    //       result = num1! % num2;
    //       break;
    //     case '+':
    //       result = num1! + num2;
    //       break;
    //     case '-':
    //       result = num1! - num2;
    //       break;
    //     case '*':
    //       result = num1! * num2;
    //       break;
    //     case '/':
    //       if (num2 != 0) {
    //         result = num1! / num2;
    //       } else {
    //         setState(() {
    //           output = 'Error';
    //         });
    //         return;
    //       }
    //       break;
    //   }
    // }

    // if (result != null) {
    //   setState(() {
    //     num1 = result;
    //     if (result! % 1 == 0) {
    //       output = result!.toInt().toString();
    //       currentValue = result!.toInt().toString();
    //     } else {
    //       output = result.toString();
    //       currentValue = result.toString();
    //     }
    //     operator = null;
    //   });
    // }
  }

  void _handleButtonClick(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _clear();
      } else if (buttonText == '←') {
        _deleteLast();
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '*' ||
          buttonText == '%' ||
          buttonText == '/') {
        _handleOperator(buttonText);
      } else if (buttonText == '±') {
        _toggleSign();
      } else if (buttonText == '.' && !currentValue.contains('.')) {
        _addDigit('.');
      } else if (buttonText == '=') {
        _calculate();
      } else {
        _addDigit(buttonText);
      }
    });
  }

  void _deleteLast() {
    setState(() {
      if (currentValue.isNotEmpty) {
        currentValue = currentValue.substring(0, currentValue.length - 1);
        if (currentValue.isEmpty) {
          output = '0';
        } else {
          output = currentValue;
          expression = currentValue;
        }
      }
    });
  }

  void _toggleSign() {
    if (currentValue.isNotEmpty) {
      setState(() {
        if (currentValue.startsWith('-')) {
          currentValue = currentValue.substring(1);
        } else {
          currentValue = '-$currentValue';
        }
        output = currentValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> buttons = [
      'C',
      '←',
      '%',
      '±',
      '7',
      '8',
      '9',
      '*',
      '4',
      '5',
      '6',
      '-',
      '1',
      '2',
      '3',
      '/',
      '0',
      '.',
      '=',
      '+',
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Calculator',
          style: TextStyle(fontSize: 26, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    output,
                    style: TextStyle(fontSize: 32.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            // SizedBox(height: 5),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 8, left: 8),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 3,
                    crossAxisCount: 4,
                    mainAxisSpacing: 3,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: buttons.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff0d2e52)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () {
                            _handleButtonClick(buttons[index]);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              buttons[index],
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ),
                        ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
