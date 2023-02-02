import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:playmusic/components/create_playList.dart';
import 'package:playmusic/components/custom_button.dart';
import 'package:playmusic/components/custom_card.dart';
import 'package:playmusic/components/library_bottom_sheet.dart';
import 'package:playmusic/components/library_song_control.dart';
import 'package:playmusic/providers/all_songs.dart';
import 'package:playmusic/util/config.dart';
import 'package:playmusic/providers/playList_database.dart';
import 'package:playmusic/providers/song_controller.dart';
import 'package:playmusic/screens/playList.dart';
import 'package:playmusic/screens/settings.dart';
import 'package:provider/provider.dart';

class PlayListHome extends StatefulWidget {
  static const String pageId = '/playlist_home';
  @override
  _PlayListHomeState createState() => _PlayListHomeState();
}

class _PlayListHomeState extends State<PlayListHome>
    with WidgetsBindingObserver {
  SongController? _controller;
  void openPlaylist({String? title}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayList(
          playListName: title!,
        ),
      ),
    );
  }

  IconData getPlaylistIcon(index) {
    switch (index) {
      case 0:
        return FontAwesomeIcons.music;
        break;
      case 1:
        return FontAwesomeIcons.music;
        break;
      default:
        return FontAwesomeIcons.music;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void showNotification() {
    _controller = Provider.of<SongController>(context, listen: false);
    if (_controller!.nowPlaying!.path != null) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _controller = Provider.of<SongController>(context, listen: false);
    _controller!.state = state;
    if (state == AppLifecycleState.resumed) {}
    if (state == AppLifecycleState.paused &&
        _controller!.nowPlaying?.path != null) {}
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 80),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        top: 16,
                        right: 18,
                        bottom: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomButton(
                            icon: "assets/svgs/chevron-left.svg",
                            diameter: 12,
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            'Playlists',
                            style: TextStyle(
                              fontSize: Config.textSize(context, 5.2),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          CustomButton(
                            diameter: 12,
                            icon: "assets/svgs/setting-2.svg",
                            onPressed: () {
                              Navigator.pushNamed(context, Settings.pageId);
                            },
                          ),
                        ],
                      ),
                    ),
                    // Divider(
                    //   height: 0.0,
                    //   thickness: 1.0,
                    //   color: Theme.of(context).dividerColor,
                    // ),
                    SizedBox(height: Config.yMargin(context, 1)),
                    Consumer<PlayListDB>(
                      builder: (_, playListDB, child) {
                        return SizedBox(
                          height: 400,
                          width: MediaQuery.of(context).size.width,
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            scrollDirection: Axis.vertical,
                            itemCount: playListDB.playList.length,
                            itemBuilder: (_, index) {
                              int songCount = index > 0
                                  ? playListDB.playList[index]['songs'].length
                                  : null;
                              return GestureDetector(
                                onTap: () {
                                  if (playListDB.playList[index]['name'] ==
                                      'Create playlist') {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CreatePlayList(
                                          createNewPlaylist: true,
                                        );
                                      },
                                    );
                                  } else {
                                    openPlaylist(
                                        title: playListDB.playList[index]
                                            ['name']);
                                  }
                                },
                                onLongPress: () {
                                  if (index > 1) {
                                    showModalBottomSheet(
                                      enableDrag: false,
                                      context: context,
                                      builder: (context) => LibraryBottomSheet(
                                          playListDB.playList[index]['name']),
                                    );
                                  }
                                },
                                child: CustomCard2(
                                        label: playListDB.playList[index]
                                            ['name'],
                                        child: playListDB.playList[index]
                                                    ['name'] ==
                                                'Create playlist'
                                            ? "assets/svgs/plus.svg"
                                            : playListDB.playList[index]
                                                        ['name'] ==
                                                    'Favourites'
                                                ? "assets/svgs/heart.svg"
                                                : "assets/svgs/music-filter-.svg",
                                        numOfSongs: songCount,
                                      ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.1,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              LibrarySongControl(),
            ],
          ),
        ),
      ),
    );
  }
}
