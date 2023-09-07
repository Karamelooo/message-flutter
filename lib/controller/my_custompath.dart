
import 'package:flutter/cupertino.dart';

class MyCustomPath extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Path path = Path();
    path.lineTo(0, size.height * 0.3);
    path.cubicTo(size.width * 0.3, size.height * 0.25, size.width * 0.66, size.height *0.4, size.width, size.height *0.3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}