import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String answer = "";
  String answerTemp = "";
  String inputFull = "";
  String operator = "";
  bool calculateMode = false;
  @override
  void initState() {
    answer = "0";
    operator = "";
    answerTemp = "";
    inputFull = "";
    calculateMode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caculator'),
      ),
      body: Column(
        children: <Widget>[
          AnswerBox(),
          NumpadWidget(),
        ],
      ),
    );
  }

  //box answer Widget
  Widget AnswerBox() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      padding: EdgeInsets.all(16),
      constraints: BoxConstraints.expand(height: 230),
      color: Color.fromARGB(40, 231, 227, 227),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(inputFull + " " + operator, style: TextStyle(fontSize: 18)),
            Text(answer,
                style: TextStyle(fontSize: 53, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  //Numpad Widget
  Widget NumpadWidget() {
    return Container(
      color: Colors.lightBlue,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(children: <Widget>[
            NumberButtom("CE", numbtn: false, onTap: () {
              clearAll();
            }),
            NumberButtom("C", numbtn: false, onTap: () {
              clearNum();
            }),
            NumberButtom("⌫", numbtn: false, onTap: () {
              removeAns();
            }),
            NumberButtom("÷", numbtn: false, onTap: () {
              addOperatorToAnswer("÷");
            }),
          ]),
          Row(
            children: <Widget>[
              NumberButtom('7', onTap: () {
                addNumAns(7);
              }),
              NumberButtom('8', onTap: () {
                addNumAns(8);
              }),
              NumberButtom('9', onTap: () {
                addNumAns(9);
              }),
              NumberButtom('×', numbtn: false, onTap: () {
                addOperatorToAnswer("×");
              }),
            ],
          ),
          Row(
            children: <Widget>[
              NumberButtom('4', onTap: () {
                addNumAns(4);
              }),
              NumberButtom('5', onTap: () {
                addNumAns(5);
              }),
              NumberButtom('6', onTap: () {
                addNumAns(6);
              }),
              NumberButtom('-', numbtn: false, onTap: () {
                addOperatorToAnswer("-");
              }),
            ],
          ),
          Row(
            children: <Widget>[
              NumberButtom('1', onTap: () {
                addNumAns(1);
              }),
              NumberButtom('2', onTap: () {
                addNumAns(2);
              }),
              NumberButtom('3', onTap: () {
                addNumAns(3);
              }),
              NumberButtom('+', numbtn: false, onTap: () {
                addOperatorToAnswer("+");
              }),
            ],
          ),
          Row(
            children: <Widget>[
              NumberButtom("±", numbtn: false, onTap: () {
                toggleNegative();
              }),
              NumberButtom("0", onTap: () {
                addNumAns(0);
              }),
              NumberButtom(".", numbtn: false, onTap: () {
                addDot();
              }),
              NumberButtom("=", numbtn: false, onTap: () {
                addOperatorToAnswer("=");
              }),
            ],
          )
        ],
      ),
    );
  }

  void calculate() {
    setState(() {
      if (calculateMode) {
        bool decimalMode = false;
        double value = 0;
        if (answer.contains(".") || answerTemp.contains(".")) {
          decimalMode = true;
        }

        if (operator == "+") {
          value = (double.parse(answerTemp) + double.parse(answer));
        } else if (operator == "-") {
          value = (double.parse(answerTemp) - double.parse(answer));
        } else if (operator == "×") {
          value = (double.parse(answerTemp) * double.parse(answer));
        } else if (operator == "÷") {
          value = (double.parse(answerTemp) / double.parse(answer));
        }

        if (!decimalMode) {
          answer = value.toInt().toString();
        } else {
          answer = value.toString();
        }

        calculateMode = false;
        operator = "";
        answerTemp = "";
        inputFull = "";
      }
    });
  }

  void addOperatorToAnswer(String op) {
    setState(() {
      if (answer != "0" && !calculateMode) {
        calculateMode = true;
        answerTemp = answer;
        inputFull += operator + " " + answerTemp;
        operator = op;
        answer = "0";
      } else if (calculateMode) {
        if (answer.isNotEmpty) {
          calculate();
          answerTemp = answer;
          inputFull = "";
          operator = "";
        } else {
          operator = op;
        }
      }
    });
  }

  void toggleNegative() {
    setState(() {
      if (answer.contains("-")) {
        answer = answer.replaceAll("-", "");
      } else {
        answer = "-" + answer;
      }
    });
  }

  void addNumAns(int number) {
    setState(() {
      if (number == 0 && answer == "0") {
      } else if (number != 0 && answer == "0") {
        answer = number.toString();
      } else {
        answer += number.toString();
      }
    });
  }

  void removeAns() {
    if (answer == "0") {
      // Not do anything.
    } else {
      setState(() {
        if (answer.length > 1) {
          answer = answer.substring(0, answer.length - 1);
        } else {
          answer = "0";
        }
      });
    }
  }

  void clearNum() {
    setState(() {
      answer = '0';
    });
  }

  void clearAll() {
    setState(() {
      answer = "0";
      inputFull = "";
      calculateMode = false;
      operator = "";
    });
  }

  void addDot() {
    setState(() {
      if (!answer.contains(".")) {
        answer = answer + ".";
      }
    });
  }

  Expanded NumberButtom(String str,
      {@required Function()? onTap, bool numbtn = true}) {
    Widget widget;
    if (numbtn) {
      widget = Container(
          margin: EdgeInsets.all(1),
          child: Material(
              color: Colors.white,
              child: InkWell(
                  onTap: onTap,
                  splashColor: Colors.blue,
                  child: Container(
                      height: 80,
                      child: Center(
                          child: Text(str,
                              style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold)))))));
    } else {
      widget = Container(
          margin: EdgeInsets.all(1),
          child: Material(
              color: Color(0xffecf0f1),
              child: InkWell(
                  onTap: onTap,
                  splashColor: Colors.blue,
                  child: Container(
                      height: 80,
                      child: Center(
                          child: Text(str, style: TextStyle(fontSize: 38)))))));
    }
    return Expanded(child: widget);
  }
}
