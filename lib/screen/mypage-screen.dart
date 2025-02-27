import "package:dart_jsonwebtoken/dart_jsonwebtoken.dart";
import "package:flutter/material.dart";
import "package:prototype_v1/components/user_card.dart";
import "package:prototype_v1/constants/backend-client.dart";
import "package:prototype_v1/model/user_profile.dart";

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  var username = "";

  @override
  void initState() {
    backendAPIClient.loginAsDummy().then((value) {
      if (value != null) {
        setState(() {
          username = JWT.decode(value).payload["display_name"].toString();
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
            username: "${username}",
            hashtags: ["焼肉", "ガツガツ系", "うどん"],
          ),
        ),
      ],
    );
  }
}
