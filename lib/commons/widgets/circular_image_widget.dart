import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {

  CircularImage(this.url, {Key key}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: new BorderRadius.circular(24.0),
      child: Image.network(url,
        height: 48, width: 48,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
          if (loadingProgress == null)
            return Container(        
            decoration: BoxDecoration(
              shape: BoxShape.circle
            ),
            child: child
          );
          return Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle
            ),
            child: Icon(Icons.person, size: 24)
          );
        }
      )
    );
  }
  
}