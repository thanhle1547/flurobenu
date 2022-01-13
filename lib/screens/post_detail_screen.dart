import 'package:flurobenu/widget/favorite_button.dart';
import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({
    Key? key,
    required this.name,
    required this.id,
  }) : super(key: key);

  final String name;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post detail'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(name),
            FavoriteButton(id: id),
          ],
        ),
      ),
    );
  }
}
