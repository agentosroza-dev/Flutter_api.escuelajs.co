import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';

class SearchProductLogic extends ChangeNotifier {
  List<Product> _searchedProducts = [];
  List<Product> get searchedProducts => _searchedProducts;

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

  Future searchProductTitlePagination({
    required String title,
    bool refresh = false,
  }) async {
    if (refresh) {
      _page = 0;
      _searchedProducts = [];
    }

    List<Product> newlist;

    if (_catId == '-1') {
      //all
      newlist = await _service.searchProductsByTitleAndCategoryId(title: title);
    } else {
      newlist = await _service.searchProductsByTitleAndCategoryId(
        title: title,
        cid: _catId,
        page: _page,
      );
    }

    if (newlist.isNotEmpty) {
      _searchedProducts += newlist;
      _page++;
      _hasMoreRecords = true;
    } else {
      _hasMoreRecords = false;
    }
    _loading = false;
    notifyListeners();
  }
}
