import 'package:actual/common/const/data.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/model/restaurant_model2.dart';

class RestaurantDetailModel extends RestaurantModel2 {
  final String detail;
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required this.detail,
    required this.products,
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
  });

  factory RestaurantDetailModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return RestaurantDetailModel(
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
      detail: json['detail'],
      products: json['products'].map<RestaurantProductModel>(
        (x) => RestaurantProductModel(
          id: x['id'],
          name: x['name'],
          imgUrl: x['imgUrl'],
          detail: x['detail'],
          price: x['price'],
        ),
      ).toList(),
    );
  }
}

class RestaurantProductModel {
  final String id;
  final String name;
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });
}
