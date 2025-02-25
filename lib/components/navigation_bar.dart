import "package:flutter/material.dart";

class CustomNavigationBar extends StatelessWidget {
  final int currentTab; // 現在のタブ
  final Function onDestinationSelected; // ナビゲーションのアイテムがクリックされた時のイベント

  const CustomNavigationBar({
    super.key,
    required this.currentTab,
    required this.onDestinationSelected,
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
        onDestinationSelected(index);
      },
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
