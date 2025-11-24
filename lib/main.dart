import 'package:flutter/material.dart';
import 'my_weather_model.dart';
import 'weather_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CIS 3334 Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Forecast>> futureWeatherForcasts;

  @override
  void initState() {
    super.initState();
    futureWeatherForcasts = fetchWeather();
  }

  Widget weatherImage(Weather weather) {
    String iconName;
    switch (weather.main) {
      case MainEnum.RAIN:
        iconName = 'rain.png';
        break;
      case MainEnum.CLOUDS:
        iconName = 'cloud.png';
        break;
      default:
        iconName = 'sun.png';
    }
    return Image(image: AssetImage('graphics/$iconName'));
  }

  Widget weatherTile(Forecast forecast) {
    return ListTile(
      leading: weatherImage(forecast.weather.first),
      title: Text(forecast.weather.first.description.toString().split('.').last),
      subtitle: Text(
          "The high will be ${forecast.main.tempMax} and the low will be ${forecast.main.tempMin}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Forecast>>(
        future: futureWeatherForcasts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Container();
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int position) {
                return Card(
                  child: weatherTile(snapshot.data![position]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
