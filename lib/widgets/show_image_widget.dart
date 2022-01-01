import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tinh/helper/custom_cache_manager.dart';
import 'package:tinh/http/http_get_base_url.dart';

class DisplayImage extends StatefulWidget {
  final BoxFit boxFit;
  final String imageString;
  final double imageBorderRadius;
  const DisplayImage({Key? key, required this.imageString, required this.imageBorderRadius, required this.boxFit}) : super(key: key);

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(widget.imageBorderRadius),
    //     image: DecorationImage(
    //       image: Image.network(baseUrl + widget.imageString).image,
    //       fit: widget.boxFit,
    //     ),
    //   ),
    // );

    return CachedNetworkImage(
      cacheManager: CustomCacheManager(),
      fit: widget.boxFit,
      imageUrl: baseUrl + widget.imageString,
      // placeholder: (context, imageUrl) => Image.asset('assets/images/placeholder.jpg'),
      errorWidget: (context, imageUrl, error) => Image.asset('assets/images/placeholder.jpg'),
    );
  }
}
