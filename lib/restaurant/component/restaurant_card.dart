import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image;
  final String name;
  final List<String> tags;
  final int ratingCount;
  final int deliveryTime;
  final int deliveryFee;
  final double rating;

  const RestaurantCard(
      {Key? key,
      required this.image,
      required this.name,
      required this.tags,
      required this.ratingCount,
      required this.deliveryTime,
      required this.deliveryFee,
      required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          child: image,
          borderRadius: BorderRadius.circular(12),
        ),
        SizedBox(
          height: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              tags.join(' | '),
            )
          ],
        ),
      ],
    );
  }
}
