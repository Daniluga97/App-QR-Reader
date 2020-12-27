import 'package:qr_reader/src/models/scan_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

abrirScan(ScanModel scan, BuildContext context) async {
  
  if (scan.tipo == "http") {
    // const url = 'https://flutter.dev';
    if (await canLaunch(scan.valor)) {
      await launch(scan.valor);
    } else {
      throw 'No se puede abrir el URL: $scan.valor';
    }
  } else {
    print("GEO");
    Navigator.pushNamed(context, "despliegueMapa", arguments: scan);
  }
  

  
}