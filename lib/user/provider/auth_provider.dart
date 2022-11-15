import 'package:actual/common/view/root_tab.dart';
import 'package:actual/common/view/splash_screen.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:actual/restaurant/view/restaurant_screen.dart';
import 'package:actual/user/model/user_model.dart';
import 'package:actual/user/provider/user_me_provider.dart';
import 'package:actual/user/view/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      notifyListeners();
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, state) => RootTab(),
          routes: [
            GoRoute(
              path: 'restaurant/:rid',
              name: RestaurantDetailScreen.routeName,
              builder: (_, state) => RestaurantDetailScreen(
                id: state.params['rid']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, state) => SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, state) => LoginScreen(),
        ),
      ];

  void logout(){
    ref.read(userMeProvider.notifier).logout();
  }

  //splash screen - 앱을 처음 시작시 토큰 확인하고 로그인 스크린으로 보내줄지 홈 스크린으로 보내줄지 확인하는 과정
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);
    final logginIn = state.location == '/login';

    //로그인 정보가 없는데
    if (user == null) {
      //로그인 페이지면 그대로, 로그인 페이지가 아니면 로그인으로
      return logginIn ? null : '/login';
    }

    //로그인 정보가 있는데
    if (user is UserModel) {
      //로그인중이거나 스플레시 스크린이면 홈으로 이동
      return logginIn || state.location == '/splash' ? '/' : null;
    }

    //로그인 정보가 에러일때
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}
