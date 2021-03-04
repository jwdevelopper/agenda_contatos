import 'dart:io';

import 'package:agenda_contatos/helpers/contato_helper.dart';
import 'package:agenda_contatos/model/contato.dart';
import 'package:agenda_contatos/views/contato_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContatoHelper contatoHelper = ContatoHelper();
  List<Contato> contatos = List();

  @override
  void initState() {
    super.initState();
    _getAllContatos();
    /*Contato contato = Contato();
      contato.nome = 'José Wilson Junior';
      contato.telefone = '44 9 98129931';
      contato.email = 'jwjuniorsi@gmail.com';
      contato.img = 'imagemdeteste';

      contatoHelper.salvarContato(contato);
      contatoHelper.getContatos().then((list) {
print(list);
      });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Color(0XFF7a018c),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Color(0xFF333033),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showPaginaContato();
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0XFF7a018c)),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          return _cardContato(context, index);
        },
      ),
    );
  }

  Widget _cardContato(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: contatos[index].img != null
                            ? FileImage(File(contatos[index].img))
                            : AssetImage("assets/user.png"))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contatos[index].nome ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold)),
                    Text(contatos[index].email ?? "",
                        style: TextStyle(color: Colors.white, fontSize: 18.0)),
                    Text(contatos[index].telefone ?? "",
                        style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOpcoes(context, index);
      },
    );
  }

  void _showPaginaContato({Contato contato}) async {
    final recContato = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaginaContato(contato: contato)));
    if (recContato != null) {
      if (contato != null) {
        await contatoHelper.updateContato(recContato);
      } else {
        await contatoHelper.salvarContato(recContato);
      }
      _getAllContatos();
    }
  }

  void _getAllContatos() async {
    await contatoHelper.getContatos().then((list) {
      setState(() {
        contatos = list;
      });
    });
  }

  void _showOpcoes(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            backgroundColor: Color(0xFF52514e),
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text(
                            "Ligar",
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          onPressed: () {
                            launch("tel:${contatos[index].telefone}");
                            Navigator.pop(context);
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text(
                            "Editar",
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showPaginaContato(contato: contatos[index]);
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text(
                            "Excluir",
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          onPressed: () {
                            contatoHelper.deletarContato(contatos[index].id);
                            setState(() {
                              contatos.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                        )),
                  ],
                ),
              );
            },
          );
        });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contatos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contatos.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
