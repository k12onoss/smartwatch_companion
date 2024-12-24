import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingPage extends StatelessWidget {
  static String get path => "/loading";
  static String get name => "loading";
  static GoRoute get route => GoRoute(
        path: path,
        name: name,
        builder: (_, __) => LoadingPage(),
      );

  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
