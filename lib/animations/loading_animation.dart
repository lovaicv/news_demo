import 'package:flutter/material.dart';
import 'package:news_demo/core/app_color.dart';

class LoadingAnimation extends StatefulWidget {
  final double width;
  final double height;

  const LoadingAnimation({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller2;
  late Animation<double> animation;
  late Animation<double> animation2;
  double progress = 0.0;
  double progress2 = 0.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    controller2 = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addStatusListener((status) {
      })
      ..addListener(() {
        setState(() {
          progress = animation.value;
          if(progress>=0.5) controller2.forward();
          if(progress<=0.5) controller2.reverse();
        });
      });
    controller.forward();
    animation2 = Tween(begin: 0.0, end: 1.0).animate(controller2)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      })
      ..addListener(() {
        setState(() {
          progress2 = animation2.value;
          if (animation2.isCompleted) controller.forward();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(painter: Rectangle(progress, progress2)),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }
}
class Rectangle extends CustomPainter {
  final double _progress;
  final double _progress2;

  Rectangle(this._progress, this._progress2);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(
        Path()
          ..addPolygon([
            Offset(0, _progress2 * (size.height)),
            Offset(size.width, _progress * (size.height)),
            Offset(size.width, (1 - (_progress)) * (size.height)),
            Offset(0, (1 - (_progress2)) * (size.height)),
          ], true),
        paint);
  }

  @override
  bool shouldRepaint(Rectangle oldDelegate) {
    return true;
  }
}
