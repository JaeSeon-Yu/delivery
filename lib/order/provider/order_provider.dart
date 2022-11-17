import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/order/model/order_model.dart';
import 'package:actual/order/model/post_order_body.dart';
import 'package:actual/order/repository/order_repository.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);

  return OrderStateNotifier(ref: ref, repository: repository);
});

class OrderStateNotifier
    extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({
    required this.ref,
    required super.repository,
  });

  Future<bool> postOrder() async {
    final uuid = Uuid();
    final id = uuid.v4();
    final state = ref.read(basketProvider);

    // try{
    //   var dio = ref.read(dioProvider);
    //
    //   final storage = ref.watch(secureStorageProvider);
    //   final token = await storage.read(key: ACCESS_TOKEN_KEY);
    //
    //   final resp = await dio.request(
    //       '$ip/order/',
    //     data: PostOrderBody(
    //       id: id,
    //       products: state.map(
    //             (e) =>
    //             PostOrderBodyProduct(
    //               productId: e.product.id,
    //               count: e.count,
    //             ),
    //       ).toList(),
    //       totalPrice: state.fold(0, (p, n) => p + n.product.price * n.count),
    //       createdAt: DateTime.now().toString(),
    //     ),
    //     options: Options(headers: {'accessToken' :'true'}, method: 'POST'),
    //   );
    //
    //   Logger().i('dio resp : $resp');
    //   return true;
    // }catch(e){
    //   Logger().e(e);
    //   return false;
    // }

    try {
      final resp = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map(
                (e) => PostOrderBodyProduct(
                  productId: e.product.id,
                  count: e.count,
                ),
              )
              .toList(),
          totalPrice: state.fold(0, (p, n) => p + n.product.price * n.count),
          createdAt: DateTime.now().toString(),
        ),
      );
      return true;
    } catch (e, state) {
      Logger().e('$e $state');
      return false;
    }
  }
}
