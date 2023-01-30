import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:playmusic/components/create_playList.dart';
import 'package:playmusic/components/custom_button.dart';
import 'package:playmusic/components/custom_card.dart';
import 'package:playmusic/components/library_bottom_sheet.dart';
import 'package:playmusic/components/library_song_control.dart';
import 'package:playmusic/providers/all_songs.dart';
import 'package:playmusic/screens/identify.dart';
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
        // appBar: AppBar(
        //   title:  Text(
        //     'Library',
        //     style: TextStyle(
        //       fontSize: Config.textSize(context, 6),
        //       fontWeight: FontWeight.w600,
        //       letterSpacing: .4,
        //     ),
        //   ),
        //   centerTitle: false,
        //   actions: [
        //     CustomButton(
        //       diameter: 12,
        //       child: Icons.settings,
        //       onPressed: () {
        //         Navigator.pushNamed(context, Settings.pageId);
        //       },
        //     ),
        //   ],
        // ),
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
                        left: 20,
                        top: 12,
                        right: 20,
                        bottom: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Library',
                            style: TextStyle(
                              fontSize: Config.textSize(context, 6),
                              fontWeight: FontWeight.w600,
                              letterSpacing: .4,
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
                          // SizedBox(width: 15),
                          CustomButton(
                            diameter: 12,
                            child: Icons.settings,
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
                    // SizedBox(height: Config.yMargin(context, 3)),
                    Consumer<ProviderClass>(
                      builder: (context, provider, child) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              openPlaylist(title: 'All songs');
                            },
                            child: CustomCard(
                              height: 16,
                              width: double.infinity,
                              label: 'All songs',
                              numOfSongs: provider.allSongs.length ?? 0,
                              child: Icons.all_inclusive,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: Config.yMargin(context, 4),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'PlayList',
                        style: TextStyle(
                          fontSize: Config.textSize(context, 4.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Consumer<PlayListDB>(
                      builder: (_, playListDB, child) {
                        return Container(
                          height: Config.yMargin(context, 25),
                          color: Colors.transparent,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            scrollDirection: Axis.horizontal,
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  child: CustomCard2(
                                    height: 16,
                                    width: 16,
                                    label: playListDB.playList[index]['name'],
                                    child: getPlaylistIcon(index),
                                    numOfSongs: songCount,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Recent',
                        style: TextStyle(
                          fontSize: Config.textSize(context, 4.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Consumer<PlayListDB>(
                      builder: (context, playlistDB, child) {
                        return Container(
                          height: Config.yMargin(context, 25),
                          color: Colors.transparent,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            scrollDirection: Axis.horizontal,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  openPlaylist(
                                      title: index == 0
                                          ? 'Recently added'
                                          : 'Recently played');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  child: CustomCard2(
                                    height: 16,
                                    width: 16,
                                    label: index == 0
                                        ? 'Recently added'
                                        : 'Recently played',
                                    child: index == 0
                                        ? Icons.playlist_add
                                        : Icons.playlist_play,
                                  ),
                                ),
                              );
                            },
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
