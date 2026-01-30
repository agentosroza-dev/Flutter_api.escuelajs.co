import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class SearchProductLogic extends ChangeNotifier {
  List<Product> _searchedProducts = [];
  List<Product> get searchedProducts => _searchedProducts;

  List<Category> _filteredCats = [];
  List<Category> get filteredCats => _filteredCats;

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

  Future getCategoriesByTitleSearched({required String title}) async {
    List<Product> list = await _service.searchProductsByTitleAndCategoryId(
      title: title,
    );
    _filteredCats = list.map((x) => x.category).toSet().toList();
    Category catAll = Category(id: "-1", name: "All", slug: "all", image: "", creationAt: "", updatedAt: "");
    _filteredCats.insert(0, catAll);
    notifyListeners();
  }

  Future searchProductTitlePagination({
    required String title,
    bool refresh = false,
    int limit = 20,
  }) async {
    if (refresh) {
      _page = 0;
      _searchedProducts = [];
    }

    List<Product> newlist;

    if (_catId == '-1') {
      //all
      newlist = await _service.searchProductsByTitleAndCategoryId(
        title: title,
        limit: limit,
      );
    } else {
      newlist = await _service.searchProductsByTitleAndCategoryId(
        title: title,
        cid: _catId,
        page: _page,
        limit: limit,
      );
    }
    _searchedProducts += newlist;
    _page++;

    _hasMoreRecords = newlist.length == limit;

    _loading = false;
    notifyListeners();
  }
}
