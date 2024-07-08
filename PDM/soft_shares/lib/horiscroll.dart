// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
          title: const Text(''),
        ),
        body: const Column(
          children: [
            Expanded(
              flex: 2,
              child: HorizontalListView(area: 'someArea'),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: CustomStarRating(rating: 4), 
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: CustomEuroRating(rating: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalListView extends StatelessWidget {
  final String area;

  const HorizontalListView({required this.area, super.key});

  Future<List<Map<String, dynamic>>> fetchSubAreas(String area) async {
    final response = await http.get(Uri.parse('https://example.com/subArea/listPorArea/$area'));
    var data = jsonDecode(response.body);
    if (data['success']) {
      List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
      return res;
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchSubAreas(area),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum dado disponível'));
          } else {
            final items = snapshot.data!;
            if (items.length < 4) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: items.map((item) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / items.length,
                      child: Column(
                        children: [
                          Image.network(
                            'https://pintbackend-w8pt.onrender.com/images/${item['IMAGEMSUBAREA']}.png',
                            height: 50.0,
                            width: 50.0,
                          ),
                          const SizedBox(height: 8),
                          Text(item['NOME']),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Image.network(
                          'https://pintbackend-w8pt.onrender.com/images/${items[index]['IMAGEMSUBAREA']}.png',
                          height: 50.0,
                          width: 50.0,
                        ),
                        const SizedBox(height: 8),
                        Text(items[index]['NOME']),
                      ],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

class CustomStarRating extends StatelessWidget {
  final double rating;

  const CustomStarRating({required this.rating, super.key});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
      ),
      unratedColor: Colors.grey.withOpacity(0.5),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}

class CustomEuroRating extends StatelessWidget {
  final int rating;

  const CustomEuroRating({required this.rating, super.key});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating.toDouble(),
      minRating: 1,
      direction: Axis.horizontal,
      itemCount: 3,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.euro,
        color: Colors.black,
      ),
      unratedColor: Colors.black.withOpacity(0.3),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}
