
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';




class SuggestImprovement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
        url: "https://docs.google.com/forms/d/e/1FAIpQLSfC_yhXNcBF2U4LbHUoOdL012Q-Deue6FLJyAs-8IhbFOxGeg/viewform?vc=0&c=0&w=1",
        appBar: new AppBar(
          // leading: new BackButton(color: Colors.white),
          title: new Text("Suggest Improvement"),
        ),
        // withZoom: true,
        withLocalStorage: true,
        hidden: true,
      );
    }
  }
