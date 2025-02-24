import "package:flutter/material.dart";
import "package:prototype_v1/components/navigation_bar.dart";
import "package:prototype_v1/model/user_profile.dart";
import "package:prototype_v1/screen/users-screen.dart";
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

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
      home: const MyHomePage(title: "メシイク？"),
      locale: DevicePreview.locale(context),
      // 言語設定の変更を適用
      builder: DevicePreview.appBuilder, // DevicePreview を適用
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ProfileScreen(
        profiles: [
          UserProfile("GOROU5959", ["ラーメン"]),
          UserProfile("Hikakin TV", ["ラーメン", "お酒", "イタリアン"]),
          UserProfile("Masuo TV", ["焼肉", "お酒", "イタリアン"]),
          UserProfile("Gorou TV", ["ジャンクフード", "お酒", "大食い"]),
        ],
      ),
      bottomNavigationBar: const CustomNavigationBar(currentTab: 0),
    );
  }
}
