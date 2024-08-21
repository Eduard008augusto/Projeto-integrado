import 'package:flutter/material.dart';
import './database/server.dart';

// ignore: use_key_in_widget_constructors
class LikeButton extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false; 

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            size: 16.0,
            color: const Color.fromARGB(255, 57, 99, 156),
          ),
          padding: const EdgeInsets.all(0),
          constraints: const BoxConstraints(), 
          onPressed: () {
            setState(() {
              _isLiked = !_isLiked; 
            });
          },
        ),
        /*SizedBox(width: 5),
        Text(
          '${_isLiked ? 1 : 0}', 
          style: TextStyle(
            color: _isLiked
                ? Color.fromARGB(255, 57, 99, 156) 
                : Colors.black,
          ),
        ),*/
      ],
    );
  }
}
