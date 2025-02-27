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
      shadowColor: Colors.transparent,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(1),
            margin: EdgeInsets.all(2),
            child: Row(
              children: [
                CircleAvatar(radius: 26),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children:
                          profile.hashtags
                              .map(
                                (item) => Container(
                                  padding: const EdgeInsets.only(
                                    left: 6,
                                    right: 6,
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  margin: const EdgeInsets.only(
                                    left: 2,
                                    right: 2,
                                    top: 4,
                                  ),
                                  decoration: BoxDecoration(
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
