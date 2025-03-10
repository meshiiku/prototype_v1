import "package:flutter/material.dart";
import "package:prototype_v1/constants/backend-client.dart";
import "package:prototype_v1/model/user.dart";
import "package:prototype_v1/service/backend-api-client.dart";

class UserCard extends StatelessWidget {
  final User profile;

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
                CircleAvatar(
                  radius: 26,
                  backgroundImage:
                      profile.profileImage != null
                          ? NetworkImage(profile.profileImage!)
                          : NetworkImage(BackendAPIClient.randomRamenIconUrl()),
                ),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.userId,
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
