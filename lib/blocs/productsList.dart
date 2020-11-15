import 'dart:async';
import 'package:franciscomadruga21705328/data/datasource.dart';
import 'package:franciscomadruga21705328/models/product.dart';

class ProductsList {
  final DataSource _dataSource = DataSource.getInstance();

  StreamController _controller = StreamController();

  Sink get _input => _controller.sink;

  Stream get output => _controller.stream;

  void dispose() => _controller.close();

  void addProduct(Product product) {
    _dataSource.insert(product);
    _input.add(_dataSource);
  }

  void incrementProductQuantity(int index) {
    _dataSource.get(index).incrementQuantity();
    _input.add(_dataSource);
  }

  void decrementProductQuantity(int index) {
    _dataSource.get(index).decrementQuantity();
    _input.add(_dataSource);
  }

  double totalPrice() {
    double total = 0;
    _dataSource.getAll().forEach((product) {
      total += product.totalPrice;
    });
    return double.parse(total.toStringAsFixed(2));
  }

  int totalQuantity() {
    int total = 0;
    _dataSource.getAll().forEach((product) {
      total += product.quantity;
    });
    return total;
  }

  void changeProductState(int index) {
    _dataSource.get(index).changeState();
  }

  int biggestQuantityString() {
    int result = 0;
    for (Product product in _dataSource.getAll()) {
      if (product.quantity.toString().length >= result) {
        result = product.quantity.toString().length;
      }
    }
    return result;
  }

  Product get(int index) {
    return _dataSource.get(index);
  }

  void update(int index, Product product) {
    _dataSource.update(index, product);
    _input.add(_dataSource);
  }

  void clear() {
    _dataSource.clear();
    _input.add(_dataSource);
  }
}
