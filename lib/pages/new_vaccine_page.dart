import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';
import 'package:pet_manager_app/widgets/custom_text_fields.dart';

class NewVaccinePage extends StatelessWidget {
  const NewVaccinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva vacuna')),
      body: Padding(
        padding: EdgeInsets.only(
          left: padding.left,
          right: padding.right,
          top: padding.top,
          bottom: padding.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                fieldLabel: 'Ingresa el nombre de la vacuna',
                defaultText: 'Nombre de la vacuna',
                isRequired: true,
                isNumberField: false,
              ),
              const SizedBox(height: 20),
              _AplicationDayField(),
              const SizedBox(height: 20),
              CustomTextField(
                fieldLabel: 'Ingresa la duracion en meses',
                defaultText: 'Duración de la vacuna',
                isRequired: true,
                isNumberField: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Agregar',
                buttonColor: AppColors.primary,
                foregroundColor: AppColors.textSecondary,
                onPressed: () {},
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AplicationDayField extends StatelessWidget {
  const _AplicationDayField();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text(
              'Ingrese la fecha de aplicación',
              style: TextStyle(fontSize: 18),
            ),
            const Text(' *', style: TextStyle(color: Colors.red, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (selectedDate != null) {
              // Handle the selected date
              print('Selected date: $selectedDate');
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.textFieldBorderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Selecciona una fecha', style: TextStyle(fontSize: 16)),
                const Icon(Icons.calendar_today, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
