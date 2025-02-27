import "package:flutter/material.dart";
import "package:prototype_v1/components/user_card.dart";
import "package:prototype_v1/env.dart";
import "package:prototype_v1/model/user_profile.dart";

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: [
        UserCard(
          profile: UserProfile(
            username: "太郎",
            hashtags: ["焼肉", "ガツガツ系", "うどん"],
          ),
        ),
      ],
    );
  }
}
