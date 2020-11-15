import 'package:franciscomadruga21705328/models/product.dart';

class DataSource {

  final _datasource = [];
  static DataSource _instance;

  DataSource._internal();

  static DataSource getInstance() {
    if (_instance == null) {
      _instance = DataSource._internal();
    }
    return _instance;
  }

  void insert(operation) => _datasource.add(operation);

  Product get(index) => _datasource[index];

  void clear() => _datasource.clear();

  void remove(index) => _datasource.removeAt(index);

  void update(int index, Product product) {
    _datasource[index] = product;
  }

  List getAll() => _datasource;
}