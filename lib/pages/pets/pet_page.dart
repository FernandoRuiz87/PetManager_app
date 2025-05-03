import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/models/pet.dart';
import 'package:pet_manager_app/models/shower.dart';
import 'package:pet_manager_app/pages/feeding_settings_page.dart';
import 'package:pet_manager_app/pages/pets/edit_pet_info.dart';
import 'package:pet_manager_app/pages/vaccines/new_vaccine_page.dart';
import 'package:pet_manager_app/providers/pet_provider.dart';
import 'package:pet_manager_app/widgets/common_widgets.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';
import 'package:pet_manager_app/widgets/feed_card.dart';
import 'package:pet_manager_app/widgets/shower_card.dart';
import 'package:pet_manager_app/widgets/vaccine_card.dart';
import 'package:provider/provider.dart';

class PetPage extends StatelessWidget {
  const PetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Pet pet = ModalRoute.of(context)!.settings.arguments as Pet;
    final petProvider = Provider.of<PetProvider>(context);
    final padding = MediaQuery.of(context).padding;

    // Obtener la versión actualizada de la mascota del provider
    final currentPet = petProvider.pets.firstWhere(
      (p) => p.id == pet.id,
      orElse: () => pet,
    );

    // Cargar datos de alimentación al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      petProvider.loadFeeding(pet.id);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(currentPet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => petProvider.loadPets(),
            tooltip: 'Actualizar datos',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: padding.left,
          right: padding.right,
          bottom: padding.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: PetPicture(size: 75, imagePath: currentPet.photoUrl),
                ),
                const SizedBox(height: 20),
                _PetNameSection(pet: currentPet),
                const SizedBox(height: 20),
                _ActionButtons(pet: currentPet, petProvider: petProvider),
                const SizedBox(height: 20),
                _VaccinesSection(pet: currentPet),
                const SizedBox(height: 20),
                _ShowersSection(pet: currentPet),
                const SizedBox(height: 20),
                _FeedSection(petId: currentPet.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VaccinesSection extends StatelessWidget {
  final Pet pet;
  const _VaccinesSection({required this.pet});

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final vaccines = pet.vaccines ?? [];

    return _ExpansionTileSection(
      title: ('Vacunas (${vaccines.length})'),
      icon: Icons.vaccines,
      itemCount: vaccines.length,
      emptyMessage: 'No hay vacunas registradas',
      onAddPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewVaccinePage(petId: pet.id),
          ),
        ).then((_) => petProvider.loadPets());
      },
      itemBuilder: (context, index) {
        final vaccine = vaccines[index];
        return VaccineCard(
          vaccine: vaccine,
          onEdit: () {},
          onDelete:
              () => _showDeleteVaccineDialog(
                context,
                petProvider,
                pet.id,
                vaccine.id,
              ),
        );
      },
    );
  }

  void _showDeleteVaccineDialog(
    BuildContext context,
    PetProvider provider,
    String petId,
    String vaccineId,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar vacuna'),
            content: const Text('¿Estás seguro de eliminar esta vacuna?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  await provider.deleteVaccine(petId, vaccineId);
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}

class _ShowersSection extends StatelessWidget {
  final Pet pet;
  const _ShowersSection({required this.pet});

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final showers = pet.showers ?? [];

    return _ExpansionTileSection(
      title: 'Baños (${showers.length})',
      icon: Icons.shower_outlined,
      itemCount: showers.length,
      emptyMessage: 'No hay registros de baños',
      onAddPressed: () => _showAddShowerDialog(context, petProvider, pet.id),
      itemBuilder: (context, index) {
        final shower = showers[index];
        return ShowerCard(
          shower: shower,
          onDelete:
              () => _showDeleteShowerDialog(
                context,
                petProvider,
                pet.id,
                shower.id,
              ),
        );
      },
    );
  }

  void _showAddShowerDialog(
    BuildContext context,
    PetProvider provider,
    String petId,
  ) {
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar baño'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Fecha (YYYY-MM-DD)',
                  hintText: 'Ej: 2023-11-15',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (dateController.text.isNotEmpty) {
                  await provider.addShower(
                    petId,
                    Shower(date: dateController.text),
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteShowerDialog(
    BuildContext context,
    PetProvider provider,
    String petId,
    String showerId,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar baño'),
            content: const Text(
              '¿Estás seguro de eliminar este registro de baño?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  await provider.deleteShower(petId, showerId);
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}

class _FeedSection extends StatelessWidget {
  const _FeedSection({required this.petId});

  final String petId;

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final feeding = petProvider.currentFeeding;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.food_bank_outlined,
                color: AppColors.textPrimary,
                size: 30,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Alimentación',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              CustomTextButton(
                text: 'Configurar',
                fontSize: 16,
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedingSettingsPage(petId: petId),
                      ),
                    ),
                textColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (feeding != null)
            FeedCard(feeding: feeding)
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No hay configuración de alimentación',
                style: TextStyle(color: AppColors.textTertiary, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class _PetNameSection extends StatelessWidget {
  final Pet pet;
  const _PetNameSection({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          pet.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          '${pet.specie} • ${pet.breed ?? "Sin raza"} • ${pet.age} años',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: AppColors.textTertiary),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Pet pet;
  final PetProvider petProvider;
  const _ActionButtons({required this.pet, required this.petProvider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Editar',
              buttonColor: AppColors.secondary,
              foregroundColor: AppColors.textPrimary,
              height: 35,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPetPage(pet: pet),
                  ),
                ).then((_) => petProvider.loadPets());
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CustomButton(
              text: 'Eliminar',
              buttonColor: AppColors.alert,
              foregroundColor: AppColors.textSecondary,
              height: 35,
              onPressed: () => _showDeleteConfirmationDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de eliminar a ${pet.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await petProvider.deletePet(pet.id);
                if (context.mounted) {
                  Navigator.pop(context); // Cierra el diálogo
                  Navigator.pop(context); // Regresa a la pantalla anterior
                }
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ExpansionTileSection extends StatelessWidget {
  const _ExpansionTileSection({
    required this.title,
    required this.icon,
    required this.onAddPressed,
    required this.itemBuilder,
    required this.itemCount,
    this.emptyMessage = 'No hay elementos',
  });

  final String title;
  final IconData icon;
  final VoidCallback onAddPressed;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        backgroundColor: AppColors.background,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: _ExpansionTileTitle(
          icon: icon,
          title: title,
          onAddPressed: onAddPressed,
        ),
        children: [
          if (itemCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                itemBuilder: itemBuilder,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                emptyMessage,
                style: TextStyle(fontSize: 15, color: AppColors.textTertiary),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

class _ExpansionTileTitle extends StatelessWidget {
  const _ExpansionTileTitle({
    required this.icon,
    required this.title,
    required this.onAddPressed,
  });

  final IconData icon;
  final String title;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black, size: 35),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: AppColors.textTertiary),
          onPressed: onAddPressed,
          tooltip: 'Agregar',
        ),
      ],
    );
  }
}
