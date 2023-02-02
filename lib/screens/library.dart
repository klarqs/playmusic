import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:playmusic/components/create_playList.dart';
import 'package:playmusic/components/custom_button.dart';
import 'package:playmusic/components/custom_card.dart';
import 'package:playmusic/components/library_bottom_sheet.dart';
import 'package:playmusic/components/library_song_control.dart';
import 'package:playmusic/providers/all_songs.dart';
import 'package:playmusic/screens/playlist_home.dart';
import 'package:playmusic/util/config.dart';
import 'package:playmusic/providers/playList_database.dart';
import 'package:playmusic/providers/song_controller.dart';
import 'package:playmusic/screens/playList.dart';
import 'package:playmusic/screens/settings.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_media_notification/flutter_media_notification.dart';

class Library extends StatefulWidget {
  static const String pageId = '/library';
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> with WidgetsBindingObserver {
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
    if (_controller!.nowPlaying!.path != null) {
      // MediaNotification.showNotification(
      //   title: _controller.nowPlaying.title,
      //   author: _controller.nowPlaying.artist,
      //   isPlaying: _controller.isPlaying,
      // );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _controller = Provider.of<SongController>(context, listen: false);
    _controller!.state = state;
    // if app comes to the foregroung hide notification
    if (state == AppLifecycleState.resumed) {
      // MediaNotification.hideNotification();
    }
    //if app goes to background show notification
    if (state == AppLifecycleState.paused &&
        _controller!.nowPlaying?.path != null) {
      // MediaNotification.setListener('play', () => _controller!.play());
      // MediaNotification.setListener('pause', () => _controller!.pause());
      // MediaNotification.setListener('next', () async {
      //   await _controller!.skip(next: true);
      //   showNotification();
      // });
      // MediaNotification.setListener('prev', () async {
      //   await _controller!.skip(prev: true);
      //   showNotification();
      // });
    }
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
                          Text(
                            'My Music',
                            style: TextStyle(
                              fontSize: Config.textSize(context, 5.2),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Spacer(),
                          // CustomButton(
                          //   diameter: 12,
                          //   child: Icons.keyboard_voice_rounded,
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, Identify.pageId);
                          //   },
                          // ),
                          // SizedBox(width: 16),
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
                    SizedBox(
                      width: Config.xMargin(context, 30),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          'Your Downloads',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Config.textSize(context, 3.5),
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context)
                                .unselectedWidgetColor
                                .withOpacity(.5),
                            letterSpacing: .4,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Config.yMargin(context, 1.5)),
                    SizedBox(
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: [
                          Consumer<ProviderClass>(
                            builder: (context, provider, child) {
                              return GestureDetector(
                                onTap: () {
                                  openPlaylist(title: 'Songs');
                                },
                                child: CustomCard2(
                                  label: "Songs",
                                  width: double.infinity,
                                  numOfSongs: provider.allSongs.length ?? 0,
                                  child: "assets/svgs/musicnote.svg",
                                ),
                              );
                            },
                          ),
                          Consumer<PlayListDB>(
                            builder: (_, playListDB, child) {
                              var playListTotal =
                                  playListDB.playList.length ?? 0;
                              for (int i = 0;
                                  i < playListDB.playList.length;
                                  i++) {
                                playListDB.playList[i]['name'] ==
                                        'Create playlist'
                                    ? playListTotal = playListTotal - 1
                                    : playListTotal = playListTotal;
                                playListDB.playList[i]['name'] == 'Favourites'
                                    ? playListTotal = playListTotal - 1
                                    : playListTotal = playListTotal;
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlayListHome(),
                                    ),
                                  );
                                },
                                child: CustomCard2(
                                  label: "Playlists",
                                  width: double.infinity,
                                  numOfSongs: playListTotal,
                                  child: "assets/svgs/music-filter-.svg",
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Config.yMargin(context, 3.5),
                    ),
                    SizedBox(
                      width: Config.xMargin(context, 30),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          'Your Activities',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Config.textSize(context, 3.5),
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context)
                                .unselectedWidgetColor
                                .withOpacity(.5),
                            letterSpacing: .4,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Config.yMargin(context, 1.5)),
                    SizedBox(
                      height: 300,
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          CustomCard(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayListHome(),
                                ),
                              ),
                            },
                            icon: "assets/svgs/music-filter.svg",
                            label: "Your Playlists",
                          ),
                          Divider(indent: 64),
                          Consumer<PlayListDB>(builder: (_, playListDB, child) {
                            return CustomCard(
                              onTap: () => {
                                for (int i = 0;
                                    i < playListDB.playList.length;
                                    i++)
                                  {
                                    if (playListDB.playList[i]['name'] ==
                                        'Favourites')
                                      {
                                        openPlaylist(
                                            title: playListDB.playList[i]
                                                ['name']),
                                      }
                                  },
                              },
                              icon: "assets/svgs/heart.svg",
                              label: "Liked Songs",
                            );
                          }),
                          Divider(indent: 64),
                          Consumer<PlayListDB>(builder: (_, playListDB, child) {
                            return CustomCard(
                              onTap: () => {
                                openPlaylist(title: "Recently Played"),
                              },
                              icon: "assets/svgs/history.svg",
                              label: "Recently Played",
                            );
                          }),
                          Divider(indent: 64),
                          Consumer<PlayListDB>(builder: (_, playListDB, child) {
                            return CustomCard(
                              onTap: () => {
                                openPlaylist(title: 'Recently Added'),
                              },
                              icon: "assets/svgs/play-add.svg",
                              label: "Recently Added",
                            );
                          }),
                        ],
                      ),
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
