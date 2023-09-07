import 'dart:async';

import 'package:flutter/material.dart';

class MyAnimationWidget extends StatefulWidget {
  Widget child;
  int duree;
  MyAnimationWidget({required this.child,required this.duree,super.key});

  @override
  State<MyAnimationWidget> createState() => _MyAnimationWidgetState();
}

class _MyAnimationWidgetState extends State<MyAnimationWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> animationOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
      duration: Duration(milliseconds: 5500)
    );
    CurvedAnimation animationCurved = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    animationOffset = Tween<Offset>(
      begin: Offset(0, 5),
      end: Offset.zero,
    ).animate(animationCurved);

    Timer(Duration(seconds: widget.duree), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: animationOffset,
      child: FadeTransition(
        opacity: _controller,
        child: widget.child,
      ),
    );
  }
}
