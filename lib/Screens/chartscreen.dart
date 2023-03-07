import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  final String city;

  ChartScreen({required this.city});

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  int temperature = 0;
  int xValue = 1;
  List<_TemperatureData> temperatureData = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _getTemperature();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        xValue += 1;
        if (xValue > 10000) {
          xValue = 1;
        }
      });
      _getTemperature();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _getTemperature() async {
    final queryParameters = {
      'key': 'f9c9e9a00f13445c9dd153914232302',
      'q': [widget.city],
    };
    final uri =
        Uri.http('api.weatherapi.com', '/v1/current.json', queryParameters);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        temperature = (data['current']['temp_c']).round();
        temperatureData.add(_TemperatureData(xValue.toString(), temperature));
      });
    } else {
      throw Exception('Failed to load temperature data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: Text(
          '${widget.city} Weather',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
            dispose();
          },
          color: Colors.black,
        ),
      ),
      body: temperature == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(
                    text: 'Time (seconds)',
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(
                    text: 'Temperature (Celcius)',
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                series: <LineSeries<_TemperatureData, String>>[
                  LineSeries<_TemperatureData, String>(
                    dataSource: temperatureData,
                    xValueMapper: (_TemperatureData data, _) => data.time,
                    yValueMapper: (_TemperatureData data, _) =>
                        data.temperature,
                    color: Colors.red,
                    width: 5,
                  ),
                ],
              ),
            ),
    );
  }
}

class _TemperatureData {
  _TemperatureData(this.time, this.temperature);

  final String time;
  final int temperature;
}
