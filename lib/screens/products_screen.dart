import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/providers/firebase_provider.dart';
import 'package:firebase/views/card_product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ListProducts extends StatefulWidget {
  ListProducts({Key? key}) : super(key: key);

  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  late FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseProvider = FirebaseProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/new').whenComplete(() {
                  setState(() {});
                });
              },
              icon: Icon(Icons.new_label))
        ],
      ),
      body: StreamBuilder(
        stream: _firebaseProvider.getAllProducts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                return CardProduct(productDocument: document);
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
