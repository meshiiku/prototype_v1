import "package:flutter/material.dart";

class CustomNavigationBar extends StatelessWidget {
  final int currentTab;

  // todo: タップした時のイベント
  const CustomNavigationBar({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: "Home"),
        NavigationDestination(icon: Icon(Icons.search), label: "Search"),
        NavigationDestination(icon: Icon(Icons.analytics), label: "Analytics"),
      ],
    );
  }
}
