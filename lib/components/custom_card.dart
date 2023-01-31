import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:playmusic/util/config.dart';

class CustomCard extends StatelessWidget {
  CustomCard({
    this.label = "",
    this.numOfSongs = 0,
    this.child,
    required this.icon,
    this.onTap,
  });

  final String label, icon;
  final int numOfSongs;
  final IconData? child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              icon,
              color: Theme.of(context).unselectedWidgetColor.withOpacity(.6),
              height: 22,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$label',
                    style: TextStyle(
                      height: 0,
                      fontSize: Config.textSize(context, 4.2),
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .unselectedWidgetColor
                          .withOpacity(.85),
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/svgs/chevron-right.svg",
                    height: 18,
                    color: Theme.of(context).unselectedWidgetColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard2 extends StatelessWidget {
  CustomCard2(
      {this.width = 0.0,
      this.height = 0.0,
      this.label = "",
      this.numOfSongs = 0,
      required this.child});
  final double width;
  final double height;
  final String label;
  final int numOfSongs;
  final String child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            // height: Config.yMargin(context, height),
            width: Config.yMargin(context, MediaQuery.of(context).size.width),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: Config.xMargin(context, 12),
                    width: Config.xMargin(context, 12),
                    child: Center(
                      child: SvgPicture.asset(
                        child,
                        height: 22,
                        color:
                            Theme.of(context).iconTheme.color!.withOpacity(1),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor.withOpacity(.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: Config.yMargin(context, 1.6)),
                  Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: Config.textSize(context, 4.2),
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .unselectedWidgetColor
                            .withOpacity(.9)),
                  ),
                  SizedBox(height: Config.yMargin(context, .6)),
                  Text(
                    numOfSongs == 1 || numOfSongs == 0
                        ? '$numOfSongs Song'
                        : '$numOfSongs Songs',
                    style: TextStyle(
                      fontSize: Config.textSize(context, 3.2),
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context)
                          .unselectedWidgetColor
                          .withOpacity(.5),
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).unselectedWidgetColor.withOpacity(.1),
              // border: Border.all(
              //     color:
              //         Theme.of(context).unselectedWidgetColor.withOpacity(.2)),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
