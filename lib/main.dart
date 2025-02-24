import "package:flutter/material.dart";
import "package:prototype_v1/components/navigation_bar.dart";
import "package:prototype_v1/model/user_profile.dart";
import "package:prototype_v1/screen/mypage-screen.dart";
import "package:prototype_v1/screen/search-screen.dart";
import "package:prototype_v1/screen/store-history-screen.dart";
import "package:prototype_v1/screen/users-screen.dart";
import "package:device_preview/device_preview.dart";
import "package:flutter/foundation.dart";

void main() {
  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "メシイク？",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
      locale: DevicePreview.locale(context),
      // 言語設定の変更を適用
      builder: DevicePreview.appBuilder, // DevicePreview を適用
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 2;
  List<Widget> screens = [
    SearchScreen(),
    ProfileScreen(
      profiles: [
        new UserProfile("username", ["hashtags"]),
      ],
    ),
    StoreHistoryScreen(),
    MyPageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("メシイク？"),
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: CustomNavigationBar(
        currentTab: this._currentIndex,
        ontap: (index) {
          setState(() {
            this._currentIndex = index;
          });
        },
      ),
    );
  }
}
