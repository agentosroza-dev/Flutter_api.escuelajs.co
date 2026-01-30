import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryLogic extends ChangeNotifier {
  List<Cat> _cats = [];
  List<Cat> get cats => _cats;

  bool _loading = false;
  bool get loading => _loading;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  final _service = CategoryService();

  Future read() async {
    _cats = await _service.getCategories();
    Cat catAll = Cat(
      id: "-1",
      name: "All",
      slug: "all",
      image: "",
      creationAt: "",
      updatedAt: "",
    );
    _cats.insert(0, catAll);

    _loading = false;
    notifyListeners();
  }
}
