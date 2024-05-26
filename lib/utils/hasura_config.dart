import 'package:fluttertoast/fluttertoast.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/page/bottom_nav_pages/bottom_nav_page.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/providers/user_data.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

final hasuraClientProvider = StateProvider<HasuraConnect>(
  (ref) {
    return HasuraConnect(
      // 'https://sekopercinta.braga.co.id/v1/graphql',
      'https://sekopercinta.jabarprov.go.id/hasura/v1/graphql',
      interceptors: [TokenInterceptor(ref.watch(authProvider), ref)],
    );
  },
);

class TokenInterceptor extends Interceptor {
  final String token;
  final ProviderReference ref;

  TokenInterceptor(this.token, this.ref);

  @override
  Future<void> onConnected(HasuraConnect connect) {
    throw UnimplementedError();
  }

  @override
  Future<void> onDisconnected() {
    throw UnimplementedError();
  }

  @override
  Future<dynamic>? onError(HasuraError request, HasuraConnect connect) async {
    if (request.message == 'Could not verify JWT: JWTExpired') {
      ref.read(authProvider.notifier).logout();
      ref.read(userDataProvider.notifier).resetUserData();

      navigatorKey.currentState?.pushAndRemoveUntil(
        createRoute(page: const BottomNavPage()),
        (route) => false,
      );
      Fluttertoast.showToast(
        msg: 'Login Session telah selesai, mohon login ulang',
      );
    } else {
      Fluttertoast.showToast(
        msg: request.message,
      );
    }

    return request.message;
  }

  @override
  Future<dynamic>? onRequest(Request request, HasuraConnect connect) async {
    if (token.isEmpty) {
      return request;
    } else {
      try {
        request.headers["Authorization"] = "Bearer $token";
        return request;
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future<dynamic>? onResponse(Response data, HasuraConnect connect) async {
    return data;
  }

  @override
  Future<void> onSubscription(Request request, Snapshot snapshot) {
    throw UnimplementedError();
  }

  @override
  Future<void> onTryAgain(HasuraConnect connect) async {}
}
