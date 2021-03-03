import 'package:flutter/material.dart';

import '../model/Contato.dart';

class PaginaContato extends StatefulWidget {

  final Contato contato;

  PaginaContato({this.contato});

  @override
  _PaginaContatoState createState() => _PaginaContatoState();
}

class _PaginaContatoState extends State<PaginaContato> {

  Contato _contatoEditado;

  @override
  void initState() {
    super.initState();
    if(widget.contato == null) {
      _contatoEditado = Contato();
    } else {
      _contatoEditado = Contato.fromMap(widget.contato.toMap());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFa11bb5),
        title: Text(_contatoEditado.nome ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save),
        backgroundColor: Color(0xFFa11bb5),
      ),
    );
  }
}