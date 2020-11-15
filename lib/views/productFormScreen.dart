import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:franciscomadruga21705328/models/product.dart';
import 'package:franciscomadruga21705328/utils/decimalTextInputFormatter.dart';
import 'package:franciscomadruga21705328/blocs/productsList.dart';

class ProductFormScreen extends StatefulWidget {
  ProductFormScreen({Key key, this.title, this.index}) : super(key: key);

  final String title;
  final int index;

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final products = ProductsList();

  final _formKey = GlobalKey<FormState>();

  Product _product;
  bool _enable;

  @override
  void initState() {
    super.initState();
    _product = widget.index == null
        ? Product("", 0, 0)
        : Product(
            products.get(widget.index).name,
            products.get(widget.index).price,
            products.get(widget.index).quantity,
            observations: products.get(widget.index).observations,
            image: products.get(widget.index).image);
    _enable = widget.index == null;
  }

  Future _getImage() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _product.image = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(50),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: _enable ? _getImage : null,
                      child: Center(
                        child: _product.image == null
                            ? CircleAvatar(
                                child: _enable
                                    ? Icon(Icons.add)
                                    : Text(
                                        _product.name[0],
                                        style: TextStyle(fontSize: 35),
                                      ),
                                radius: MediaQuery.of(context).size.width / 7,
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(_product.image),
                                radius: MediaQuery.of(context).size.width / 7,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          enabled: _enable,
                          initialValue: _product.name,
                          decoration: InputDecoration(
                            labelText: "Product Name",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "This field is required";
                            }
                            _product.name = value;
                            return null;
                          },
                        ),
                      )
                    ],
                  )),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            enabled: _enable,
                            initialValue: _product.price == 0
                                ? ""
                                : _product.price.toString(),
                            decoration: InputDecoration(
                                labelText: "Unit Price",
                                border: OutlineInputBorder(),
                                hintText: "0.0"),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              DecimalTextInputFormatter(
                                  decimalRange: 2,
                                  activatedNegativeValues: false)
                            ],
                            onChanged: (text) {
                              setState(() {
                                if (text == "" || text == null) {
                                  _product.price = 0;
                                } else {
                                  _product.price = double.parse(text);
                                }
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              _product.price = double.parse(
                                value,
                              );
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                        ),
                        Expanded(
                          child: TextFormField(
                            enabled: _enable,
                            initialValue: _product.quantity == 0
                                ? ""
                                : _product.quantity.toString(),
                            decoration: InputDecoration(
                              labelText: "Quantity",
                              border: OutlineInputBorder(),
                              hintText: "0",
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            onChanged: (text) {
                              setState(() {
                                if (text == "" || text == null) {
                                  _product.quantity = 0;
                                } else {
                                  _product.quantity = int.parse(text);
                                }
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              _product.quantity = int.parse(value);
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          enabled: _enable,
                          initialValue: _product.observations,
                          decoration: InputDecoration(
                            labelText: "Observations (optional)",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null) {
                              _product.observations = "";
                            } else {
                              _product.observations = value;
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ))
                ],
              ),
            )),
        floatingActionButton: FloatingActionButton(
          tooltip: _enable
              ? widget.index == null ? "Add product" : "Update product"
              : "Edit product",
          onPressed: () {
            if (_enable) {
              if (_formKey.currentState.validate()) {
                if (widget.index == null) {
                  products.addProduct(_product);
                } else {
                  products.update(widget.index, _product);
                }
                Navigator.pop(context);
              }
            } else {
              setState(() {
                _enable = true;
              });
            }
          },
          child: _enable ? Icon(Icons.check) : Icon(Icons.edit),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.red,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  "Total price: ",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
                Expanded(
                    child: Text(
                  "${_product.totalPrice}€",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    products.dispose();
    super.dispose();
  }
}
