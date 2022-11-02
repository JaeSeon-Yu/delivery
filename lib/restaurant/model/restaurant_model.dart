import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant_model.freezed.dart';
part 'restaurant_model.g.dart';

enum RestaurantPrice{
  expensive, medium, cheap
}

@freezed
class RestaurantModel with _$RestaurantModel {
  factory RestaurantModel({
  required final String id,
  required final String name,
  required final String thumbUrl,
  required final List<String> tags,
  required final RestaurantPrice priceRange,
  required final double ratings,
  required final int ratingsCount,
  required final int deliveryTime,
  required final int deliveryFee,
  }) = _RestaurantModel;

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => _$RestaurantModelFromJson(json);
}