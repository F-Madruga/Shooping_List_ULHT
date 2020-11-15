import 'package:flutter/material.dart';
import 'package:franciscomadruga21705328/views/productFormScreen.dart';
import 'package:shake/shake.dart';
import 'package:franciscomadruga21705328/blocs/productsList.dart';
import 'package:franciscomadruga21705328/models/product.dart';

class ProductListScreen extends StatefulWidget {
  ProductListScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final products = ProductsList();
  bool canShake = true;

  @override
  void initState() {
    super.initState();
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        if (products.totalQuantity() != 0 && canShake) {
          print(canShake);
          canShake = false;
          showClearPopUp();
        }
      });
    });
    products.addProduct(Product(
      "Leite",
      1.00,
      3,
    ));
    products.addProduct(Product(
      "Ovos",
      0.20,
      12,
    ));
    products.addProduct(Product(
      "Bolachas",
      1.50,
      1,
    ));
    products.addProduct(Product(
      "Maçãs",
      0.50,
      5,
    ));
  }

  void showClearPopUp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Attencion!"),
            content: Text("Do you wish to remove all products?"),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      setState(() {
                        products.clear();
                        canShake = true;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("No"),
                    onPressed: () {
                      setState(() {
                        canShake = true;
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          );
        },
        barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder(
          initialData: [],
          stream: products.output,
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.getAll().length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      String message = "";
                      if (direction == DismissDirection.startToEnd) {
                        //Right
                        message =
                            "${snapshot.data.get(index).name} was removed";
                        snapshot.data.remove(index);
                      } else {
                        //Left
                        snapshot.data.get(index).changeState();
                        message = snapshot.data.get(index).state
                            ? "${snapshot.data.get(index).name} was checked"
                            : "${snapshot.data.get(index).name} was unchecked";
                      }
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(message),
                      ));
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductFormScreen(
                                        title: "Product",
                                        index: index,
                                      )));
                        },
                        child: Card(
                            color: snapshot.data.get(index).state
                                ? Colors.green
                                : Colors.white,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: snapshot.data
                                                    .get(index)
                                                    .image ==
                                                null
                                            ? null
                                            : FileImage(
                                                snapshot.data.get(index).image),
                                        child: Text(snapshot.data
                                                    .get(index)
                                                    .image ==
                                                null
                                            ? snapshot.data.get(index).name[0]
                                            : ""),
                                      ),
                                      title: Text(
                                        snapshot.data.get(index).name,
                                      ),
                                      subtitle: Text(
                                        "${snapshot.data.get(index).price}€",
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${snapshot.data.get(index).totalPrice}€",
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                      child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: RaisedButton(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          ),
                                          shape: CircleBorder(),
                                          color: Colors.lightGreen,
                                          onPressed: () {
                                            setState(() {
                                              products.decrementProductQuantity(
                                                  index);
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          snapshot.data
                                              .get(index)
                                              .quantity
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      Expanded(
                                        child: RaisedButton(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          shape: CircleBorder(),
                                          color: Colors.lightGreen,
                                          onPressed: () {
                                            setState(() {
                                              products.incrementProductQuantity(
                                                  index);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            )),
                      ),
                      Container(
                        child: index == snapshot.data.getAll().length - 1
                            ? Padding(
                                padding: EdgeInsets.all(30),
                                child: ListTile(),
                              )
                            : null,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductFormScreen(title: "Product")));
          },
          tooltip: 'Add Product',
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.red,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  "Total Products: \nTotal Price: ",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
                Expanded(
                    child: Text(
                  "${products.totalQuantity()}\n${products.totalPrice()}€",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ))
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    products.dispose();
    super.dispose();
  }
}
