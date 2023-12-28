import 'package:flutter/material.dart';
import 'jogging_schedule_page.dart';

void main() {
  runApp(BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: BMICalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  int heightInFt = 5;
  int heightInInch = 0;
  int weight = 60;
  double bmi = 0.0;

  TextEditingController _heightFtController = TextEditingController();
  TextEditingController _heightInchController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

  // List to store jogging schedules
  List<JoggingSchedule> joggingSchedules = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Checker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Height',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _heightFtController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              heightInFt = int.parse(value);
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Feet',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _heightInchController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              heightInInch = int.parse(value);
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Inch',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Weight',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        weight = int.parse(value);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.pink,
            child: TextButton(
              onPressed: () {
                calculateBMI();
                _showBMIResult();
              },
              child: Text(
                'Calculate BMI',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Navigate to the jogging schedule page and pass the list of schedules
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JoggingSchedulePage(joggingSchedules),
                ),
              );
            },
            child: Text(
              'Jogging Schedule',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Reset button functionality
              setState(() {
                heightInFt = 5;
                heightInInch = 0;
                weight = 60;
                bmi = 0.0;
              });

              // Clear text fields for height and weight
              _heightFtController.clear();
              _heightInchController.clear();
              _weightController.clear();
            },
            child: Text(
              'Reset',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }

  void calculateBMI() {
    // Convert height to cm
    double heightInCm = (heightInFt * 30.48) + (heightInInch * 2.54);

    // BMI formula: BMI = weight (kg) / (height (m))^2
    double heightInMeters = heightInCm / 100.0;
    double heightSquared = heightInMeters * heightInMeters;
    bmi = weight / heightSquared;
  }

  void _showBMIResult() {
    String result;
    String advice;
    String suggestions;

    if (bmi < 18.5) {
      result = 'Underweight';
      advice = 'You should eat more and maintain a healthy diet.';
      suggestions =
          'Consider incorporating more protein and nutrient-rich foods into your diet.';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      result = 'Normal';
      advice = 'Congratulations! Your weight is in a healthy range.';
      suggestions =
          'Maintain a balanced diet and engage in regular physical activity for overall well-being.';
    } else if (bmi >= 25.0 && bmi < 29.9) {
      result = 'Overweight';
      advice = 'Consider exercising more and maintaining a balanced diet.';
      suggestions =
          'Include regular aerobic exercises and focus on portion control for weight management.';
    } else {
      result = 'Obese';
      advice = 'It is advisable to consult with a healthcare professional.';
      suggestions =
          'Seek professional advice for a personalized weight management plan and consider joining a fitness program.';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('BMI Result'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your BMI is ${bmi.toStringAsFixed(1)}'),
              SizedBox(height: 16.0),
              Text('Result: $result',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text('Advice: $advice'),
              SizedBox(height: 8.0),
              Text('Suggestions: $suggestions'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
