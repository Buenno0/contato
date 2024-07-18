import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:contato/model/contato_model.dart';
import 'package:contato/view/contato_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContatoModel model = ContatoModel();
  
  List<Contato> contatos = [];

  @override
  void initState() {
    // TODO: implement initState
   /* Contato c1 = Contato();
    c1.nome = "Fulano";
    c1.email = "fulano@gmail.com";
    c1.fone = "15826282";
    c1.img = "caminho/img";

    model.saveContato(c1);
    
    model.getAllContatos().then((value) => print(value)); */
    super.initState();

    _getAllContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contatos"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(45, 8, 119, 112),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContatoPage();
        },
        backgroundColor: Color.fromARGB(45, 8, 119, 112),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: contatos.length,
        itemBuilder: (context, index) {
         return _contatoCard(context, index);
       },
      ),
    );
  }
  Widget _contatoCard(context, index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: contatos[index].img != null
                    ? FileImage(File(contatos[index].img!))
                    : const AssetImage("images/person.png") as ImageProvider,
                )
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Text(
                      contatos[index].nome ?? "",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      contatos[index].email ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      contatos[index].fone ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                
                  ],
                ),
              )
            ],
          ),
          ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );   
  }
  void _showContatoPage({Contato? contato}) async {
    final recContato = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => ContatoPage(contato: contato,)
    ));

    if(recContato != null){
      if(contato != null){
        await model.updateContato(recContato);
      }else{
        await model.saveContato(recContato);
      }
    }
  }

  void _getAllContatos() {
    model.getAllContatos().then((list) {
      setState(() {
        contatos = list;
      });
    });
  }

  void _showOptions(BuildContext context, index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      launch("tel:${contatos[index].fone}");
                      Navigator.pop(context);
                    },
                    child: const Text("Ligar",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      )
                    )
                  ),
                  TextButton(
                    onPressed: () {
                        Navigator.pop(context);
                        _showContatoPage(contato: contatos[index]);
                      },
                    child: const Text("Editar",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Deseja excluir este contato?"),
                            content: const Text("Esta ação não poderá ser desfeita."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () {
                                  model.deleteContato(contatos[index].id);
                                  setState(() {
                                    contatos.removeAt(index);
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Excluir",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}