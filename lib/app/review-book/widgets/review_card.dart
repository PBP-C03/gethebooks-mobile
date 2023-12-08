import 'package:flutter/material.dart';
import 'package:gethebooks/app/review-book/models/review.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard(this.review, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Card(
      // TODO: bikin review card,
    )
  }
}