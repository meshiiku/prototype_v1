import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class OSMCopyRightWidget extends StatelessWidget {
  const OSMCopyRightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Text(
            "©︎ OpenStreetMap contributors",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
