import "package:flutter/material.dart";
import "package:prototype_v1/components/user_card.dart";
import "package:prototype_v1/constants/backend-client.dart";
import "package:prototype_v1/model/user_profile.dart";

// todo: アカウントリストを受け取ってそれを表示

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _userSearchController = TextEditingController();
  List<UserProfile> profiles = [];

  Future<void> _searchUser() async {
    var result = await backendAPIClient.searchUser(_userSearchController.text);
    setState(() {
      profiles = result!;
    });
  }

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
            onChanged: (value) => {_searchUser()},
          ),

          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text("友達", style: TextStyle(fontSize: 20)),
          ),
          ...this.profiles.map((item) => UserCard(profile: item)),
          const Text("知り合いかも"),
        ],
      ),
    );
  }
}
