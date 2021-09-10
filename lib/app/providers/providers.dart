import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:social_tower/core/helpers/FeedHelpers/feed.helpers.dart';
import 'package:social_tower/core/helpers/HomeScreenHelpers/homePage.helpers.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landing.notifier.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landing.utlis.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landingService.notifier.dart';
import 'package:social_tower/core/helpers/ProfileHelpers/profile.helpers.dart';
import 'package:social_tower/core/utils/posts.functions.dart';
import 'package:social_tower/core/utils/upload.post.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';

List<SingleChildWidget> providers = [...remoteProviders];

List<SingleChildWidget> remoteProviders = [
  ChangeNotifierProvider(create: (_) => LandingNotifier()),
  ChangeNotifierProvider(create: (_) => Authentication()),
  ChangeNotifierProvider(create: (_) => LandingService()),
  ChangeNotifierProvider(create: (_) => FirebaseNotifier()),
  ChangeNotifierProvider(create: (_) => LandingUtils()),
  ChangeNotifierProvider(create: (_) => HomePageHelpers()),
  ChangeNotifierProvider(create: (_) => ProfileHelpers()),
  ChangeNotifierProvider(create: (_) => UploadPost()),
  ChangeNotifierProvider(create: (_) => FeedHelpers()),
  ChangeNotifierProvider(create: (_) => PostFunctions()),
];
