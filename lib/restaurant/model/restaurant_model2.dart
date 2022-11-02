import 'package:actual/common/const/data.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:flutter/cupertino.dart';

class RestaurantModel2 {
  final String id;
  final String name;
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPrice priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel2({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantModel2.fromJson({
    required Map<String, dynamic> json,
  }) {
    return RestaurantModel2(
      id: json['id'],
      name: json['name'],
      thumbUrl: '$ip${json['thumbUrl']}',
      tags: List<String>.from(json['tags']),
      priceRange: RestaurantPrice.values.firstWhere(
        (element) => element.name == json['priceRange'],
      ),
      ratings: json['ratings'],
      ratingsCount: json['ratingsCount'],
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'],
    );
  }
}
