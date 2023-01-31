import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:playmusic/util/config.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    this.diameter = 0.0,
    this.onPressed,
    this.child,
    this.isToggled = false,
    this.icon = "assets/svgs/setting-2.svg",
  });
  final double diameter;
  final IconData? child;
  final void Function()? onPressed;
  final bool isToggled;
  final String icon;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.3,
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller!.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller!.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onPressed,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          child: Transform.scale(
            scale: 1 - _controller!.value,
            child: Container(
              height: Config.xMargin(context, 12),
              width: Config.xMargin(context, 12),
              child: Center(
                child: SvgPicture.asset(
                  widget.icon!,
                  height: 22,
                  color: Theme.of(context).iconTheme.color!.withOpacity(1),
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).iconTheme.color!.withOpacity(.2),
                  width: .8,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomButton2 extends StatefulWidget {
  CustomButton2({
    this.diameter = 0.0,
    this.onPressed,
    this.child,
    this.isToggled = false,
    this.icon = "assets/svgs/setting-2.svg",
  });
  final double diameter;
  final IconData? child;
  final void Function()? onPressed;
  final bool isToggled;
  final String icon;

  @override
  _CustomButton2State createState() => _CustomButton2State();
}

class _CustomButton2State extends State<CustomButton2>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.3,
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller!.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller!.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onPressed,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          child: Transform.scale(
            scale: 1 - _controller!.value,
            child: Center(
              child: SvgPicture.asset(
                widget.icon!,
                height: 22,
                color: Theme.of(context).iconTheme.color!.withOpacity(1),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomButton3 extends StatefulWidget {
  CustomButton3({
    this.diameter = 0.0,
    this.onPressed,
    this.child,
    this.isToggled = false,
    this.icon = "assets/svgs/setting-2.svg",
  });
  final double diameter;
  final IconData? child;
  final void Function()? onPressed;
  final bool isToggled;
  final String icon;

  @override
  _CustomButton3State createState() => _CustomButton3State();
}

class _CustomButton3State extends State<CustomButton3>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.3,
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller!.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller!.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onPressed,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          child: Transform.scale(
            scale: 1 - _controller!.value,
            child: Container(
              height: Config.xMargin(context, 12),
              width: Config.xMargin(context, 12),
              child: Center(
                child: SvgPicture.asset(
                  widget.icon!,
                  height: 22,
                  color: Theme.of(context).iconTheme.color!.withOpacity(1),
                ),
              ),
              decoration: BoxDecoration(

                color:  Theme.of(context).backgroundColor.withOpacity(.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
