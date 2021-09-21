import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/providers/providers.dart';
import 'package:social_tower/meta/screen/Splashscreen/splash.screen.dart';
import 'app/constants/constant.colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Lava());
}

class Lava extends StatelessWidget {
  const Lava({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          canvasColor: Colors.transparent,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: blueColor),
        ),
      ),
    );
  }
}
