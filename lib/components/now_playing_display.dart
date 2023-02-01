import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:playmusic/util/config.dart';
import 'package:playmusic/providers/song_controller.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'cirecle_disc.dart';

class NowPlayingDisplay extends StatefulWidget {
  @override
  _NowPlayingDisplay createState() => _NowPlayingDisplay();
}

class _NowPlayingDisplay extends State<NowPlayingDisplay> {
  bool _isLoading = false;
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    TextStyle customTextStyle = TextStyle(
      fontSize: Config.textSize(context, 3.5),
      fontWeight: FontWeight.w500,
    );
    return Consumer<SongController>(
      builder: (context, controller, child) {
        List<Widget> display = [
          controller.useArt
              ? Container(
                  margin: EdgeInsets.only(
                    top: 48,
                    left: 18,
                    right: 18,
                    // bottom: 48,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: controller.songArt == null
                      ? CircleDisc(iconSize: 16)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.memory(
                            controller.songArt,
                            fit: BoxFit.cover,
                          ),
                        ),
                )
              : CircleDisc(iconSize: 16),
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .12,
                  vertical: 12,
                ),
                margin: EdgeInsets.only(
                  top: 48,
                  left: 18,
                  right: 18,
                  // bottom: 48,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .color!
                      .withOpacity(.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: controller.lyrics.isEmpty
                    ? Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            onSurface: Colors.transparent,
                            surfaceTintColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context).primaryColor)
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(18)),
                                  child: Text(
                                    'Get lyrics'.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: Config.textSize(context, 3),
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: .2,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await controller.getLyrics(context);
                            } catch (err) {
                              print(err);
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                        ),
                      )
                    : ListWheelScrollView(
                        itemExtent: 50,
                        children: controller.lyrics
                            .map(
                              (eachLine) => Text(
                                eachLine,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Config.textSize(context, 4),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: .2,
                                  height: 1.4,
                                ),
                              ),
                            )
                            .toList(),
                        diameterRatio: 10,
                      ),
              ),
              // if (controller.lyrics.isNotEmpty) ...[
              //   Positioned(
              //     bottom: 24,
              //     right: 24,
              //     child: IconButton(
              //       icon: SvgPicture.asset("assets/svgs/download.svg",
              //           color:
              //               Theme.of(context).iconTheme.color!.withOpacity(1)),
              //       onPressed: () async => await controller.manageLyrics(
              //         context: context,
              //         delete: false,
              //       ),
              //     ),
              //   ),
              //   Positioned(
              //     bottom: 24,
              //     left: 24,
              //     child: IconButton(
              //       icon: SvgPicture.asset("assets/svgs/trash.svg",
              //           color:
              //               Theme.of(context).iconTheme.color!.withOpacity(1)),
              //       onPressed: () {
              //         showDialog(
              //           context: context,
              //           builder: (context) {
              //             return AlertDialog(
              //               title: Text(
              //                 'Delete lyrics for "${controller.nowPlaying?.title}"?',
              //                 style: customTextStyle,
              //               ),
              //               actions: [
              //                 TextButton(
              //                   // textColor: Theme.of(context).accentColor,
              //                   onPressed: () => Navigator.pop(context),
              //                   child: Text(
              //                     'No',
              //                   ),
              //                 ),
              //                 TextButton(
              //                   // textColor: Theme.of(context).accentColor,
              //                   onPressed: () async {
              //                     await controller.manageLyrics(
              //                       context: context,
              //                       delete: true,
              //                     );
              //                     Navigator.pop(context);
              //                   },
              //                   child: Text(
              //                     'Yes',
              //                   ),
              //                 ),
              //               ],
              //             );
              //           },
              //         );
              //       },
              //     ),
              //   )
              // ]
            ],
          ),
        ];
        return Container(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  children: display,
                  onPageChanged: (int newIndex) {
                    setState(() {
                      _pageIndex = newIndex;
                    });
                  },
                ),
              ),
              SizedBox(height: 18),
              AnimatedSmoothIndicator(
                count: display.length,
                activeIndex: _pageIndex,
                effect: WormEffect(
                    dotWidth: 6,
                    dotHeight: 6,
                    spacing: 10,
                    activeDotColor: Theme.of(context).accentColor),
              ),
            ],
          ),
        );
      },
    );
  }
}
