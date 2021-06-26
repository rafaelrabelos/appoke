import 'package:flutter/material.dart';
import 'package:poke_app/pages/home/Home.dart';

void main() {
  runApp(Application());
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Poke App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Home(title: "Poke App"),
      );

}
