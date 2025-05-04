import 'package:flutter/material.dart';
import 'package:pet_manager/models/pet.dart';
import 'package:pet_manager/pages/pets/edit_pet_page.dart';
import 'package:pet_manager/styles/app_colors.dart';
import 'package:pet_manager/widgets/buttons.dart';
import 'package:pet_manager/widgets/common_widgets.dart';
import 'package:pet_manager/widgets/feed_card.dart';
import 'package:pet_manager/widgets/shower_card.dart';
import 'package:pet_manager/widgets/text_fields.dart';
import 'package:pet_manager/widgets/vaccine_card.dart';

class PetPage extends StatelessWidget {
  const PetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Pet pet = ModalRoute.of(context)!.settings.arguments as Pet;

    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
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
                Center(child: PetPicture(size: 75, imagePath: pet.photoUrl)),
                const SizedBox(height: 20),
                _PetNameSection(pet: pet),
                const SizedBox(height: 20),
                _ActionButtons(pet: pet),
                const SizedBox(height: 20),
                _VaccinesSection(pet: pet),
                const SizedBox(height: 20),
                _ShowersSection(pet: pet),
                const SizedBox(height: 10),
                _FeedSection(pet: pet),
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
    final vaccines = pet.vaccines;

    return _ExpansionTileSection(
      title: ('Vacunas (${vaccines.length})'),
      icon: Icons.vaccines,
      itemCount: vaccines.length,
      emptyMessage: 'No hay vacunas registradas',
      onAddPressed: () {
        Navigator.pushNamed(context, '/newVaccine');
      },
      itemBuilder: (context, index) {
        final vaccine = vaccines[index];
        return VaccineCard(vaccine: vaccine);
      },
    );
  }
}

class _ShowersSection extends StatelessWidget {
  final Pet pet;
  const _ShowersSection({required this.pet});

  @override
  Widget build(BuildContext context) {
    final showers = pet.showers;
    final dateController = TextEditingController();

    Future<void> showAddShowerModal() async {
      await showDialog(
        context: context,
        builder:
            (context) => AddShowerModal(
              dateController: dateController,
              onCancel: () => Navigator.pop(context),
              onSubmit: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Baño registrado correctamente para ${pet.name}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.good,
                    behavior: SnackBarBehavior.floating,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 3),
                  ),
                );
                Navigator.pop(context);
              },
            ),
      );
    }

    return _ExpansionTileSection(
      title: 'Baños (${showers.length})',
      icon: Icons.shower_outlined,
      itemCount: showers.length,
      emptyMessage: 'No hay registros de baños',
      onAddPressed: showAddShowerModal,
      itemBuilder: (context, index) {
        final shower = showers[index];
        return ShowerCard(shower: shower, onDelete: () {});
      },
    );
  }
}

class _FeedSection extends StatelessWidget {
  final Pet pet;
  const _FeedSection({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/feedConfiguration',
                      arguments: pet,
                    );
                  },
                  textColor: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 10),
            FeedCard(feeding: pet.feedings),
          ],
        ),
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
  const _ActionButtons({required this.pet});

  // Metodo para mostrar un dialogo de confirmacion
  Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmationMessage,
    required Color confirmationColor,
    required VoidCallback onConfirm,
    String successMessage = 'Operación completada correctamente.',
    Color successColor = AppColors.good,
  }) async {
    await showDialog(
      context: context,
      builder:
          (context) => ConfirmationDialog(
            title: title,
            content: content,
            confirmationMessage: confirmationMessage,
            confirmationColor: confirmationColor,
            onConfirm: onConfirm,
            successMessage: successMessage,
            successColor: successColor,
          ),
    );
  }

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
                  MaterialPageRoute(builder: (_) => EditPetPage(pet: pet)),
                );
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
              onPressed: () async {
                await showConfirmationDialog(
                  context: context,
                  title: 'Eliminar mascota',
                  content: '¿Estás seguro de que desea eliminar a ${pet.name}?',
                  confirmationMessage: 'Guardar',
                  confirmationColor: AppColors.alert,
                  onConfirm: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Mascota eliminada correctamente.',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: AppColors.good,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.all(16),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
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

class AddShowerModal extends StatelessWidget {
  final TextEditingController dateController;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const AddShowerModal({
    super.key,
    required this.dateController,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Nueva ducha',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                fieldLabel: 'Ingresa la fecha de la ducha',
                defaultText: 'Fecha (YYYY-MM-DD)',
                isNumberField: false,
                controller: dateController,
                isRequired: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancelar',
                      buttonColor: AppColors.alert,
                      foregroundColor: AppColors.textSecondary,
                      onPressed: onCancel,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: 'Agregar',
                      buttonColor: AppColors.primary,
                      foregroundColor: AppColors.textSecondary,
                      onPressed: onSubmit,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
