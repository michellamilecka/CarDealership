import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:salon_samochodowy/views/screens/information_about_a_car_screen.dart';
import 'package:salon_samochodowy/views/screens/list_of_clients_and_sales_screen.dart';
import '../screens/client_form_screen.dart';
import '../classes/car.dart';

class InformationAboutACarWidget extends StatefulWidget {
  final Car car;

  const InformationAboutACarWidget({super.key, required this.car});
  @override
  _InformationAboutACarWidgetState createState() => _InformationAboutACarWidgetState();
}

class _InformationAboutACarWidgetState extends State<InformationAboutACarWidget> {
  bool _isEditing = false;

  late TextEditingController _priceController ;
  late TextEditingController _nameController ;
  late TextEditingController _colorController ;
  late TextEditingController _modelController ;
  late TextEditingController _bodyTypeController ;
  late TextEditingController _driveTypeController ;
  //late TextEditingController _fuelTypeController ;
  late TextEditingController _transmissionController ;
  //late TextEditingController _powerController ;
  late TextEditingController _descriptionController ;
  late TextEditingController _accelerationController ;
  late TextEditingController _topSpeedController ;
  late TextEditingController _gasMileageController ;
  late TextEditingController _vinNumberController ;
  late TextEditingController _productionYearController ;
  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: '${widget.car.price} PLN');
    _colorController = TextEditingController(text: '${widget.car.color}');
    _modelController = TextEditingController(text: '${widget.car.model}');
    _bodyTypeController = TextEditingController(text: '${widget.car.bodyType}');
    _driveTypeController = TextEditingController(text: '${widget.car.drivetrainType}');
    //_fuelTypeController = TextEditingController(text: '${widget.car.}');
    _transmissionController = TextEditingController(text: '${widget.car.transmission}');
    //_powerController = TextEditingController(text: '${widget.car.power}');
    _descriptionController = TextEditingController(text: '${widget.car.description}');
    _nameController = TextEditingController(text: '${widget.car.name}');
    _accelerationController = TextEditingController(text: '${widget.car.acceleration} s');
    _topSpeedController = TextEditingController(text: '${widget.car.topSpeed} km/h');
    _gasMileageController = TextEditingController(text: '${widget.car.gasMileage} l');
    _vinNumberController = TextEditingController(text: '${widget.car.vinNumber}');
    _productionYearController = TextEditingController(text: '${widget.car.productionYear}');
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 0.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(!_isEditing)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListOfClientsAndSalesScreen(title: 'ListOfClientsAndSales')),
                    );
                  },
                  child: Icon(
                    Icons.monetization_on, // Ikona sprzedaży
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:15.0,left:15.0),
                  child: Text(
                    _nameController.text,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  child: Iconify(
                    _isEditing ? Mdi.check : Mdi.pencil,
                    size: 20,
                    color: Colors.blue,
                  ),

                ),
                 // Odstęp między ikonami

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0,bottom: 20.0,left:2.0),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,


                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        'assets/star.png',
                        height: 170.0,
                        width: 230.0,
                        fit: BoxFit.cover,
                      ),
                    ),

                  ),
                  SizedBox(width: 16.0),
                  Container(
                    alignment: Alignment.center,
                    height: 280,
                    width: 150,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: _isEditing
                                ? TextField(
                              controller: _descriptionController,
                              style: TextStyle(fontSize: 12.0, color: Colors.black),
                              maxLines: null,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8.0),
                              ),
                            )
                                : Text(
                              _descriptionController.text,
                              style: TextStyle(fontSize: 12.0, color: Colors.black),
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Text(
                      'PARAMETRY',
                      style:TextStyle(
                          fontSize: 20.0,
                          color:Colors.black,
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
                Iconify(
                  Mdi.wrench,
                  size: 20,
                  color: Colors.black,
                ),
              ],
            ),
            Container(
                alignment: Alignment.center,

                height:300,
                width:350,
                child:Column(
                    children:[
                      Expanded(child:
                      ListView(
                          scrollDirection:Axis.vertical ,
                          children:[
                            Padding(
                              padding: const EdgeInsets.only(top:0.0),
                              child: Container(
                                  width:350,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Text(
                                              'Nazwa',
                                              style:TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: _isEditing
                                              ? SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _nameController,
                                              style: TextStyle(fontSize: 15.0),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            _nameController.text,
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),

                                      ]
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                  width:350,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Text(
                                              'Model',
                                              style:TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: _isEditing
                                              ? SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _modelController,
                                              style: TextStyle(fontSize: 15.0),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            _modelController.text,
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),

                                      ]
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                  width:350,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Text(
                                              'Cena',
                                              style:TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: _isEditing
                                              ? SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _priceController,
                                              style: TextStyle(fontSize: 15.0),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            _priceController.text,
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),

                                      ]
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                  width:350,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Text(
                                              'Rodzaj nadwozia',
                                              style:TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: _isEditing
                                              ? SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _bodyTypeController,
                                              style: TextStyle(fontSize: 15.0),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            _bodyTypeController.text,
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),

                                      ]
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                  width:350,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Text(
                                              'Rodzaj napędu',
                                              style:TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: _isEditing
                                              ? SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _driveTypeController,
                                              style: TextStyle(fontSize: 15.0),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            _driveTypeController.text,
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),

                                      ]
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                  width:350,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Text(
                                              'Przyspieszenie',
                                              style:TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: _isEditing
                                              ? SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _accelerationController,
                                              style: TextStyle(fontSize: 15.0),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            _accelerationController.text,
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),

                                      ]
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                  width:350,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Text(
                                              'Skrzynia biegów',
                                              style:TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: _isEditing
                                              ? SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _transmissionController,
                                              style: TextStyle(fontSize: 15.0),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            _transmissionController.text,
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),

                                      ]
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                  width:350,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Text(
                                              'Kolor',
                                              style:TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: _isEditing
                                              ? SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _colorController,
                                              style: TextStyle(fontSize: 15.0),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            _colorController.text,
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),

                                      ]
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                  width:350,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Text(
                                              'Predkosc maksymalna',
                                              style:TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: _isEditing
                                              ? SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _topSpeedController,
                                              style: TextStyle(fontSize: 15.0),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            _topSpeedController.text,
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),

                                      ]
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                  width:350,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Text(
                                              'Zużycie paliwa',
                                              style:TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: _isEditing
                                              ? SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _gasMileageController,
                                              style: TextStyle(fontSize: 15.0),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            _gasMileageController.text,
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),

                                      ]
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                  width:350,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Text(
                                              'Numer VIN',
                                              style:TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: _isEditing
                                              ? SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _vinNumberController,
                                              style: TextStyle(fontSize: 15.0),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            _vinNumberController.text,
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),

                                      ]
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                  width:350,
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Text(
                                              'Rok produkcji',
                                              style:TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: _isEditing
                                              ? SizedBox(
                                            width: 150,
                                            child: TextField(
                                              controller: _productionYearController,
                                              style: TextStyle(fontSize: 15.0),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            _productionYearController.text,
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),

                                      ]
                                  )
                              ),
                            ),
                          ]
                      ))
                    ]
                )
            ),

          ],
        ),
      ),
    );
  }

}