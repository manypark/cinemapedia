import 'package:flutter/material.dart';

class FavoritesViews extends StatelessWidget {

  const FavoritesViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body  : const Center(
        child: Text('Favorites'),
      ),
    );
  }
}