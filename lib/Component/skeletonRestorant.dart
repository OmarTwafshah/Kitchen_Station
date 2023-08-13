import 'package:flutter/material.dart';

class SkeletonRest extends StatelessWidget {
  const SkeletonRest({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double height =
        screenSize.width < 400 ? 200 : (screenSize.aspectRatio * 200) + 100;
    return Container(
      width: height * 0.65,
      height: height,
      margin: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 5,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            6,
          ),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: Colors.grey,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              height: height / 1.5,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    5,
                  ),
                ),
              ),
              child: designPattern(
                height: height / 1.5,
                width: double.infinity,
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: designPattern(
                  height: 11,
                  width: 60,
                ),
              ),
            ],
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  Container designPattern({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(
            5,
          ),
        ),
      ),
    );
  }
}
