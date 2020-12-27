import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_reader/src/bloc/scans_bloc.dart';
import 'package:qr_reader/src/models/scan_models.dart';
import 'package:qr_reader/src/pages/direcciones_page.dart';
import 'package:qr_reader/src/pages/mapas_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_reader/src/providers/db_provider.dart';
import 'package:qr_reader/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;
  ScanResult scanResult;
  final scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever), 
            onPressed: scansBloc.borrarTodosScans,          
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _crearFloatingActionButton(),
    );
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text("Mapas"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions),
          title: Text("Direcciones"),
        ),
      ],
      currentIndex: currentIndex,
      onTap: (index){
        print(index);
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  Widget _callPage(int paginaActual) {
    switch ( paginaActual ){
      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default: return MapasPage();
    }
  }

  _crearFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () => _scanQR(context)
    );
  }

  void _scanQR(BuildContext context) async {
    // print("Scan QR...");
    // https://www.udemy.com/
    // geo:40.72943664472433,-73.99083509882816

    String futureString;

    try {
      var result = await BarcodeScanner.scan();
      setState(() => scanResult = result );
      futureString = result.rawContent.toString();

    }catch(e){
      futureString=e.toString();
    }
 
   
    if(futureString != null){
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScans(scan);

      // final scan2 = ScanModel(valor: "geo:40.72943664472433,-73.99083509882816");
      // scansBloc.agregarScans(scan2);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), (){
          utils.abrirScan(scan, context);
        });
      } else {
        utils.abrirScan(scan, context);
      }
        
    }
  }
}