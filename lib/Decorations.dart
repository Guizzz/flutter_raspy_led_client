import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Decorations
{

  static Color backgroundColor = Color(0xFFF4F5F0);
  static Color textColor = Color(0xFF46B2FA);
  static Color blueColor = Color(0xFF46B2FA);
  static Color valueColor = Color(0xFF444444);
  static Color backButtonColor = Color(0xFF7C7C7C);
  static Color iconColor = Color(0xFF65C1FF);
  static Color buttonColor = Color(0xFF27A9FF);

  static BoxShadow shadow()
  {
    return
      BoxShadow(
        color: Color(0xFF000000).withOpacity(0.4),
        blurRadius: 4,
        offset: Offset(0, 3), // changes position of shadow
      );

  }

  BoxDecoration selectedBoxDeco()
  {
    return BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        border: Border.all(
            color: Colors.lightBlue,
            width: 4
        ),
        color: Colors.white,
        boxShadow: [Decorations.shadow()]
    );
  }
}