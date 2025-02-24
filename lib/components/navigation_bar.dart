import "package:flutter/material.dart";

class CustomNavigationBar extends StatelessWidget {
  final int currentTab;
  final Function ontap;

  // todo: タップした時のイベント
  const CustomNavigationBar({
    super.key,
    required this.currentTab,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.search), label: "探す"),
        NavigationDestination(icon: Icon(Icons.people_sharp), label: "お腹"),
        NavigationDestination(icon: Icon(Icons.store), label: "検索履歴"),
        NavigationDestination(icon: Icon(Icons.person), label: "マイページ"),
      ],
      selectedIndex: currentTab,

      onDestinationSelected: (int index) {
        ontap(index);
      },
    );
  }
}
