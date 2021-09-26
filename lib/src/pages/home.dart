import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_intermedios_udemy/src/models/pokemon.dart';
import 'package:flutter_proyecto_intermedios_udemy/src/services/socket_service.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget{

  @override
  HomePageState createState()=> HomePageState();
}

class HomePageState extends State<HomePage>{

  List<Pokemon> listPokemon=[];

  @override
  void initState() {
    final socketService=Provider.of<SocketService>(context,listen: false);

    socketService.socket.on('pokemon-registrados',_handleActivePokemon);
    super.initState();
  }

  _handleActivePokemon(dynamic payload){
    this.listPokemon=(payload as List)
        .map((pokemon) => Pokemon.fromMap(pokemon))
        .toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService=Provider.of<SocketService>(context,listen: false);
    socketService.socket.off('pokemon-registrados');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService=Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('PokemonNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus==ServerStatus.online)
              ? Icon(Icons.check_circle, color: Colors.blue[300])
              : Icon(Icons.offline_bolt, color: Colors.red)
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _showPieData(),
          Expanded(
            child: ListView.builder(
              itemCount: listPokemon.length,
              itemBuilder: (context, index)=>_pokemonTile(listPokemon[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewPokemon,
      ),
    );
  }
  
  Widget _pokemonTile(Pokemon pokemon){
    final socketService=Provider.of<SocketService>(context,listen: false);
    
    return Dismissible(
      key: Key(pokemon.id),
      direction: DismissDirection.startToEnd,
      //delete en el servidor
      onDismissed: (_)=>socketService.socket.emit('delete-pokemon',{'id':pokemon.id}),
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Borrar pokemon',style: TextStyle(color: Colors.white)),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(pokemon.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(pokemon.name),
        trailing: Text('${pokemon.votes}', style: TextStyle(fontSize: 20)),
        onTap: ()=>socketService.socket.emit('vote-pokemon',{'id':pokemon.id}),
      ),
    );
  }

  addNewPokemon(){

    final textController=TextEditingController();

    if(Platform.isAndroid){
      return showDialog(
          context: context,
          builder: (_)=>AlertDialog(
              title: Text('Nuevo pokemon:'),
              content: TextField(
                controller: textController,
              ),
              actions: <Widget>[
                MaterialButton(
                    child: Text('Añadir'),
                    elevation: 5,
                    textColor: Colors.blue,
                    onPressed: ()=>addPokemonToList(textController.text)
                ),
              ],
            )
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_)=>CupertinoAlertDialog(
          title: Text('Nuevo Pokemon'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Añadir'),
              onPressed: ()=>addPokemonToList(textController.text)
            ),
            CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Cerrar'),
                onPressed: ()=>Navigator.pop(context)
            ),
          ],
        )
    );

  }

  void addPokemonToList(String name){
    if(name.length>1){
      //agregar pokemon nuevo al server
      final socketService=Provider.of<SocketService>(context,listen: false);
      
      socketService.socket.emit('add-pokemon',{'name':name});
    }
    Navigator.pop(context);
  }

  //mostrar grafica
  Widget _showPieData(){

    Map<String,double> dataMap={};

    listPokemon.forEach((pokemon) {
      dataMap.putIfAbsent(pokemon.name, () => pokemon.votes.toDouble());
    });

    final List<Color> colorList=[
      Colors.blue,
      Colors.pink,
      Colors.purple,
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.grey,
      Colors.cyanAccent,
      Colors.orange,
      Colors.teal,
    ];

    return Container(
      padding: EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 200,
      child: (dataMap.isNotEmpty) ? PieChart(
        dataMap: dataMap,
        colorList: colorList,
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: false,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
        ),
        chartType: ChartType.ring,
      ) : Text('EMPTY')
    );
  }

}