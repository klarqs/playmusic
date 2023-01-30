import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:playmusic/util/config.dart';

class CustomCard extends StatelessWidget {
  CustomCard(
      {this.width = 0.0,
      this.height = 0.0,
      this.label = "",
      this.numOfSongs = 0,
      this.child});
  final double width;
  final double height;
  final String label;
  final int numOfSongs;
  final IconData? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Config.xMargin(context, 30),
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: Config.textSize(context, 4.5),
              fontWeight: FontWeight.w500,
              // letterSpacing: .2,
            ),
          ),
        ),
        SizedBox(height: Config.yMargin(context, 1.5)),
        Container(
          height: Config.yMargin(context, height),
          width: Config.yMargin(context, height),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    numOfSongs != null
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '$numOfSongs',
                                style: TextStyle(
                                  fontSize: Config.textSize(context, 8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ' Songs',
                                style: TextStyle(
                                  fontSize: Config.textSize(context, 3),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).unselectedWidgetColor.withOpacity(.1),
            border: Border.all(
                color: Theme.of(context).unselectedWidgetColor.withOpacity(.2)),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ],
    );
  }
}

class CustomCard2 extends StatelessWidget {
  CustomCard2(
      {this.width = 0.0,
      this.height = 0.0,
      this.label = "",
      this.numOfSongs = 0,
      this.child});
  final double width;
  final double height;
  final String label;
  final int numOfSongs;
  final IconData? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: Config.yMargin(context, height),
          width: Config.yMargin(context, height),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: Config.xMargin(context, 12),
                      width: Config.xMargin(context, 12),
                      child: FaIcon(
                        child,
                        size: Config.textSize(context, 6),
                        color:
                            Theme.of(context).iconTheme.color!.withOpacity(1),
                      ),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).backgroundColor.withOpacity(.8),
                        shape: BoxShape.circle,
                        // boxShadow: <BoxShadow>[
                        //   BoxShadow(
                        //     color: Theme.of(context).splashColor,
                        //     offset: Offset(3, 3),
                        //     blurRadius: 5,
                        //     spreadRadius: 1.0,
                        //   ),
                        //   BoxShadow(
                        //     color: Theme.of(context).backgroundColor,
                        //     offset: Offset(-3, -3),
                        //     blurRadius: 5,
                        //     spreadRadius: 1.0,
                        //   ),
                        // ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).unselectedWidgetColor.withOpacity(.1),
            border: Border.all(
                color: Theme.of(context).unselectedWidgetColor.withOpacity(.2)),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        SizedBox(height: Config.yMargin(context, 1)),
        SizedBox(
          width: Config.xMargin(context, 30),
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: Config.textSize(context, 3.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: Config.yMargin(context, .2)),
        numOfSongs != null
            ? Text(
                '$numOfSongs songs',
                style: TextStyle(
                    fontSize: Config.textSize(context, 3.5),
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context)
                        .unselectedWidgetColor
                        .withOpacity(.5)),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
