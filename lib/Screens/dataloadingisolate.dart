import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'temperaturedata.dart';
import 'dart:isolate';

class DataLoadingIsolate {
  final SendPort sendPort;
  final String city;

  DataLoadingIsolate(this.sendPort, this.city);

  static Future<DataLoadingIsolate> spawn(
      SendPort sendPort, String city) async {
    ReceivePort receivePort = ReceivePort();
    print('isnside spawn');
    Isolate isolate =
        await Isolate.spawn(_isolateEntry, [receivePort.sendPort, city]);
    SendPort sendPort = await receivePort.first;
    return DataLoadingIsolate(sendPort, city);
  }

  static void _isolateEntry(List args) {
    final sendPort = args[0] as SendPort;
    final city = args[1] as String;
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((message) async {
      if (message is SendPort) {
        final temperatureData = <_TemperatureData>[];
        while (true) {
          await Future.delayed(Duration(seconds: 1));
          print('inside isolate entry');
          final temperature = await _getTemperature(city);
          final xValue = DateTime.now().millisecondsSinceEpoch;
          temperatureData.add(_TemperatureData(xValue.toString(), temperature));
          message.send(temperatureData);
        }
      }
    });
  }

  static Future<int> _getTemperature(String city) async {
    final queryParameters = {
      'key': 'f9c9e9a00f13445c9dd153914232302',
      'q': city,
    };
    final uri =
        Uri.http('api.weatherapi.com', '/v1/current.json', queryParameters);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final temperature = (data['current']['temp_c']).round();
      print('data fetched');
      return temperature;
    } else {
      throw Exception('Failed to load temperature data');
    }
  }
}

class _TemperatureData {
  final String time;
  final int temperature;

  _TemperatureData(this.time, this.temperature);
}
