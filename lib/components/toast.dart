import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:playmusic/util/config.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final bool isSuccessMsg;
  CustomToast(this.message, this.isSuccessMsg);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: isSuccessMsg
            ? Colors.green.withOpacity(.85)
            : Colors.red.withOpacity(.85),
      ),
      child: Wrap(
        children: [
          if (isSuccessMsg)
            SvgPicture.asset(
              "assets/svgs/check.svg",
              color: Colors.white,
            ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            message,
            softWrap: true,
            maxLines: 2,
            style: TextStyle(
              fontSize: Config.textSize(context, 4),
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
