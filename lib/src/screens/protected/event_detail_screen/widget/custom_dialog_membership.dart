import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          height: 400,
          child: Stack(
            children: [
              // Background container
                Positioned(
                left: 0,
                top: 0,
                child: Container(
                  // width: 330,
                  // height: 355,
                  decoration: BoxDecoration(
                    // color: Colors.white.withAlpha((255 * 0.17).toInt()),
                    borderRadius: BorderRadius.circular(5.23),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.23),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        color: Colors.white.withAlpha((255 * 0.1).toInt()), // To ensure the blur is applied
                      ),
                    ),
                  ),
                ),
              ),
              // Icon or image in the middle (optional)
              Positioned(
                left: 133.99,
                top: 41.87,
                child: Container(
                  width: 62.81,
                  height: 62.81,
                  decoration: BoxDecoration(
                    
                  ),
                  child: SvgPicture.asset("lib/assets/icons/Frame.svg"),
                ),
              ),
              // "Please Upgrade your membership" text
              Positioned(
                left: 35,
                top: 126.76,
                child: Text(
                  'Please Upgrade your membership',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.27,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                  ),
                ),
              ),
              // "Currently on" text
              Positioned(
                left: 35,
                top: 185,
                child: Text(
                  'Currently on',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.65,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              // "Basic membership" text
              Positioned(
                left: 166,
                top: 185,
                child: Text(
                  'Basic membership',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.65,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // "Gold Membership" text
              // Positioned(
              //   left: 119.64,
              //   top: 260.05,
              //   child: 
              // ),
              // "GO TO MEMBERSHIP PAGE" text
              Positioned(
                left: 79,
                top: 311.94,
                child: Text(
                  'GO TO MEMBERSHIP PAGE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.56,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Membership required text
              Positioned(
                left: 47.39,
                top: 232,
                child: SizedBox(
                  width: 236.85,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Membership Required',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.65,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("lib/assets/icons/material-symbols_date-range.svg"),
                      Text(
                        'Gold Membership',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.65,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                                    ),
                      ],
                    ),
                  ),
                ),
              ),
              // Border around "Currently on" and "Gold Membership"
              Positioned(
                left: 23,
                top: 165.39,
                child: Container(
                  width: 284.72,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.52,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: const Color(0xFFF7D99A),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 23,
                top: 216.68,
                child: Container(
                  width: 284.72,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.52,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: const Color(0xFFF7D99A),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 23,
                top: 296.24,
                child: Container(
                  width: 284.72,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.52,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: const Color(0xFFF7D99A),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
