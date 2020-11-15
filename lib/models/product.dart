import 'dart:io';

class Product {
  String name;
  File image;
  String observations;
  double price;
  bool state;
  int quantity;

  Product(this.name, this.price, this.quantity,
      {this.observations = "", this.image, this.state = false});

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  void changeState() {
    state = !state;
  }

  double get totalPrice => double.parse((price * quantity).toStringAsFixed(2));

  @override
  String toString() {
    return "$name | $price | $quantity | $observations";
  }
}
