import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/widgets/common_widgets.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';
import 'package:pet_manager_app/widgets/vaccine_card.dart';

class PetPage extends StatelessWidget {
  const PetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Rocky')),
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
                Center(child: PetPicture(size: 75)),
                SizedBox(height: 20),
                _PetNameSection(),
                SizedBox(height: 20),
                _ActionButtons(),
                SizedBox(height: 20),
                _ExpansionTileSection(
                  title: 'Vacunas',
                  icon: Icons.vaccines,
                  itemBuilder: (context, index) {
                    return VaccineCard();
                  },
                  itemCount: 3,
                  onAddPressed: () {},
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PetNameSection extends StatelessWidget {
  const _PetNameSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Rocky',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
        Text(
          'Perro • Golden Retriever • 3 años',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: AppColors.textTertiary),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

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
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CustomButton(
              text: 'Eliminar',
              buttonColor: AppColors.alert,
              foregroundColor: AppColors.textSecondary,
              height: 35,
              onPressed: () {},
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
  });

  final String title;
  final IconData icon;
  final VoidCallback onAddPressed;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: _ExpansionTileTittle(icon: icon, title: title),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}

class _ExpansionTileTittle extends StatelessWidget {
  const _ExpansionTileTittle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          AddButton(onPressed: () {}),
        ],
      ),
    );
  }
}
