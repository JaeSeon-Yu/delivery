import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _PaginationInfo {
  final int fetchCount;

  final bool fetchMore;

  final bool forceRefetch;

  _PaginationInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final paginationThrottle = Throttle(
    const Duration(seconds: 3),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  PaginationProvider({required this.repository})
      : super(CursorPaginationLoading()) {
    paginate();
    paginationThrottle.values.listen((event) {
      _throttledPagination(event);
    });
  }

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    // 강제 리로딩
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    paginationThrottle.setValue(_PaginationInfo(
      fetchCount: fetchCount,
      fetchMore: fetchMore,
      forceRefetch: forceRefetch,
    ));
  }

  _throttledPagination(_PaginationInfo info) async {

    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;

    // 5가지 State 상태
    // CursorPagination - 정상적으로 데이터가 존재하는 상태

    // CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)

    // CursorPaginationError - 에러가 있는 상태

    // CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올때

    // CursorPaginationFetchMore - 추가 데이터 받아오라는 요청시

    // 바로 반환되는 상황
    // hasMore = false (다음 데이터가 없다는 값)
    // 로딩중 - fetchMore : true
    try {
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        //hasMore == false
        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      //fetchMore - 데이터를 추가로 받아오는 상황
      if (fetchMore) {
        final pState = (state as CursorPagination<T>);

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } //데이터를 처음부터 가져오는 상황
      else {
        if (state is CursorPagination && !forceRefetch) {
          // 아래에 추가하는 경우
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          // 아무것도 없는 경우
          state = CursorPaginationLoading();
        }
      }
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        // 기존 데이터에 새로운 데이터 추가
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e, stack) {
      state = CursorPaginationError(
          msg: '데이터를 가져오지 못했습니다.\nerror: $e\nstack: $stack ');
    }
  }
}
