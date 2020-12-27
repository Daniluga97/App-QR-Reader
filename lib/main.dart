import 'package:flutter/material.dart';
import 'package:qr_reader/src/pages/despliegueMapa_pages.dart';
import 'package:qr_reader/src/pages/direcciones_page.dart';
import 'package:qr_reader/src/pages/home_page.dart';
import 'package:qr_reader/src/pages/mapas_page.dart';
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Reader',
      initialRoute: "home",
      routes: {
        "home": (BuildContext context) => HomePage(),
        "mapas": (BuildContext context) => MapasPage(),
        "direcciones": (BuildContext context) => DireccionesPage(),
        "despliegueMapa": (BuildContext context) => DespliegueMapaPage(),

      },
      theme: ThemeData(
        primaryColor: Colors.green
      ),
    );
  }
} 