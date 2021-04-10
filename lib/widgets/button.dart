import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({@required this.child, @required this.onPressed});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Color(0xFFE17262)),
            backgroundColor: Color(0xFFE17262),
            primary: Colors.white,
            textStyle: TextStyle(
              fontFamily: 'mali',
              fontWeight: FontWeight.bold,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 30
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),
        onPressed: onPressed,
        child: child,
      );
}
