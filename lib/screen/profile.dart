import "package:flutter/material.dart";

// note: まだ仮画面状態、flutterリハビリ
// todo: アカウントリストを受け取ってそれを表示

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.all(2),
                child: Row(
                  children: [
                    CircleAvatar(),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("@Masuo222"),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text("#大食い"),
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text("#お酒"),
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text("#ラーメン"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
