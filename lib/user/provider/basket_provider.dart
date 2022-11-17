import 'package:actual/product/model/product_model.dart';
import 'package:actual/user/model/basket_item_model.dart';
import 'package:actual/user/model/patch_basket_body_model.dart';
import 'package:actual/user/repository/user_me_repository.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);

  return BasketProvider(
    repository: repository,
  );
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;
  final updateBasketDebounce = Debouncer(
    const Duration(seconds: 1),
    initialValue: null,
    checkEquality: false,
  );

  BasketProvider({required this.repository}) : super([]){
    updateBasketDebounce.values.listen((event) {
      patchBasket();
    });
  }

  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBodyModel(
        basket: state
            .map(
              (e) => PatchBasketBodyBasketModel(
                productId: e.product.id,
                count: e.count,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    final exists =
        state.firstWhereOrNull((element) => element.product.id == product.id) !=
            null;

    if (exists) {
      // 장바구니에 이미 들어있다면 카운트를 +1 한다.
      state = state
          .map(
            (e) =>
                e.product.id == product.id ? e.copyWith(count: e.count + 1) : e,
          )
          .toList();
    } else {
      // 장바구니에 해당되는 상품이 없다면 상품을 추가한다.

      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        ),
      ];
    }

    updateBasketDebounce.setValue(null);
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDelete = false,
  }) async {
    final exists = state.firstWhereOrNull(
          (element) => element.product.id == product.id,
        ) !=
        null;
    if (!exists) {
      //상품이 존재하지 않을때 -> 즉시 반환하고 아무것도 실행하지 않는다.
      return;
    }
    //장바구니에 상품이 존재할때 -> 개수가 1이면 삭제, 1보다 크면 -1처리

    final existingProduct = state.firstWhere(
      (element) => element.product.id == product.id,
    );

    if (existingProduct.count == 1 || isDelete) {
      state = state
          .where(
            (element) => element.product.id != product.id,
          )
          .toList();
    } else {
      state = state
          .map(
            (e) =>
                e.product.id == product.id ? e.copyWith(count: e.count - 1) : e,
          )
          .toList();
    }
    updateBasketDebounce.setValue(null);
  }
}
