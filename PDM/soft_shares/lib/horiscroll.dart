import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soft_shares/database/server.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ListView Horizontal com SVG, Star Rating e Euro Rating'),
        ),
        body: const Column(
          children: [
            Expanded(
              flex: 2,
              child: HorizontalListView(),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: StarRating(rating: 4), // Exemplo de uso do StarRating
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: EuroRating(rating: 2), // Exemplo de uso do EuroRating
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalListView extends StatelessWidget {
  const HorizontalListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        scrollDirection: Axis.horizontal, // Esta linha define a rolagem horizontal
        children: <Widget>[
          Column(
            children: [
              SvgPicture.asset(
                'assets/images/Distritos/CasteloBranco.svg',
                height: 50.0,
                width: 50.0,
              ),
              const SizedBox(height: 8),
              const Text('Home'),
            ],
          ),
          const SizedBox(width: 35), // Espaçamento entre os itens
          Column(
            children: [
              SvgPicture.asset(
                'assets/images/Distritos/CasteloBranco.svg',
                height: 50.0,
                width: 50.0,
              ),
              const SizedBox(height: 8),
              const Text('Star'),
            ],
          ),
          const SizedBox(width: 35), // Espaçamento entre os itens
          Column(
            children: [
              SvgPicture.asset(
                'assets/images/Distritos/CasteloBranco.svg',
                height: 50.0,
                width: 50.0,
              ),
              const SizedBox(height: 8),
              const Text('Settings'),
            ],
          ),
          const SizedBox(width: 35), // Espaçamento entre os itens
          Column(
            children: [
              SvgPicture.asset(
                'assets/images/Distritos/CasteloBranco.svg',
                height: 50.0,
                width: 50.0,
              ),
              const SizedBox(height: 8),
              const Text('Profile'),
            ],
          ),
          const SizedBox(width: 35), // Espaçamento entre os itens
          Column(
            children: [
              SvgPicture.asset(
                'assets/images/Distritos/CasteloBranco.svg',
                height: 50.0,
                width: 50.0,
              ),
              const SizedBox(height: 8),
              const Text('Phone'),
            ],
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;

  const StarRating({required this.rating, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
        );
      }),
    );
  }
}

class EuroRating extends StatelessWidget {
  final int rating;

  const EuroRating({required this.rating, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Icon(
          Icons.euro,
          color: index < rating
              ? Colors.black
              : Colors.black.withOpacity(0.3),
        );
      }),
    );
  }
}
