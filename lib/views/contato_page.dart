import 'dart:io';

import 'package:flutter/material.dart';

import '../model/Contato.dart';

class PaginaContato extends StatefulWidget {
  final Contato contato;

  PaginaContato({this.contato});

  @override
  _PaginaContatoState createState() => _PaginaContatoState();
}

class _PaginaContatoState extends State<PaginaContato> {

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  bool _editandoContato = false;

  Contato _contatoEditado;

  @override
  void initState() {
    super.initState();
    if (widget.contato == null) {
      _contatoEditado = Contato();
    } else {
      _contatoEditado = Contato.fromMap(widget.contato.toMap());

      _nomeController.text = _contatoEditado.nome;
      _emailController.text = _contatoEditado.email;
      _telefoneController.text = _contatoEditado.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF52514e),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _contatoEditado.img != null
                            ? FileImage(File(_contatoEditado.img))
                            : AssetImage("assets/user.png"))),
              ),
            ),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: "Nome", labelStyle: TextStyle(color: Colors.white)),
              onChanged: (texto) {
                _editandoContato = true;
                setState(() {
                  _contatoEditado.nome = texto;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email", 
                labelStyle: TextStyle(color: Colors.white),
                ),
              onChanged: (texto) {
                _editandoContato = true;
                _contatoEditado.email = texto;
              },
              keyboardType: TextInputType.emailAddress,
              
            ),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: "Telefone", labelStyle: TextStyle(color: Colors.white)),
              onChanged: (texto) {
                _editandoContato = true;
                _contatoEditado.telefone = texto;
              },
              keyboardType: TextInputType.phone
            ),
          ],
        ),
      ),
    );
  }
}
