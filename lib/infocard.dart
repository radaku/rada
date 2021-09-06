import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({@required this.text, @required this.icon, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Color(0xff195e83),
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontFamily: 'Source Sans Pro',
            ),
          ),
        ),
      ),
    );
  }
}