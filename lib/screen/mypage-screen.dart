import "package:dart_jsonwebtoken/dart_jsonwebtoken.dart";
import "package:flutter/material.dart";
import "package:prototype_v1/components/user_card.dart";
import "package:prototype_v1/constants/backend-client.dart";
import "package:prototype_v1/model/user_profile.dart";
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
    resetJWTToken();
    getJWTToken().then((jwtToken) async {
      jwtToken ??= await backendAPIClient.loginAsAnonymous();
      if (jwtToken != null) {
        setState(() {
          username = JWT.decode(jwtToken!).payload["user_id"].toString();
        });
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
          profile: UserProfile(
            user_id: "${username}",
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
