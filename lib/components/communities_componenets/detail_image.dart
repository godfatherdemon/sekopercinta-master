import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:sekopercinta_master/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta_master/providers/communities.dart';

class DetailImage extends HookWidget {
  final Komunitas post;

  const DetailImage(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return PinchZoom(
      maxScale: 2.5,
      child: Center(
        child: Image.network(
          post.foto.replaceFirst('small/', ''),
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: child,
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(4),
                          child: const Center(
                            child: Icon(
                              Icons.close,
                              color: Colors.black, // Use your preferred color
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: ShimmerCard(
                  height: 202,
                  width: double.infinity,
                  borderRadius: 6,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
