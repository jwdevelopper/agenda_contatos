import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/contato.dart';

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

  final _nomeFocus = FocusNode();

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
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: Color(0xFF52514e),
        appBar: AppBar(
          backgroundColor: Color(0xFFa11bb5),
          title: Text(_contatoEditado.nome ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_contatoEditado.nome != null &&
                _contatoEditado.nome.isNotEmpty) {
              Navigator.pop(context, _contatoEditado);
            } else {
              FocusScope.of(context).requestFocus(_nomeFocus);
            }
          },
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
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file==null){
                      return;
                    } 
                    setState(() {
                      _contatoEditado.img = file.path;
                    }); 
                  });
                },
              ),
              TextField(
                controller: _nomeController,
                focusNode: _nomeFocus,
                decoration: InputDecoration(
                    labelText: "Nome",
                    labelStyle: TextStyle(color: Colors.white)),
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
                  decoration: InputDecoration(
                      labelText: "Telefone",
                      labelStyle: TextStyle(color: Colors.white)),
                  onChanged: (texto) {
                    _editandoContato = true;
                    _contatoEditado.telefone = texto;
                  },
                  keyboardType: TextInputType.phone),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if(_editandoContato){
      showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Descartar Alterações"),
            content: Text("Caso saia as alterações serão perdidas"),
            actions: [
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Sim"),
              ),
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
