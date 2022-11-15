import 'package:json_annotation/json_annotation.dart';

part 'patch_basket_body_model.g.dart';


@JsonSerializable()
class PatchBasketBodyModel {
  final List<PatchBasketBodyBasketModel> basket;

  PatchBasketBodyModel({
    required this.basket,
  });

  Map<String, dynamic> toJson() => _$PatchBasketBodyModelToJson(this);
}

@JsonSerializable()
class PatchBasketBodyBasketModel {
  final String productId;
  final int count;

  PatchBasketBodyBasketModel({
    required this.productId,
    required this.count,
  });

  Map<String, dynamic> toJson() => _$PatchBasketBodyBasketModelToJson(this);

  factory PatchBasketBodyBasketModel.fromJson(Map<String, dynamic> json) => _$PatchBasketBodyBasketModelFromJson(json);
}