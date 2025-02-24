import "package:flutter/material.dart";
import "package:prototype_v1/model/user_profile.dart";

class UserCard extends StatelessWidget {
  final UserProfile profile;

  const UserCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: RoundedRectangleBorder(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(1),
            child: Row(
              children: [
                CircleAvatar(),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.username),
                    Row(
                      children:
                          profile.hashtags
                              .map(
                                (item) => Container(
                                  padding: EdgeInsets.only(left: 6, right: 6),
                                  margin: EdgeInsets.only(left: 2, right: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade400,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  child: Text("#" + item),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
