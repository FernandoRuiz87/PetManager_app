import 'package:flutter/material.dart';
import 'package:pet_manager_app/models/pet.dart';
import 'package:pet_manager_app/services/local_storage_service.dart';
import 'package:pet_manager_app/widgets/common_widgets.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';
import 'package:pet_manager_app/widgets/pet_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Pet>> _petsFuture; // Future para cargar las mascotas

  // Inicializa el Future en el método initState
  // para que se ejecute una vez al cargar la página
  @override
  void initState() {
    super.initState();
    _petsFuture = LocalStorageService().loadPets();
  }

  @override
  Widget build(BuildContext context) {
    final padding =
        MediaQuery.of(context).padding; // Obtiene el padding de la pantalla

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
                _buildPetCard(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(currentIndex: 0),
    );
  }

  Widget _buildPetCard() {
    return FutureBuilder<List<Pet>>(
      future: _petsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Text('Error al cargar mascotas');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text(
            'No hay mascotas registradas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          );
        } else {
          final pets = snapshot.data!;
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
      },
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
        const Row(
          children: [
            Text(
              'Mis mascotas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ],
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
