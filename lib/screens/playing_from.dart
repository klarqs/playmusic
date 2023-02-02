import 'package:flutter/material.dart';
import 'package:playmusic/components/cirecle_disc.dart';
import 'package:playmusic/components/custom_button.dart';
import 'package:playmusic/models/song.dart';
import 'package:playmusic/util/config.dart';
import 'package:playmusic/providers/song_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayingFrom extends StatefulWidget {
  static const String pageId = '/playingFrom';
  @override
  _PlayingFromState createState() => _PlayingFromState();
}

class _PlayingFromState extends State<PlayingFrom> {
  Song? nowPlaying;
  double padding = 10.0;

  @override
  Widget build(BuildContext context) {
    bool isPotrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Consumer<SongController>(
        builder: (context, controller, child) {
          return SafeArea(
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text('Playing From\n${controller.playlistName}',
                    style: TextStyle(
                      fontSize: Config.textSize(context, 5.8),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: isPotrait ? 250 : 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomButton(
                        diameter: 12,
                        icon: "assets/svgs/repeate-one.svg",
                        isToggled: controller.isRepeat,
                        onPressed: () async {
                          controller.settings(repeat: !controller.isRepeat);
                          SharedPreferences.getInstance().then((pref) {
                            pref.setBool('repeat', controller.isRepeat);
                            pref.setBool('shuffle', controller.isShuffled);
                          });
                        },
                      ),
                      isPotrait
                          ? Expanded(
                              child: Padding(
                                padding: controller.useArt
                                    ? EdgeInsets.symmetric(horizontal: 25)
                                    : EdgeInsets.symmetric(horizontal: 10),
                                child: CircleDisc(iconSize: 8),
                              ),
                            )
                          : SizedBox.shrink(),
                      CustomButton(
                        diameter: 12,
                        icon: "assets/svgs/shuffle.svg",
                        isToggled: controller.isShuffled,
                        onPressed: () {
                          controller.settings(shuffle: !controller.isShuffled);
                          SharedPreferences.getInstance().then((pref) {
                            pref.setBool('shuffle', controller.isShuffled);
                            pref.setBool('repeat', controller.isRepeat);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.allSongs!.length,
                    itemBuilder: (context, index) {
                      List<Song> songList = controller.allSongs!;
                      return AnimatedPadding(
                        duration: Duration(milliseconds: 250),
                        padding: controller.nowPlaying!.path ==
                                    songList[index].path &&
                                controller.isPlaying
                            ? EdgeInsets.symmetric(vertical: padding)
                            : EdgeInsets.all(0),
                        child: ListTile(
                          onTap: () async {
                            nowPlaying = songList[index];
                            if (controller.nowPlaying!.path ==
                                nowPlaying!.path) {
                              Navigator.pop(context);
                            } else {
                              await controller
                                  .playlistControlOptions(nowPlaying!);
                            }
                            controller.isPlaying
                                ? padding = 12.0
                                : padding = 12.0;
                          },
                          selected: controller.nowPlaying!.path ==
                              songList[index].path,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          title: Text(
                            songList[index].title!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Config.textSize(context, 3.8),
                              fontWeight: FontWeight.w600,
                              // color:
                              // Theme.of(context).unselectedWidgetColor.withOpacity(.9),
                            ),
                          ),
                          subtitle: Text(
                            songList[index].artist!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Config.textSize(context, 3),
                              fontWeight: FontWeight.w500,
                              height: 1.7,
                              // color:
                              // Theme.of(context).unselectedWidgetColor.withOpacity(.5),
                            ),
                          ),
                          trailing: CustomButton(
                            diameter: 12,
                            isToggled: controller.nowPlaying!.path ==
                                songList[index].path,
                            icon: controller.nowPlaying!.path ==
                                        songList[index].path &&
                                    controller.isPlaying
                                ? "assets/svgs/pause.svg"
                                : "assets/svgs/play.svg",
                            onPressed: () async {
                              nowPlaying = songList[index];
                              await controller
                                  .playlistControlOptions(nowPlaying!);
                              controller.isPlaying
                                  ? padding = 10.0
                                  : padding = 0.0;
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
