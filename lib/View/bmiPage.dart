import 'package:flutter/material.dart';
import 'package:flutterdemo/widgets/custom_Card.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BMIScreen(),
    );
  }
}

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: const Center(
              child: Text(
            "SCORE CARD",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
      ),
      body: Card(
        child: SizedBox(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    CustomCard(color: Colors.amberAccent, radius: 35.0, context: context),
                    const Text(
                      "BMI",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                  Column(children: [
                    CustomCard(color: Colors.blue, radius: 35.0, context: context),
                    const Text(
                      "HEART",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                  Column(children: [
                    CustomCard(color: Colors.brown, radius: 35.0, context: context),
                    const Text(
                      "PULSE",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                  Column(children: [
                    CustomCard(color: Colors.purple, radius: 35.0, context: context),
                    const Text(
                      "BP",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    CustomCard(color: Colors.red, radius: 35.0, context: context),
                    const Text(
                      "SPO2",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                  Column(children: [
                    CustomCard(color: Colors.green, radius: 35.0, context: context),
                    const Text(
                      "BP MIN",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                  Column(children: [
                    CustomCard(color: Colors.cyan, radius: 35.0, context: context),
                    const Text(
                      "BP MAX",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                  Column(children: [
                    CustomCard(color: Colors.teal, radius: 35.0, context: context),
                    const Text(
                      "RBC",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
