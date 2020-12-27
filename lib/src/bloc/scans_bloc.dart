import 'dart:async';

import 'package:qr_reader/src/bloc/validator_bloc.dart';
import 'package:qr_reader/src/models/scan_models.dart';
import 'package:qr_reader/src/providers/db_provider.dart';

class ScansBloc with ValidatorBloc{

  static final ScansBloc _singleton = ScansBloc._();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._(){
    // Obtener scans de la BBDD
    obtenerScans();
   }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validarGeolocalizacion);
  Stream<List<ScanModel>> get scansStreamHTTP => _scansController.stream.transform(validarHTTP);

  dispose(){
    _scansController?.close();
  }

  obtenerScans() async {
    _scansController.sink.add(await DBProvider.db.getTodosScans());
  }

  agregarScans(ScanModel scan) async {
      await DBProvider.db.nuevoScan(scan);
      obtenerScans();
  }

  borrarScans(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarTodosScans() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }
}