import 'package:flutter/material.dart';

void main() => runApp(CalculatriceApp());

class CalculatriceApp extends StatelessWidget {
  const CalculatriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Calculatrice(),
    );
  }
}

class Calculatrice extends StatefulWidget {
  const Calculatrice({super.key});

  @override
  _CalculatriceState createState() => _CalculatriceState();
}

class _CalculatriceState extends State<Calculatrice> {
  String output = "0";
  String _output = "0";
  String expression = "";
  double num1 = 0;
  double num2 = 0;
  String operand = "";
  bool operationJustPressed = false;

  // Effectue le calcul en fonction de l'opérateur
  double performCalculation(double n1, double n2, String op) {
    if (op == "+") {
      return n1 + n2;
    } else if (op == "-") {
      return n1 - n2;
    } else if (op == "*") {
      return n1 * n2;
    } else if (op == "/") {
      return n1 / n2;
    }
    return n1; // Par défaut, retourne n1 si l'opérateur n'est pas reconnu
  }

  void buttonPressed(String buttonText) {
    if (buttonText == "C") {
      _output = "0";
      expression = "";
      num1 = 0;
      num2 = 0;
      operand = "";
      operationJustPressed = false;
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "*" ||
        buttonText == "/") {
      // Si une opération a déjà été sélectionnée et qu'on en presse une autre,
      // mettre à jour l'opération
      if (operand.isNotEmpty && operationJustPressed) {
        operand = buttonText;
        // Mettre à jour le dernier caractère de l'expression
        expression =
            expression.substring(0, expression.length - 1) + buttonText;
      } else {
        // Si on a déjà un opérateur et un second nombre, calculer le résultat intermédiaire
        if (operand.isNotEmpty && !operationJustPressed) {
          num2 = double.parse(_output);

          // Calculer le résultat intermédiaire
          double result = performCalculation(num1, num2, operand);

          // Formater le résultat
          _output = result.toString();
          if (_output.endsWith(".0")) {
            _output = _output.substring(0, _output.length - 2);
          }

          // Mettre à jour pour la prochaine opération
          num1 = result;

          // Mettre à jour l'expression pour afficher le résultat intermédiaire
          expression = _output + buttonText;
        } else {
          // Première sélection d'une opération
          num1 = double.parse(_output);
          expression += buttonText;
        }

        operand = buttonText;
        operationJustPressed = true;
      }
    } else if (buttonText == "=") {
      // Calculer seulement si une opération existe ET un second nombre a été entré
      if (operand.isNotEmpty && !operationJustPressed) {
        num2 = double.parse(_output);

        // Calculer le résultat
        double result = performCalculation(num1, num2, operand);
        _output = result.toString();

        // Formater le résultat
        if (_output.endsWith(".0")) {
          _output = _output.substring(0, _output.length - 2);
        }

        // Réinitialiser pour un nouveau calcul
        expression = _output;
        num1 = double.parse(_output);
        num2 = 0;
        operand = "";
        operationJustPressed = false;
      }
    } else {
      // Gestion de la saisie des nombres
      if (operationJustPressed) {
        _output = buttonText;
        operationJustPressed = false;
      } else if (_output == "0") {
        _output = buttonText;
      } else {
        _output = _output + buttonText;
      }

      expression += buttonText;
    }

    setState(() {
      output = expression.isEmpty ? _output : expression;
    });
  }

  // Fonction pour vérifier si le bouton égal est utilisable
  bool isEqualButtonEnabled() {
    // Le bouton égal est activé seulement si un opérateur a été entré ET un second nombre a également été entré

    return operand.isNotEmpty && !operationJustPressed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculatrice Flutter'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              alignment: Alignment.bottomRight,
              child: Text(
                output,
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: 16,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                List<String> buttons = [
                  '7',
                  '8',
                  '9',
                  '/',
                  '4',
                  '5',
                  '6',
                  '*',
                  '1',
                  '2',
                  '3',
                  '-',
                  'C',
                  '0',
                  '=',
                  '+'
                ];

                // Définir les couleurs des boutons selon leur type
                Color buttonColor;
                Color textColor = Colors.white;

                if (buttons[index] == 'C') {
                  buttonColor = Colors.red;
                } else if (buttons[index] == '=') {
                  // Si le bouton égal est désactivé, on le rend gris
                  buttonColor =
                      isEqualButtonEnabled() ? Colors.green : Colors.grey;
                } else if (buttons[index] == '+' ||
                    buttons[index] == '-' ||
                    buttons[index] == '*' ||
                    buttons[index] == '/') {
                  buttonColor = Colors.orange;
                } else {
                  buttonColor = Colors.blue;
                }

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Désactiver le bouton = s'il n'est pas utilisable
                    if (buttons[index] == '=' && !isEqualButtonEnabled()) {
                      // Ne rien faire si le bouton est désactivé
                      return;
                    }
                    buttonPressed(buttons[index]);
                  },
                  child: Text(
                    buttons[index],
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
