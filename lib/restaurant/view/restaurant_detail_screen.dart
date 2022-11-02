import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurantDetailModel.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  Future<Map<String,dynamic>> getRestaurantDetail() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      '$ip/restaurant/$id',
      options: Options(
        headers: {
          'authorization' : 'Bearer $accessToken',
        },
      ),
    );
    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<Map<String,dynamic>>(
        future: getRestaurantDetail(),
        builder: (context, AsyncSnapshot<Map<String,dynamic>> snapshot) {


          Logger().i(snapshot.data);
          if(!snapshot.hasData){
            return Container();
          }

          final item = RestaurantDetailModel.fromJson(json: snapshot.data!,);
          return CustomScrollView(
            slivers: [
              _renderTop(),
              _renderLabel(),
              _renderProducts(),
            ],
          );
        }
      ),
    );
  }

  SliverPadding _renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  SliverPadding _renderProducts() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ProductCard(),
            );
          },
          childCount: 10,
        ),
      ),
    );
  }

  SliverToBoxAdapter _renderTop() {
    return SliverToBoxAdapter(
      child: RestaurantCard(
        image: Image.asset('asset/img/food/ddeok_bok_gi.jpg'),
        name: 'name',
        tags: ['떡볶이', '매움'],
        ratingsCount: 324,
        deliveryTime: 40,
        deliveryFee: 1000,
        ratings: 3.4,
        priceRange: RestaurantPrice.cheap,
        isDetail: true,
        detail: "erqrqw",
      ),
    );
  }
}
