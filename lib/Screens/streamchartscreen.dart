import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'weatherbloc.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
//import 'package:rxdart/rxdart.dart';

int xValue = 1;

class StreamChartScreen extends StatefulWidget {
  final String city;

  const StreamChartScreen({Key? key, required this.city}) : super(key: key);

  @override
  _StreamChartScreenState createState() => _StreamChartScreenState();
}

class _StreamChartScreenState extends State<StreamChartScreen> {
  //late WeatherBloc _bloc = WeatherBloc();
  late Timer _timer;
  //List<WeatherData> weatherList = [];
  final List<WeatherData> weatherList = [];
  StreamController<WeatherData> _streamController = StreamController();

  Future<void> _getTemperature() async {
    //print('inside api');
    final queryParameters = {
      'key': 'f9c9e9a00f13445c9dd153914232302',
      'q': [widget.city],
    };
    final uri =
        Uri.http('api.weatherapi.com', '/v1/current.json', queryParameters);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final temperature = (data['current']['temp_c']).round();
      //print(temperature);
      final weatherData = WeatherData(xValue, temperature.toDouble());
      //weatherList.add(weatherData);
      xValue++;
      if (xValue > 10000) {
        xValue = 1;
      }
      if (!_streamController.isClosed) {
        _streamController.sink.add(weatherData);
      }
      //_streamController.sink.add(weatherData);
    } else {
      throw Exception('Failed to load temperature data');
    }
  }

  @override
  void initState() {
    super.initState();
    //print('super init');
    // _bloc = WeatherBloc();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      //_bloc.citySink.add(widget.city);
      _getTemperature();
    });
  }

  @override
  void dispose() {
    //_bloc.dispose();
    super.dispose();
    _timer.cancel();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: Text(
          widget.city,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
            //dispose();
          },
          color: Colors.black,
        ),
      ),
      body: StreamBuilder<WeatherData>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          weatherList.add(snapshot.data!);
          //final weatherList = snapshot.data!;
          //print(weatherList);
          return SfCartesianChart(
            primaryXAxis: NumericAxis(
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
            series: <LineSeries<WeatherData, int>>[
              LineSeries<WeatherData, int>(
                dataSource: weatherList,
                xValueMapper: (weather, _) => weather.xval,
                yValueMapper: (weather, _) => weather.temp,
                color: Colors.red,
                width: 5,
              )
            ],
          );
        },
      ),
    );
  }

  // double _getMinimumTemperature(WeatherData weatherList, index) {
  //   double minTemperature = double.infinity;

  //   for (final weather in weatherList) {
  //     if (weather.temp < minTemperature) {
  //       minTemperature = weather.temp;
  //     }
  //     weatherList = weatherList[index + 1];
  //   }

  //   return minTemperature - 5;
  // }

  // double _getMaximumTemperature(WeatherData weatherList) {
  //   double maxTemperature = double.negativeInfinity;

  //   for (final weather in weatherList) {
  //     if (weather.temp > maxTemperature) {
  //       maxTemperature = weather.temp;
  //     }
  //   }

  //   return maxTemperature + 5;
  // }
}

class WeatherData {
  final int xval;
  final double temp;

  WeatherData(this.xval, this.temp);
}

// class WeatherBloc {
//   final _cityController = BehaviorSubject<String>();
//   final _weatherController = BehaviorSubject<WeatherData>();

//   Stream<WeatherData> get weatherStream => _weatherController.stream;

//   Sink<String> get citySink => _cityController.sink;

//   WeatherBloc() {
//     _cityController.stream.listen((city) async {
//       try {
//         final queryParameters = {
//           'key': 'f9c9e9a00f13445c9dd153914232302',
//           'q': city,
//         };
//         final uri =
//             Uri.http('api.weatherapi.com', '/v1/current.json', queryParameters);
//         final response = await http.get(uri);
//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//           final temperature = (data['current']['temp_c']).round();
//           final weatherData = WeatherData(xValue, temperature.toDouble());
//           //_weatherController.add([weatherData]);
//           // final currentList = _weatherController.value ?? [];
//           // currentList.add(weatherData);
//           // currentList
//           //   ..add(weatherData)
//           //   ..sort((a, b) => a.xval.compareTo(b.xval));
//           // _weatherController.add(currentList);
//           //print(currentList);
//           _weatherController.sink.add(weatherData);
//         } else {
//           throw Exception('Failed to load temperature data');
//         }
//       } catch (e) {
//         print(e);
//       }
//     });
//     _weatherController.stream.listen((data) {
//       print(data);
//     });
//   }

//   void dispose() {
//     _cityController.close();
//     _weatherController.close();
//   }
// }
