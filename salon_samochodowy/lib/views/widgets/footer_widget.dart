import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 50, // Minimalna wysokość stopki
          maxHeight: 50, // Maksymalna wysokość stopki
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Biała linia
            Container(
              height: 2, // Grubość linii
              color: Colors.white, // Kolor linii
            ),
          ],
        ),
      ),
    );
  }
}
