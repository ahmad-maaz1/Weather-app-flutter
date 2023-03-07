// import 'dart:async';
// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:flutter_app/weather_data.dart';
// import 'package:rxdart/rxdart.dart';

// class WeatherBloc {
//   final _cityController = BehaviorSubject<String>();
//   final _weatherController = BehaviorSubject<List<WeatherData>>();

//   Stream<List<WeatherData>> get weatherStream => _weatherController.stream;

//   Sink<String> get citySink => _cityController.sink;

//   WeatherBloc() {
//     _cityController.stream.listen((city) async {
//       try {
//         final queryParameters = {
//           'key': '497b848a2ac64d4ebaa94317230702',
//           'q': city,
//         };
//         final uri = Uri.http(
//             'api.weatherapi.com', '/v1/current.json', queryParameters);
//         final response = await http.get(uri);
//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//           final temperature = (data['current']['temp_c']).round();
//           final weatherData =
//               WeatherData(time: DateTime.now(), temp: temperature.toDouble());
//           _weatherController.add([weatherData]);
//         } else {
//           throw Exception('Failed to load temperature data');
//         }
//       } catch (e) {
//         print(e);
//       }
//     });
//   }

//   void dispose() {
//     _cityController.close();
//     _weatherController.close();
//   }
// }
