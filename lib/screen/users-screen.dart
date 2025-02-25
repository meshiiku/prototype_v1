import "package:flutter/material.dart";
import "package:prototype_v1/components/user_card.dart";
import "package:prototype_v1/model/user_profile.dart";

// todo: アカウントリストを受け取ってそれを表示

class ProfileScreen extends StatelessWidget {
  final List<UserProfile> profiles;

  const ProfileScreen({super.key, required this.profiles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];
        return UserCard(profile: profile);
      },
    );
  }
}
