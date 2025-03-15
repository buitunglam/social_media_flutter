/*
  PROFILE STARTS
  This will be displayed on all profile pages
  -----------------------------------------------

  NUmber of: 
  - posts
  - followers
  - following
*/

import 'package:flutter/material.dart';

class ProfileStarts extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;

  const ProfileStarts(
      {super.key,
      required this.postCount,
      required this.followerCount,
      required this.followingCount});

  @override
  Widget build(BuildContext context) {
    var textStyleForCount = TextStyle(
        fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary);
    var textStyleForText =
        TextStyle(color: Theme.of(context).colorScheme.primary);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(postCount.toString(), style: textStyleForCount),
              Text("Posts", style: textStyleForText)
            ],
          ),
        ),
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(followerCount.toString(), style: textStyleForCount),
              Text("Follower", style: textStyleForText)
            ],
          ),
        ),
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(followingCount.toString(), style: textStyleForCount),
              Text("following", style: textStyleForText)
            ],
          ),
        )
      ],
    );
  }
}
