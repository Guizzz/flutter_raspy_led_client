
import 'package:flutter/material.dart';


class AnimationTransaction
{
  BuildContext context;

  AnimationTransaction({required this.context});

  slideUpAnimation(Widget box, double bottomPointStart, double leftPointStart, double topPointStop)
  {
    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (context, anim1, anim2) { return Container();},
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 350),
      transitionBuilder: (context, anim1, anim2, child) {
        return new Stack(
          children: <Widget>[
            Positioned(
              top: bottomPointStart,
              left: leftPointStart,
              child: Transform.translate(
                offset:Offset(0,-anim1.value * topPointStop),
                child: box,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ignore: must_be_immutable
class ButtonClikAnimation extends StatefulWidget
{
  Widget? _box;
  var _function;

  ButtonClikAnimation({required Widget child, var onTap} )
  {
    this._box = child;
    this._function = onTap;
  }

  @override
  ButtonClikAnimationState createState() => ButtonClikAnimationState(_box, _function);

}

class ButtonClikAnimationState extends State<ButtonClikAnimation> with SingleTickerProviderStateMixin
{
  Widget? box;
  var function;

  AnimationController? _animationController;

  ButtonClikAnimationState(this.box,  this.function);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 50),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _animationController?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context)
  {
    double scale = 1 - _animationController!.value;
    return GestureDetector(
      onTap: ()
      {
        _animationController!.forward().then((value) => _animationController!.reverse()).then((value) => function());
      },
      child: Transform.scale(
        scale: scale,
        child: widget._box,
      ),
    );
  }
}