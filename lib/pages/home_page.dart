import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // To load assets
import 'package:pet_manager/widgets/buttons.dart';
import 'package:pet_manager/widgets/pet_card.dart';
import 'package:pet_manager/models/pet.dart'; // Import Pet model

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pet> pets = [];

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/pets.json',
      );

      final List<dynamic> data = json.decode(response);

      setState(() {
        pets = data.map((json) => Pet.fromJson(json)).toList();
      });
    } catch (e) {
      // Handle errors gracefully
      debugPrint('Error loading pets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(title: const Text('PetManager')),
      body: Padding(
        padding: EdgeInsets.only(
          left: padding.left,
          right: padding.right,
          bottom: padding.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ActionSeparator(),
                const SizedBox(height: 15),
                _buildPetList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetList() {
    if (pets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children:
          pets
              .map(
                (pet) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PetCard(pet: pet),
                ),
              )
              .toList(),
    );
  }
}

class ActionSeparator extends StatelessWidget {
  const ActionSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Mis mascotas',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        GenericButton(
          icon: Icons.add,
          text: 'Añadir',
          onPressed: () {
            Navigator.pushNamed(context, '/newPet');
          },
        ),
      ],
    );
  }
}
