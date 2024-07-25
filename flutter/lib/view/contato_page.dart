import 'dart:io';
import 'dart:math';

import 'package:contato/model/contato_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContatoPage extends StatefulWidget {
  const ContatoPage({super.key, this.contato});
    final Contato? contato;

  @override
  State<ContatoPage> createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {

final _nomeController = TextEditingController();
final _emailController = TextEditingController();
final _foneController = TextEditingController();
final ImagePicker _imagePicker = ImagePicker();
final _nomeFocus = FocusNode();


late Contato _editedContato;
bool _userEdited = false;

@override
  void initState() {
    
    super.initState();
    if(widget.contato == null){
      _editedContato = Contato();
  }else{
    _editedContato = Contato.fromMap(widget.contato!.toMap());
    _nomeController.text = _editedContato.nome!;
    _emailController.text = _editedContato.email!;
    _foneController.text = _editedContato.fone!;
  }
}

  @override
  Widget build(BuildContext context) {
   
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContato.nome ?? "Novo Contato"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(45, 8, 119, 112),
      
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(_editedContato.nome != null && _editedContato.nome!.isNotEmpty){
              Navigator.pop(context, _editedContato);
            }else{
              FocusScope.of(context).requestFocus(_nomeFocus);
              showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: const Text("Nome inválido"),
                    content: const Text("Informe um nome para o contato"),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text("Ok"),
                      )
                    ],
                  );
                }
              );
            }
          },
          backgroundColor: Color.fromARGB(45, 8, 119, 112),
          child: const Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                 _imagePicker.pickImage(source: ImageSource.camera).then((file) {
                    if(file == null) return;
                    setState(() {
                      _editedContato.img = file.path;
                    });
                  });
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContato.img != null ?
                      FileImage(File(_editedContato.img!)) :
                      const AssetImage("images/person.png") as ImageProvider,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _nomeController,
                focusNode: _nomeFocus,
                decoration: const InputDecoration(labelText: "Nome"),
                onChanged: (value){
                  _userEdited = true;
                  setState(() {
                    _editedContato.nome = value;
                  });
                },
              ),
                      
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (value){
                  _userEdited = true;
                  setState(() {
                    _editedContato.email = value;
                  });
                },
              ),
              TextField(
                controller: _foneController,
                decoration: const InputDecoration(labelText: "Fone"),
                onChanged: (value){
                  _userEdited = true;
                  setState(() {
                    _editedContato.fone = value;
                  });
                },
              ),
            ],
          ),
        )
      ),
    );
  }

 Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Descartar alterações?"),
            content: const Text("Se sair as alterações serão perdidas"),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Sim"),
              ),
            ],
          );
        }
      );
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }
}