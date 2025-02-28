import "package:flutter/material.dart";
import "package:prototype_v1/components/user_card.dart";
import "package:prototype_v1/constants/backend-client.dart";
import "package:prototype_v1/constants/user_profile_dummies.dart";
import "package:prototype_v1/model/user.dart";

// todo: アカウントリストを受け取ってそれを表示

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController _userSearchController = TextEditingController();
  List<User> profiles = [...dummyUsers]; // dummyUsersを追加

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbColor: Theme.of(context).highlightColor,
      radius: const Radius.circular(2.0),
      thickness: 3,
      child: ListView(
        children: [
          TextField(
            controller: _userSearchController,
            decoration: InputDecoration(
              filled: true,
              hintText: "友達の検索、またはフォロー",
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) async {
              var result = await backendAPIClient.searchUser(
                _userSearchController.text,
              );
              if (result != null) {
                setState(() {
                  profiles = result;
                });
              }
            },
          ),

          ...profiles.map((item) => UserCard(profile: item)),
        ],
      ),
    );
  }
}
