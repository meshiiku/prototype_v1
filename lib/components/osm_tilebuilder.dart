import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";

Widget darkModeTileBuilder(
  BuildContext context,
  Widget tileWidget,
  TileImage tile,
) {
  return ColorFiltered(
    colorFilter: const ColorFilter.matrix(<double>[
      -1,
      0,
      0,
      0,
      255,
      0,
      -1,
      0,
      0,
      255,
      0,
      0,
      -1.2,
      0,
      255,
      0,
      0,
      0,
      1,
      0,
    ]),
    child: tileWidget,
  );
}
