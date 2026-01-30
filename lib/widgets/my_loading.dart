import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget MyLoading(
  BuildContext context, {
  int itemCount = 10,
  int crossAxisCount = 2,
  double childAspectRatio = 3 / 4,
}) {
  return Skeletonizer(
    child: GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text("sadsadasdasdsadsadasdasdasdas"),
            subtitle: Text(
              "sadsadasdasdsad sasadsadasdasdsadsada sdasdasd asdasdasdasdas",
            ),
          ),
        );
      },
    ),
  );
}
