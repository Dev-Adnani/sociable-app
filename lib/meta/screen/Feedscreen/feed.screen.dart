import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/core/helpers/FeedHelpers/feed.helpers.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: Provider.of<FeedHelpers>(context, listen: false).appBar(context),
      body: Provider.of<FeedHelpers>(context, listen: false).feedBody(context),
    );
  }
}
