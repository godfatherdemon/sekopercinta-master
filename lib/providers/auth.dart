import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final authProvider = StateNotifierProvider<AuthNotifier, String>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<String> {
  AuthNotifier() : super('');

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '498641063782-s1f14rl2mf498ejrd57uk1htelsr7j97.apps.googleusercontent.com',
    scopes: <String>[
      'email',
    ],
  );

  bool get isAuth {
    return state.isNotEmpty;
  }

  bool tryAutoLogin() {
    final String token = Hive.box('sekopercinta').get('token');
    // print('istri simpanan $token');
    final Logger logger = Logger();
    logger.d('PRINT $token');

    // if (token == null) {
    //   return false;
    // }
    state = token;
    return true;
  }

  // bool isFirstTimeUsingApp() {
  //   final bool isFirstTime =
  //       Hive.box('sekopercinta').get('first_time_using_app');

  //   if (isFirstTime == null) {
  //     return true;
  //   }
  //   return false;
  // }

  bool isFirstTimeUsingApp() {
    return Hive.box('sekopercinta').get('first_time_using_app') ?? true;
  }

  void setFirstTimeUsingApp() {
    final box = Hive.box('sekopercinta');
    box.put('first_time_using_app', false);
  }

  // bool isFirstTimeAccessCourse() {
  //   final bool isFirstTime =
  //       Hive.box('sekopercinta').get('first_time_access_course');
  //   print('pertama kali ga? $isFirstTime');

  //   if (isFirstTime == null) {
  //     return true;
  //   }
  //   return false;
  // }

  bool isFirstTimeAccessCourse() {
    final bool isFirstTime =
        Hive.box('sekopercinta').get('first_time_access_course') ?? true;
    // print('pertama kali ga? $isFirstTime');
    final Logger logger = Logger();
    logger.d('PRINT $isFirstTime');

    return isFirstTime;
  }

  void setFirstTimeAccessCourse() {
    final box = Hive.box('sekopercinta');
    box.put('first_time_access_course', false);
  }

  Future<void> login(
      Map<String, String> authData, HasuraConnect hasuraConnect) async {
    // print(authData);
    final Logger logger = Logger();
    logger.d(authData);

    String docQuery = """
query MyQuery {
  signin(email: "${authData['email']}", password: "${authData['password']}") {
    accessToken
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    // print(response);
    logger.d('PRINT $response');
    final responseData = response['data'];

    // print(responseData['signin']['accessToken']);
    logger.d(responseData['signin']['accessToken']);

    final box = Hive.box('sekopercinta');
    box.put('token', responseData['signin']['accessToken']);

    state = responseData['signin']['accessToken'];
  }

  Future<void> googleSignIn() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return;
      }

      final googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // print('token google ${googleSignInAuthentication.idToken}');
      final Logger logger = Logger();
      logger.d('token google ${googleSignInAuthentication.idToken}');

      // var url = Uri.parse('https://sekoci.braga.co.id/api/auth/gsignin');
      var url =
          Uri.parse('https://sekopercinta.jabarprov.go.id/api/auth/gsignin');

      final response = await http.post(
        url,
        body: json.encode({
          "input": {
            "gtoken": googleSignInAuthentication.idToken,
          }
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final box = Hive.box('sekopercinta');
      box.put('token', jsonDecode(response.body)['accessToken']);

      state = jsonDecode(response.body)['accessToken'];

      // print('response value ${response.body}');
      logger.d('response value ${response.body}');
    } catch (error) {
      // print(error.toString());
      final Logger logger = Logger();
      logger.d(error.toString());
      Fluttertoast.showToast(
        msg: error.toString(),
      );
    }
  }

  Future<void> signUp(
      Map<String, String> authData, HasuraConnect hasuraConnect) async {
    // print(authData);
    final Logger logger = Logger();
    logger.d(authData);

    String docMutation = """
mutation MyMutation {
  signup(email: "${authData['email']}", password: "${authData['password']}") {
    message
  }
}
""";

    final response = await hasuraConnect.mutation(docMutation);
    // print(response);
    logger.d(response);
  }

  Future<void> changePassword(String newPassword, String oldPassword,
      HasuraConnect hasuraConnect) async {
    String docMutation = """
mutation MyMutation {
  changePassword(newPassword: "$newPassword", oldPassword: "$oldPassword") {
    message
  }
}
""";

    final response = await hasuraConnect.mutation(docMutation);
    // print(response);
    final Logger logger = Logger();
    logger.d(response);
  }

  void logout() async {
    state = '';
    final box = Hive.box('sekopercinta');
    box.delete('token');
    if (await _googleSignIn.isSignedIn()) {
      // print('logout');
      final Logger logger = Logger();
      logger.d('logout');
      _googleSignIn.signOut();
    }
  }
}
