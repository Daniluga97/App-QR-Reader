import 'dart:async';

import 'package:qr_reader/src/models/scan_models.dart';

class ValidatorBloc {

  final validarGeolocalizacion = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final scansGeolocalizacion = scans.where((i) => i.tipo == "geo").toList();
      sink.add(scansGeolocalizacion);
    }
  );

  final validarHTTP = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final scansHTTP = scans.where((i) => i.tipo == "http").toList();
      sink.add(scansHTTP);
    }
  );

}