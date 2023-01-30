import 'package:flutter/material.dart';
import 'package:playmusic/models/song.dart';
import 'package:playmusic/providers/all_songs.dart';
import 'package:playmusic/util/config.dart';
import 'package:playmusic/providers/song_controller.dart';
import 'package:playmusic/screens/now_playing.dart';
import 'package:provider/provider.dart';

import 'custom_button.dart';


// ignore: must_be_immutable
class LibrarySongControl extends StatelessWidget {
  Song? currentSong;

  void setAllSongs(SongController controller, BuildContext context) {
    controller.allSongs = controller.allSongs == null
        ? Provider.of<ProviderClass>(context, listen: false).allSongs
        : controller.allSongs;
    controller.playlistName =
        controller.playlistName == null ? 'All songs' : controller.playlistName;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongController>(
      builder: (context, controller, child) {
        // if the list or playlist name empty (when the app is opened) use all songs
        setAllSongs(controller, context);
        currentSong = controller.nowPlaying?.path == null
            ? controller.lastPlayed
            : controller.nowPlaying;
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              if (currentSong != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        NowPlaying(currentSong: currentSong),
                  ),
                );
              }
            },
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              color: Theme.of(context).unselectedWidgetColor.withOpacity(.2),
              height: Config.yMargin(context, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: Config.xMargin(context, 40),
                        child: Text(
                          currentSong == null
                              ? 'title'
                              : currentSong!.title!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Config.textSize(context, 4),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Config.yMargin(context, .5),
                      ),
                      SizedBox(
                        width: Config.xMargin(context, 40),
                        child: Text(
                          currentSong == null
                              ? 'artist'
                              : currentSong!.artist!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Config.textSize(context, 3),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    diameter: 12,
                    child: Icons.skip_previous,
                    onPressed: () async {
                      if (currentSong != null) {
                        await controller.skip(prev: true);
                      }
                    },
                  ),
                  CustomButton(
                    diameter: 15,
                    child: controller.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    isToggled: controller.isPlaying,
                    onPressed: () {
                      // if nothing is playing
                      if (controller.nowPlaying?.path == null) {
                        controller.setUp(currentSong!);
                      } else {
                        controller.isPlaying
                            ? controller.pause()
                            : controller.play();
                      }
                    },
                  ),
                  CustomButton(
                    diameter: 12,
                    child: Icons.skip_next,
                    onPressed: () async {
                      if (currentSong != null) {
                        await controller.skip(next: true);
                      }
                    },
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