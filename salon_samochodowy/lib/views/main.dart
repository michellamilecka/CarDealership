import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/simple_icons.dart';
import 'screens/home_screen.dart';
import 'screens/new_cars_screen.dart';
import 'screens/used_cars_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMW',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BMW'),
      debugShowCheckedModeBanner: false,
      routes: {
        '/new_cars': (context) => const NewCarsScreen(title: 'New Cars'), // Dodana trasa
        '/usedCars': (context) => UsedCarsScreen(title: 'Used Cars',), // Dodaj tę linię
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final PageController controller = PageController(initialPage: 0);

  // Funkcja do przełączania ekranów
  void _onItemTapped(int index) {
    controller.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
    setState(() {
      _selectedIndex = index;
    });
  }

  // Funkcja reagująca na zmianę strony
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nagłówek (AppBar)
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 400,
              height: 1, // Grubość linii
              color: Colors.white, // Kolor linii
            ),
          ],
        ),
        actions: [
          Iconify(
            SimpleIcons.bmw,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(width: 6),
        ],
      ),

      // Zawartość ekranu (body) z PageView
      body: SafeArea(
        child: PageView(
          controller: controller,
          onPageChanged: _onPageChanged,
          children: [
            const HomeScreen(title: 'BMW'),
            const NewCarsScreen(title: 'nowe samochody'),
            const UsedCarsScreen(title: 'używane samochody'),
          ],
        ),
      ),


      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home Page',
          ),
          BottomNavigationBarItem(
            icon: Iconify(Ph.car_simple_bold),
            label: 'New Cars',
          ),
          BottomNavigationBarItem(
            icon: Iconify(Ph.car_simple_bold),
            label: 'Used Cars',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
