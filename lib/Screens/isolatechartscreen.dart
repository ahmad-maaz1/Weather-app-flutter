import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'temperaturedata.dart';
import 'dataloadingisolate.dart';

class IsolateChartScreen extends StatefulWidget {
  final String city;
  IsolateChartScreen({required this.city});

  @override
  _IsolateChartScreenState createState() => _IsolateChartScreenState();
}

class _IsolateChartScreenState extends State<IsolateChartScreen> {
  late List<_TemperatureData> _temperatureData;
  late Isolate _isolate;
  ReceivePort _receivePort = ReceivePort();
  bool _loadingData = true;
  late DataLoadingIsolate isolate;

  @override
  void initState() {
    super.initState();
    _temperatureData = [];
    _initializeIsolate();
  }

  void _initializeIsolate() async {
  _receivePort.listen((dynamic message) {
    if (message is List<_TemperatureData>) {
      setState(() {
        _temperatureData = message;
        _loadingData = false;
      });
    }
  });
  print('going into data laoding state');
  isolate = await DataLoadingIsolate.spawn(
    _receivePort.sendPort,
    widget.city,
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Chart'),
      ),
      body: _loadingData
          ? Center(
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
                    dataSource: _temperatureData,
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

  @override
  void dispose() {
    if (isolate != null) {
      _isolate.kill();
    }
    super.dispose();
  }
}

class _TemperatureData {
  final String time;
  final int temperature;

  _TemperatureData(this.time, this.temperature);
}
