import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';

share_charts(
  GlobalKey key,
  var sub,
) async {
  var file_name = DateTime.now().toString() + ".png";
  RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
  ui.Image image = await boundary.toImage(pixelRatio: 3);
  ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  Uint8List pngBytes = byteData.buffer.asUint8List();
  final directory = (await getTemporaryDirectory()).path;

  File imgFile = new File('$directory/' + file_name);
  imgFile.writeAsBytes(pngBytes);
  Share.shareFiles(['$directory/' + file_name], text: sub);
}

get_better_batsman_score(dic1, dic2) {
  if (dic1['runs'] > dic2['runs']) {
    return dic1;
  } else if (dic1['runs'] == dic2['runs']) {
    if (dic1['balls'] < dic2['balls']) {
      return dic1;
    } else if (dic1['balls'] == dic2['balls']) {
      if (dic1['status'] == 'not out') {
        return dic1;
      }
    }
  }
  return dic2;
}
