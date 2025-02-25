import "package:flutter/material.dart";
import "package:prototype_v1/components/user_card.dart";
import "package:prototype_v1/model/user_profile.dart";

// todo: アカウントリストを受け取ってそれを表示

class ProfileScreen extends StatelessWidget {
  final List<UserProfile> profiles;

  const ProfileScreen({super.key, required this.profiles});

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbColor: Theme.of(context).highlightColor,
      radius: Radius.circular(2.0),
      thickness: 3,
      child: ListView(
        children: [
          const Text("友達", style: TextStyle(fontSize: 20)),
          ...profiles.map((item) => UserCard(profile: item)).toList(),
          const Text("知り合いかも"),
        ],
      ),
    );
  }
}
