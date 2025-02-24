import "package:flutter/material.dart";

class CustomNavigationBar extends StatelessWidget {
  final int currentTab;

  // todo: タップした時のイベント
  const CustomNavigationBar({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.person), label: "自分のお腹"),
        NavigationDestination(icon: Icon(Icons.people_sharp), label: "みんなのお腹"),
        NavigationDestination(icon: Icon(Icons.map), label: "地図"),
        NavigationDestination(icon: Icon(Icons.flag), label: "みんなの助け"),
      ],
    );
  }
}
