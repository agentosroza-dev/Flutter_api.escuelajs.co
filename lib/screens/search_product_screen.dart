import 'package:flutter/material.dart';
import 'package:my_platzi/logics/category_logic.dart';
import 'package:my_platzi/widgets/my_loud_more.dart';
import '../logics/search_product_logic.dart';
import '../models/category_model.dart';
import '../widgets/my_simple_card.dart';
import '../widgets/my_loading.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final _scroller = ScrollController();
  bool _showUpIcon = false;

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
        context.read<SearchProductLogic>().searchProductTitlePagination(
          title: _searchedText,
        );
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

  bool _isGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
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

  String _searchedText = "";

  final _searchCtrl = TextEditingController();

  Widget _buildSearchBar() {
    return SearchBar(
      controller: _searchCtrl,
      hintText: "Search...",
      leading: Icon(Icons.search),
      trailing: [
        IconButton(
          onPressed: () {
            _searchCtrl.clear();
            _searchedText = "";
          },
          icon: Icon(Icons.cancel_outlined),
        ),
      ],
      textInputAction: TextInputAction.search,
      onSubmitted: (String text) {
        _searchedText = text;
        context.read<SearchProductLogic>().setLoading();
        context.read<SearchProductLogic>().searchProductTitlePagination(
          title: text.trim(),
          refresh: true,
        );
      },
    );
  }

  Widget _buildBody() {
    //remove this code
    return _buildListView();
    // return SizedBox();
  }

  String _selectedId = "-1";

  Widget _buildListView() {
    bool hasMoreRecords = context.read<SearchProductLogic>().hasMoreRecords;
    _selectedId = context.watch<SearchProductLogic>().catId;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<SearchProductLogic>().resetCatId();
        context.read<SearchProductLogic>().setLoading();
        context.read<CategoryLogic>().read();
        context.read<SearchProductLogic>().searchProductTitlePagination(
          title: _searchedText,
          refresh: true,
        );
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
              onPressed: _selectedId == item.id
                  ? null
                  : () {
                      debugPrint("item.id: ${item.id}");
                      context.read<SearchProductLogic>().setCatId(item.id);
                      context.read<SearchProductLogic>().setLoading();
                      context
                          .read<SearchProductLogic>()
                          .searchProductTitlePagination(
                            title: _searchedText,
                            refresh: true,
                          );
                    },
              child: Text(item.name),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGridView() {
    bool loading = context.watch<SearchProductLogic>().loading;
    List<Product> items = context.watch<SearchProductLogic>().searchedProducts;
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
          return MySimpleCard(context, item.images[0], item.title);
        },
      );
    }
  }
}
