import 'dart:convert';
import 'dart:io';

import 'package:firebase/models/porduct_dao.dart';
import 'package:firebase/providers/firebase_provider.dart';
import 'package:firebase/services/storage_service.dart';
import 'package:firebase/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class newProduct extends StatefulWidget {
  newProduct({Key? key}) : super(key: key);

  @override
  _newProductState createState() => _newProductState();
}

class _newProductState extends State<newProduct> {
  late FirebaseProvider _firebaseProvider;
  late Storage _firebaseStorage;
  TextEditingController _controllerNombre = TextEditingController();
  TextEditingController _controllerDescripcion = TextEditingController();
  bool _validateNombre = false;
  bool _validateDescripcion = false;
  File? _selectedPicture;
  String? _url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseProvider = FirebaseProvider();
    _firebaseStorage = Storage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo producto'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 2),
            () {
              setState(() {});
            },
          );
        },
        child: ListView.builder(
          itemBuilder: (BuildContext context, index) {
            return Container(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                //key: _formKeys[_formKeys.length - 1],
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                      width: 150,
                      child: _selectedPicture != null
                          ? Image.file(_selectedPicture!)
                          : Text('No selecciono una foto'),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              var image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              setState(
                                () {
                                  _selectedPicture = File(image!.path);
                                },
                              );
                            },
                            child: Text('Selecciona foto'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    _crearTextFieldNombre(),
                    SizedBox(height: 25),
                    _crearTextFieldDescripcion(),
                    SizedBox(height: 40),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        child: Text('Guardar'),
                        onPressed: () {
                          setState(() {
                            _controllerNombre.text.isEmpty
                                ? _validateNombre = true
                                : _validateNombre = false;
                            _controllerDescripcion.text.isEmpty
                                ? _validateDescripcion = true
                                : _validateDescripcion = false;

                            if (_validateNombre == false &&
                                _validateDescripcion == false &&
                                _selectedPicture != null) {
                              ProductDAO? product;

                              _firebaseStorage
                                  .uploadFile(_selectedPicture!)
                                  .then((value) {
                                product = ProductDAO(
                                    cveprod: _controllerNombre.text,
                                    descprod: _controllerDescripcion.text,
                                    imgprod: value);

                                _firebaseProvider
                                    .saveProduct(product!)
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Subelo sin miedo')));
                                  Navigator.pop(context);
                                });
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('La solicitud no se completo'),
                                ),
                              );
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: 1,
        ),
      ),
    );
  }

  Widget _crearTextFieldNombre() {
    return TextField(
      autocorrect: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: "Nombre del Porducto",
          errorText: _validateNombre ? 'Este campo es obligatorio' : null),
      controller: _controllerNombre,
    );
  }

  Widget _crearTextFieldDescripcion() {
    return TextField(
      autocorrect: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: "Descripción del Producto",
          errorText: _validateDescripcion ? 'Este campo es obligatorio' : null),
      controller: _controllerDescripcion,
    );
  }
}
