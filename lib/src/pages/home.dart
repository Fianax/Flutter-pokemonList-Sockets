import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_intermedios_udemy/src/models/pokemon.dart';

class HomePage extends StatefulWidget{

  @override
  HomePageState createState()=> HomePageState();
}

class HomePageState extends State<HomePage>{

  List<Pokemon> pokemon=[
    Pokemon(id: '1', name: 'Pikachu', votes: 5),
    Pokemon(id: '2', name: 'Arceus', votes: 6),
    Pokemon(id: '3', name: 'Dialga', votes: 8),
    Pokemon(id: '4', name: 'Ho-oh', votes: 10),
    Pokemon(id: '5', name: 'Lugia', votes: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PokemonNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: pokemon.length,
        itemBuilder: (context, index)=>_pokemonTile(pokemon[index]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }
  
  Widget _pokemonTile(Pokemon pokemon){
    return Dismissible(
      key: Key(pokemon.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        print('direccion: $direction');
        print('id: ${pokemon.id}');
        //borrar en el server
      },
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
        onTap: (){
          print(pokemon.name);
        },
      ),
    );
  }

  addNewBand(){

    final textController=TextEditingController();

    if(Platform.isAndroid){
      return showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
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
            );
          }
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_){
        return CupertinoAlertDialog(
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
        );
      }
    );

  }

  void addPokemonToList(String name){
    if(name.length>1){
      //agregar pokemon nuevo
      this.pokemon.add(Pokemon(id: DateTime.now().toString(),name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }

}