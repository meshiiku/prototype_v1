import "package:dart_jsonwebtoken/dart_jsonwebtoken.dart";
import "package:flutter/material.dart";
import "package:prototype_v1/components/user_card.dart";
import "package:prototype_v1/constants/backend-client.dart";
import "package:prototype_v1/model/user.dart";
import "package:prototype_v1/saves/jwt.dart";

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  var username = "";

  @override
  void initState() {
    //端末に保存しているjwtを取得
    getJWTToken().then((jwtToken) async {
      // なければサーバーから取得
      jwtToken ??= await backendAPIClient.loginAsAnonymous();
      //取得できたら、jwtをデコードしてユーザーIDを取得
      if (jwtToken != null) {
        setState(() {
          username = JWT.decode(jwtToken!).payload["user_id"].toString();
        });
      } else {
        // サーバーエラーなどでjwtが取得できなかった場合はココ
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        UserCard(
          profile: User(
            userId: "${username}",
            hashtags: ["焼肉", "ガツガツ系", "うどん"],
          ),
        ),
        Stack(
          children: [
            FloatingActionButton(
              onPressed: () {
                backendAPIClient.getCheck().then((info) {
                  debugPrint(info);
                });
              },
              child: Icon(Icons.info),
            ),
          ],
        ),
      ],
    );
  }
}
