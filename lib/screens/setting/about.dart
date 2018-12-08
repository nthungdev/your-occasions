
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';




class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
        url: "https://www.freeprivacypolicy.com/privacy/view/8d414e396869bffe1925f89bea51bd6d",
        appBar: new AppBar(
          // leading: new BackButton(color: Colors.white),
          title: new Text("Privacy Policy"),
        ),
        // withZoom: true,
        withLocalStorage: true,
        hidden: true,
      );
    }
  }

  