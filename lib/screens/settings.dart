import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:playmusic/components/custom_button.dart';
import 'package:playmusic/util/themes.dart';
import 'package:playmusic/providers/all_songs.dart';
import 'package:playmusic/util/config.dart';
import 'package:playmusic/providers/playList_database.dart';
import 'package:playmusic/providers/song_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  static const String pageId = '/settings';
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Container buildColoredCircle(Color color) {
    return Container(
      height: Config.yMargin(context, 4),
      width: Config.yMargin(context, 4),
      margin: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        border:
            Border.all(color: Theme.of(context).textTheme.bodyText1!.color!),
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> coloredCircles = [
      buildColoredCircle(Colors.white), //white-ish
      buildColoredCircle(Color(0xFFEBCBDC)), //pink-ish
      buildColoredCircle(Color(0xFFA5C1EB)), //purple-ish
      buildColoredCircle(Color(0xFF011025)), //navy blue-ish
      buildColoredCircle(Color(0xFF282C31)), //gray-ish
      buildColoredCircle(Color(0xFF2A1E21)), //brown-ish
      buildColoredCircle(Color(0xFF1C2C29)), //green-ish
      buildColoredCircle(Color(0xFF1F1F2E)), //dark purple-ish
    ];
    TextStyle listStyle = TextStyle(
      fontSize: Config.textSize(context, 3.8),
      fontWeight: FontWeight.w600,
      color: Theme.of(context).unselectedWidgetColor.withOpacity(.9),
    );
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  top: 16,
                  bottom: 10,
                  right: 18,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      icon: "assets/svgs/chevron-left.svg",
                      diameter: 12,
                      onPressed: () => Navigator.pop(context),
                    ),
                    // SizedBox(
                    //   width: Config.defaultSize(context, 27),
                    // ),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: Config.textSize(context, 4.8),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: CustomButton(
                        icon: "assets/svgs/chevron-left.svg",
                        diameter: 12,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  top: 12,
                  bottom: 12,
                  right: 18,
                ),
                child: Column(
                  children: [
                    Consumer<ProviderClass>(
                      builder: (context, provider, child) {
                        return ListTile(
                          dense: true,
                          leading: SvgPicture.asset(
                            "assets/svgs/brush.svg",
                            color: Theme.of(context)
                                .unselectedWidgetColor
                                .withOpacity(.75),
                          ),
                          title: Text(
                            'Theme',
                            style: listStyle,
                          ),
                          subtitle: Text(
                            'Change the look of the app',
                            style: listStyle.copyWith(
                              fontSize: Config.textSize(context, 3),
                              fontWeight: FontWeight.w500,
                              height: 1.6,
                              color: Theme.of(context)
                                  .unselectedWidgetColor
                                  .withOpacity(.5),
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Select theme', style: listStyle),
                                  content: Container(
                                    height: Config.yMargin(context, 48),
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: coloredCircles.length,
                                      itemBuilder: (context, index) {
                                        return Align(
                                          alignment: Alignment.centerLeft,
                                          child: GestureDetector(
                                            onTap: () {
                                              provider.setTheme(kThemes[index]);
                                              SharedPreferences.getInstance()
                                                  .then((pref) {
                                                pref.setInt('theme', index);
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: coloredCircles[index],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Consumer<SongController>(
                      builder: (context, controller, child) {
                        return ListTile(
                          dense: true,
                          onTap: () {
                            controller.setUseArt(!controller.useArt);
                          },
                          leading: SvgPicture.asset(
                            "assets/svgs/gallery.svg",
                            color: Theme.of(context)
                                .unselectedWidgetColor
                                .withOpacity(.75),
                          ),
                          title: Text(
                            'Use album cover',
                            style: listStyle,
                          ),
                          subtitle: Text(
                            'Show album cover of the song currently playing',
                            style: listStyle.copyWith(
                              fontSize: Config.textSize(context, 3),
                              fontWeight: FontWeight.w500,
                              height: 1.6,
                              color: Theme.of(context)
                                  .unselectedWidgetColor
                                  .withOpacity(.5),
                            ),
                          ),
                          trailing: Checkbox(
                            activeColor: Theme.of(context).accentColor,
                            value: controller.useArt,
                            onChanged: (bool? newValue) {
                              controller.setUseArt(newValue!);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ListTile(
                      dense: true,
                      leading: SvgPicture.asset(
                        "assets/svgs/rotate-right.svg",
                        color: Theme.of(context)
                            .unselectedWidgetColor
                            .withOpacity(.75),
                      ),
                      title: Text(
                        'Reset playlist',
                        style: listStyle,
                      ),
                      subtitle: Text(
                        'Remove all playlist you created',
                        style: listStyle.copyWith(
                          fontSize: Config.textSize(context, 3),
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                          color: Theme.of(context)
                              .unselectedWidgetColor
                              .withOpacity(.5),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    'This would delete the playlist you created.',
                                    style: listStyle),
                                actions: [
                                  TextButton(
                                    // textColor: Theme.of(context).accentColor,
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    // textColor: Theme.of(context).accentColor,
                                    onPressed: () async {
                                      final playlistDB =
                                          Provider.of<PlayListDB>(context,
                                              listen: false);
                                      await playlistDB.clear();
                                      playlistDB.showToast('Done', context);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Continue'),
                                  )
                                ],
                              );
                            });
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    // ListTile(
                    //   leading: Icon(Icons.info_outline),
                    //   title: Text(
                    //     'About',
                    //     style: listStyle,
                    //   ),
                    //   subtitle: Text(
                    //     'About Singr',
                    //     style: listStyle.copyWith(
                    //       fontSize: Config.textSize(context, 3),
                    //       fontWeight: FontWeight.w500,
                    //       height: 1.6,
                    //       color:
                    //           Theme.of(context).unselectedWidgetColor.withOpacity(.5),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     showDialog(
                    //       context: context,
                    //       builder: (context) {
                    //         return AboutDialog(
                    //           applicationName: 'Singr',
                    //           // applicationVersion: '1.0',
                    //           applicationIcon: Container(
                    //             width: Config.xMargin(context, 20),
                    //             height: Config.yMargin(context, 16),
                    //             // child: Image(
                    //             //   image: AssetImage('images/logo.png'),
                    //             //   fit: BoxFit.cover,
                    //             // ),
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   },
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
