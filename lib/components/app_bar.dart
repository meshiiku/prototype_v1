import "package:flutter/material.dart";

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: const Text("メシイク？", style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
