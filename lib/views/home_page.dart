import 'package:agenda_contatos/helpers/contato_helper.dart';
import 'package:agenda_contatos/model/contato.dart';
import 'package:flutter/material.dart';

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
      contatoHelper.getContatos().then((list) {
        setState(() {
          contatos = list;          
                });
        
      });
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
      ),
      backgroundColor: Color(0xFF333033),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Color(0XFF7a018c)
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contatos.length,
          itemBuilder: (context, index) {

          },
        ),
    );
  }

  Widget _cardContato(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
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
                    image: 
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



