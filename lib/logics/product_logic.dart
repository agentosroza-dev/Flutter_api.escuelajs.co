import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductLogic extends ChangeNotifier {
  final logger = Logger();
  List<Product> _products = [];
  List<Product> get products => _products;

  bool _loading = false;
  bool get loading => _loading;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  bool _hasMoreRecords = false;
  bool get hasMoreRecords => _hasMoreRecords;

  final _service = ProductService();

  int _page = 0;

  String _catId = "-1";
  String get catId => _catId;

  void setCatId(String value) {
    _catId = value;
    notifyListeners();
  }

  void resetCatId() {
    _catId = "-1";
    notifyListeners();
  }

  Future readProductPagination({bool refresh = false}) async {
    if (refresh) {
      _page = 0;
      _products = [];
    }

    List<Product> newlist;

    if (_catId == '-1') {
      //all
      newlist = await _service.getProducts(page: _page);
    } else {
      newlist = await _service.filterProductsByCategoryId(
        cid: _catId,
        page: _page,
      );
    }

    if (newlist.isNotEmpty) {
      _products += newlist;
      _page++;
      _hasMoreRecords = true;
    } else {
      _hasMoreRecords = false;
    }
    _loading = false;

    logger.d(_products);
    logger.i(_page);
    notifyListeners();
  }
}
