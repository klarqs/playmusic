import 'dart:async';

import 'package:flutter/material.dart';
import 'package:playmusic/components/now_playing_display.dart';
import 'package:playmusic/components/create_playList.dart';
import 'package:playmusic/components/custom_button.dart';
import 'package:playmusic/models/song.dart';
import 'package:playmusic/util/config.dart';
import 'package:playmusic/providers/playList_database.dart';
import 'package:playmusic/screens/playing_from.dart';
import 'package:playmusic/providers/song_controller.dart';
import 'package:provider/provider.dart';

class NowPlaying extends StatefulWidget {
  static const String pageId = '/nowPlaying';
  final Song? currentSong;
  NowPlaying({this.currentSong});
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  dynamic nowPlaying;
  SongController? player;

  Future<void> setUp() async {
    player = Provider.of<SongController>(context, listen: false);
    // if no song is beign played
    if (player!.nowPlaying?.path == null) {
      await player!.setUp(widget.currentSong!);
      // if a different song was selected
    } else if (player!.nowPlaying?.path != widget.currentSong!.path) {
      player!.disposePlayer();
      nowPlaying = widget.currentSong;
      await player!.setUp(nowPlaying);
    }
  }

  @override
  void initState() {
    setUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isPotrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Consumer<SongController>(
      builder: (context, controller, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomButton(
                          diameter: 12,
                          icon: 'assets/svgs/chevron-left.svg',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Now Playing',
                          style: TextStyle(
                            fontSize: Config.textSize(context, 5.2),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        CustomButton(
                          diameter: 12,
                          icon: 'assets/svgs/list.svg',
                          onPressed: () async {
                            Navigator.pushNamed(context, PlayingFrom.pageId);
                          },
                        ),
                      ],
                    ),
                  ),
                  isPotrait
                      ? Expanded(
                          child: NowPlayingDisplay(),
                        )
                      : SizedBox(
                          height: Config.xMargin(context, 2),
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: Config.xMargin(context, 6),
                        ),
                        Text(
                          controller.nowPlaying!.title ?? '',
                          style: TextStyle(
                            fontSize: Config.textSize(context, 4.2),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: Config.xMargin(context, 2),
                        ),
                        Opacity(
                          opacity: .65,
                          child: Text(
                            controller.nowPlaying!.artist ?? '',
                            style: TextStyle(
                              fontSize: Config.textSize(context, 3.4),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomButton(
                              diameter: 12,
                              icon: controller.isFavourite
                                  ? "assets/svgs/heart-.svg"
                                  : "assets/svgs/heart.svg",
                              isToggled: controller.isFavourite,
                              onPressed: () async {
                                controller.isFavourite
                                    ? await Provider.of<PlayListDB>(context,
                                            listen: false)
                                        .removeFromPlaylist('Favourites',
                                            controller.nowPlaying!)
                                    : await Provider.of<PlayListDB>(context,
                                            listen: false)
                                        .addToPlaylist('Favourites',
                                            controller.nowPlaying!);
                                controller.setFavourite(controller.nowPlaying!);
                              },
                            ),
                            CustomButton(
                              diameter: 12,
                              icon: "assets/svgs/plus.svg",
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CreatePlayList(
                                      createNewPlaylist: false,
                                      songs: [controller.nowPlaying],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Config.xMargin(context, 6),
                        ),
                        controller.duration != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      controller.timePlayed,
                                      style: TextStyle(
                                        fontSize: Config.textSize(context, 3),
                                      ),
                                    ),
                                    Text(
                                      controller.timeLeft,
                                      style: TextStyle(
                                        fontSize: Config.textSize(context, 3),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink(),
                        controller.duration != null
                            ? Slider(
                                min: 0.0,
                                max: controller.duration!.inSeconds.toDouble(),
                                value: controller.currentTime.toDouble(),
                                onChanged: (double newValue) async {
                                  double position =
                                      newValue - controller.currentTime;
                                  await controller.seek(position.toInt());
                                },
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: Config.xMargin(context, 2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CustomButton(
                              diameter: 12,
                              icon: 'assets/svgs/previous.svg',
                              onPressed: () async {
                                await controller.skip(prev: true);
                              },
                            ),
                            CustomButton(
                              diameter: 15,
                              icon: 'assets/svgs/backward-10-seconds.svg',
                              onPressed: () async {
                                // if it hasnt played upto 10 seconds
                                if (controller.currentTime.toDouble() < 10) {
                                  await controller
                                      .seek(-controller.currentTime);
                                } else {
                                  await controller.seek(-10);
                                }
                              },
                            ),
                            CustomButton(
                              diameter: 18,
                              icon: controller.isPlaying
                                  ? 'assets/svgs/pause.svg'
                                  : 'assets/svgs/play.svg',
                              isToggled: controller.isPlaying,
                              onPressed: () {
                                controller.isPlaying
                                    ? controller.pause()
                                    : controller.play();
                              },
                            ),
                            CustomButton(
                              diameter: 15,
                              icon: 'assets/svgs/forward-10-seconds.svg',
                              onPressed: () async {
                                controller.seek(10);
                              },
                            ),
                            CustomButton(
                              diameter: 12,
                              icon: 'assets/svgs/next.svg',
                              onPressed: () async {
                                await controller.skip(next: true);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
