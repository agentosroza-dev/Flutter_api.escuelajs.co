import 'package:flutter/material.dart';
import 'package:my_platzi/widgets/my_3line_card.dart';
import 'package:provider/provider.dart';
import '../logics/category_logic.dart';
import '../widgets/my_loud_more.dart';
import '../models/category_model.dart';
import '../logics/product_logic.dart';
import '../widgets/my_loading.dart';


import '../models/product_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _scroller = ScrollController();
  bool _showUpIcon = false;
  bool _isGrid = false;

  @override
  void initState() {
    super.initState();
    _scroller.addListener(() {
      if (_scroller.position.pixels > 500) {
        setState(() {
          _showUpIcon = true;
        });
      } else {
        setState(() {
          _showUpIcon = false;
        });
      }

      if (_scroller.position.pixels == _scroller.position.maxScrollExtent) {
        debugPrint("reached bottom");
        context.read<ProductLogic>().readProductPagination();
      }
    });
  }

  Widget _buildFloating() {
    return FloatingActionButton(
      onPressed: () {
        _scroller.animateTo(
          0,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      child: Icon(Icons.arrow_upward),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final logo =
    //     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNRHMRbBL8BAcMYo3mmhwF-yp9Qku7B6v0hQ&s";
    return Scaffold(
      appBar: AppBar(
        title: Text("TEN11"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
            icon: Icon(_isGrid ? Icons.grid_on : Icons.list),
          ),
        ],
      ),

      body: _buildBody(),
      floatingActionButton: _showUpIcon ? _buildFloating() : null,
    );
  }

  Widget _buildBody() {
    //remove this code
    return _buildListView();
  }

  String _selectedId = "-1";

  Widget _buildListView() {
    bool hasMoreRecords = context.read<ProductLogic>().hasMoreRecords;
    _selectedId = context.watch<ProductLogic>().catId;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductLogic>().resetCatId();
        context.read<ProductLogic>().setLoading();
        context.read<CategoryLogic>().read();
        context.read<ProductLogic>().readProductPagination(refresh: true);
      },
      child: ListView(
        controller: _scroller,
        physics: BouncingScrollPhysics(),
        children: [
          _buildCategoryList(),
          _buildProductGridView(),
          hasMoreRecords ? MyLoadMore(context) : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    List<Cat> items = context.watch<CategoryLogic>().cats;

    return SizedBox(
      height: kMinInteractiveDimension, // = 48.0
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: _selectedId == item.id ? 0 : 1,
              ),
              onPressed: _selectedId == item.id
                  ? null
                  : () {
                      debugPrint("item.id: ${item.id}");
                      context.read<ProductLogic>().setCatId(item.id);
                      context.read<ProductLogic>().setLoading();
                      context.read<ProductLogic>().readProductPagination(
                        refresh: true,
                      );
                    },

              child: Text("${item.id}, ${item.name}"),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGridView() {
    bool loading = context.watch<ProductLogic>().loading;
    List<Product> items = context.watch<ProductLogic>().products;
    debugPrint("loading = $loading");

    SliverGridDelegate delegate;
    Widget loadingWidget;
    if (_isGrid) {
      delegate = SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
      );
      loadingWidget = MyLoading(context);
    } else {
      delegate = SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 3,
      );
      loadingWidget = MyLoading(
        context,
        crossAxisCount: 1,
        childAspectRatio: 3 / 3,
      );
    }

    if (loading) {
      return loadingWidget;
    } else {
      return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        cacheExtent: 500,
        gridDelegate: delegate,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
                   return My3LineCard(context, item.images[0], item.title, item.category.name, "USD \$${item.price}");
        },
      );
    }
  }
}
