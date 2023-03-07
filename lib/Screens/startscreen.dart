import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Weather App'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.0, 120, 8, 0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Weather through Timer',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              ElevatedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text(
                  'Click here!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Weather through Isolate',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              ElevatedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/isolatehome');
                },
                child: const Text(
                  'Click here!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Weather through streams',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              ElevatedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/streamhomescreen');
                },
                child: const Text(
                  'Click here!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
