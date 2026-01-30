import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget MySimpleCard(BuildContext context, String imageUrl, String title) {
  return Card(
    child: Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                width: double.maxFinite,
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(color: Colors.grey),
                errorWidget: (_, _, _) =>
                    Container(color: Colors.grey.shade300),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
