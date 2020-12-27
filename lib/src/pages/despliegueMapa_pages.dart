import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qr_reader/src/models/scan_models.dart';

class DespliegueMapaPage extends StatefulWidget {
  
  @override
  _DespliegueMapaPageState createState() => _DespliegueMapaPageState();
}

class _DespliegueMapaPageState extends State<DespliegueMapaPage> {
  final controladorMapa = MapController();

  String tipoMapa = "streets-v11";

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Coordenadas QR"),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: () {
              controladorMapa.move(scan.getLatitudLongitud(), 15);
            }
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _botonCambioMapa(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: controladorMapa,
      options: MapOptions(
        center: scan.getLatitudLongitud(),
        zoom: 15
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
 }

  _crearMapa() {

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: {
        'accessToken':'pk.eyJ1IjoiZGFuaWx1Z2FzdHVmZiIsImEiOiJja2ZpNTQ1MDkwMGl5MnJudXZ5eHk4OXpkIn0.0lW4D7Mwa3KsxsNHT9kAEg',
        'id': 'mapbox/$tipoMapa' 
        //streets, dark, light, outdoors, satellite
        }
    );

  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(
      markers: [
        Marker(
          width: 120.0,
          height: 120.0,
          point: scan.getLatitudLongitud(),
          builder: (context) =>
            Container(
              child: Icon(
                Icons.location_on, 
                size: 80.0, 
                color: Theme.of(context).primaryColor,
              ),
            )
        )
      ]
    );
  }

  Widget _botonCambioMapa(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (tipoMapa == "streets-v11") {
          tipoMapa = "outdoors-v11";
        } else if (tipoMapa == "outdoors-v11"){
          tipoMapa = "light-v10";
        } else if (tipoMapa == "light-v10") {
          tipoMapa = "dark-v10";
        } else if (tipoMapa == "dark-v10") {
          tipoMapa = "satellite-v9";
        } else if (tipoMapa == "satellite-v9") {
          tipoMapa = "satellite-streets-v11";
        } else if (tipoMapa == "satellite-streets-v11") {
          tipoMapa = "streets-v11";
        }
        setState((){});
      },
            child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
