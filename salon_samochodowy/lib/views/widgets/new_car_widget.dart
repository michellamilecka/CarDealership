import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewCarsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 639,
      height: 401,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 239,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 13.83,
                    left: 4.69,
                    child: SvgPicture.asset(
                      'assets/images/vector.svg',
                      semanticsLabel: 'vector',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            child: Text(
              'Nowe samochody',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Inter',
                fontSize: 72,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
          Positioned(
            top: 277,
            left: 126,
            child: Container(
              width: 355,
              height: 124,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 355,
                      height: 124,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(180),
                          topRight: Radius.circular(180),
                          bottomLeft: Radius.circular(180),
                          bottomRight: Radius.circular(180),
                        ),
                        color: Color.fromRGBO(217, 217, 217, 1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 33,
                    left: 64,
                    child: Text(
                      'Wyszukaj',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 48,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}