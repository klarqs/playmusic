import 'package:flutter/material.dart';
import 'package:playmusic/components/create_playList.dart';
import 'package:playmusic/util/config.dart';
import 'package:playmusic/providers/mark_songs.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class PlaylistOptions extends StatelessWidget {
  PlaylistOptions(this.playlistName, this.canDelete);
  final String playlistName;
  final bool canDelete;
  final editingController = TextEditingController();

  List<String> getPaths(MarkSongs marker) {
    List<String> paths = [];
    marker.markedSongs.forEach((element) => paths.add(element.path!));
    return paths;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle customTextStyle = TextStyle(
      fontSize: Config.textSize(context, 4),
      fontWeight: FontWeight.w500,
    );
    return Container(
      height: 64,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: EdgeInsets.only(left: 18, right: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Theme.of(context).iconTheme.color!.withOpacity(.2),
          width: .8,
        ),
      ),
      child: Consumer<MarkSongs>(
        builder: (context, marker, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${marker.markedSongs.length} selected',
                style: customTextStyle,
              ),
              // IconButton(
              //   icon: Icon(Icons.share),
              //   onPressed: () async {
              //     final RenderObject? box = context.findRenderObject();
              //     final paths = getPaths(marker);
              //     await Share.shareFiles(paths,
              //         sharePositionOrigin:
              //             box.localToGlobal(Offset.zero) & box.size);
              //     marker.reset(notify: true);
              //   },
              // ),
              IconButton(
                icon: Icon(Icons.playlist_add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CreatePlayList(
                        songs: marker.markedSongs,
                        createNewPlaylist: false,
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
