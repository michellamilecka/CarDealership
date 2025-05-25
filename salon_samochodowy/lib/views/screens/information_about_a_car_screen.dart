import 'package:flutter/material.dart';
import '../widgets/information_about_a_car_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../classes/car.dart';

class InformationAboutACarScreen extends StatelessWidget{
  final Car car;
  const InformationAboutACarScreen({super.key, required this.car});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: HeaderWidget(),
      ),
      body: Column(
          children: [
            const SizedBox(height: 16),
            InformationAboutACarWidget(car:car),
          ]
      ),
      bottomNavigationBar: FooterWidget(),
    );
  }

}