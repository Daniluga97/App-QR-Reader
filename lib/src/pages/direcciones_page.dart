import 'package:flutter/material.dart';
import 'package:qr_reader/src/bloc/scans_bloc.dart';
// import 'package:qr_reader/src/providers/db_provider.dart';
import 'package:qr_reader/src/utils/utils.dart' as utils;

class DireccionesPage extends StatelessWidget {
  
  final scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {
    
    scansBloc.obtenerScans();

    return StreamBuilder(
      stream: scansBloc.scansStreamHTTP,
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator()
          );
        }

        final scans = snapshot.data;

        if(scans.length == 0){
          return Center(
            child: Text("No hay info"),
          );
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) => scansBloc.borrarScans(scans[i].id),
            child: ListTile(
              leading: Icon(Icons.http, color: Theme.of(context).primaryColor),
              title: Text(scans[i].valor),
              subtitle: Text("ID: ${scans[i].id}"),
              trailing: Icon(Icons.arrow_right, color: Colors.grey),
              onTap: () {
                utils.abrirScan(scans[i], context);
              },
            ),
          ),
        );
       
      },
    );
  }
}