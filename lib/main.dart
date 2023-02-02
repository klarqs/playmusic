import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:playmusic/providers/identify_controller.dart';
import 'package:playmusic/screens/edit_info.dart';
import 'package:playmusic/screens/identify.dart';
import 'package:playmusic/screens/playlist_home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:playmusic/screens/library.dart';
import 'package:playmusic/screens/now_playing.dart';
import 'package:playmusic/screens/playList.dart';
import 'package:playmusic/screens/playing_from.dart';
import 'package:playmusic/screens/settings.dart';
import 'package:playmusic/util/themes.dart';
import 'package:playmusic/providers/all_songs.dart';
import 'package:playmusic/providers/playList_database.dart';
import 'package:playmusic/providers/mark_songs.dart';
import 'package:playmusic/providers/song_controller.dart';
import 'package:playmusic/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AudioSession.instance.then((session) {
    session.configure(AudioSessionConfiguration.music());
  });
  SharedPreferences.getInstance().then((pref) {
    int theme = pref.getInt('theme') ?? 0;
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProviderClass(themeData: kThemes[theme])),
        ChangeNotifierProvider(create: (_) => PlayListDB()),
        ChangeNotifierProvider(create: (_) => SongController()),
        ChangeNotifierProvider(create: (_) => MarkSongs()),
        ChangeNotifierProvider(create: (_) => IdentifyController()),
      ],
      child: MyApp(theme: kThemes[theme]),
    ));
  });
}

class MyApp extends StatelessWidget {
  MyApp({this.theme});
  final ThemeData? theme;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vibe player',
      theme: Provider.of<ProviderClass>(context).theme,
      home: SplashScreen(theme!),
      routes: {
        Library.pageId: (ctx) => Library(),
        EditInfo.pageId: (ctx) => EditInfo(),
        NowPlaying.pageId: (ctx) => NowPlaying(),
        PlayList.pageId: (ctx) => PlayList(),
        PlayingFrom.pageId: (ctx) => PlayingFrom(),
        Identify.pageId: (ctx) => Identify(),
        Settings.pageId: (ctx) => Settings(),
        PlayListHome.pageId: (ctx) => PlayListHome(),
      },
    );
  }
}
