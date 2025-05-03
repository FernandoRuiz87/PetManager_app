import 'package:flutter/material.dart';
import 'package:pet_manager_app/models/pet.dart';
import 'package:pet_manager_app/providers/pet_provider.dart';
import 'package:pet_manager_app/widgets/common_widgets.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';
import 'package:pet_manager_app/widgets/pet_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Cargar mascotas una sola vez al iniciar
    Future.microtask(
      () => Provider.of<PetProvider>(context, listen: false).loadPets(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
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
                _buildPetList(petProvider.pets),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(currentIndex: 0),
    );
  }

  Widget _buildPetList(List<Pet> pets) {
    if (pets.isEmpty) {
      return const Text(
        'No hay mascotas registradas',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      );
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
        AddButton(
          onPressed: () {
            Navigator.pushNamed(context, '/newPet');
          },
        ),
      ],
    );
  }
}
