import 'package:bloc_playground/features/infinite_list/models/post.dart';
import 'package:flutter/material.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading: Text('${post.id}', style: textTheme.caption),
        title: Text(post.title),
        isThreeLine: true,
        subtitle: Text(post.body),
        dense: true,
      ),
    );
  }
}
