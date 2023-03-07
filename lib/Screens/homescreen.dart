import 'package:flutter/material.dart';
import 'chartscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: const Text(
          'City List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamed(context, '/start');
          },
          color: Colors.black,
        ),
        //automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CityList(),
      ),
    );
  }
}

class CityList extends StatelessWidget {
  final List<String> cities = [
    'Tokyo',
    'Lahore',
    'London',
    'New York',
    'Mexico City',
    'Mumbai',
    'São Paulo',
    'Delhi',
    'Shanghai',
    'Beijing',
    'Lagos',
    'Islamabad',
    'Paris',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            cities[index],
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChartScreen(city: cities[index]),
            ),
          ),
        );
      },
    );
  }
}
