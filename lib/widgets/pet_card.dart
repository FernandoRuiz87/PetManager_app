import 'package:flutter/material.dart';
import 'package:pet_manager/models/pet.dart';
import 'package:pet_manager/styles/app_colors.dart';
import 'package:pet_manager/widgets/common_widgets.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final int alertCount;
  final VoidCallback? onTap;

  const PetCard({
    super.key,
    required this.pet,
    this.alertCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ?? () => Navigator.pushNamed(context, '/pet', arguments: pet),
      child: Card(
        elevation: 0,
        color: AppColors.cardBackground,
        shape: _cardShape(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: _PetCardContent(pet: pet, alertCount: alertCount),
        ),
      ),
    );
  }

  RoundedRectangleBorder _cardShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
      side: const BorderSide(color: AppColors.cardStroke, width: 1.5),
    );
  }
}

class _PetCardContent extends StatelessWidget {
  final Pet pet;
  final int alertCount;

  const _PetCardContent({required this.pet, required this.alertCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PetPicture(
          size: 40,
          imagePath: pet.photoUrl ?? 'assets/images/logo.png',
        ),
        const SizedBox(width: 15),
        _PetDetails(pet: pet, alertCount: alertCount),
      ],
    );
  }
}

class _PetDetails extends StatelessWidget {
  final Pet pet;
  final int alertCount;

  const _PetDetails({required this.pet, required this.alertCount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PetNameWithAlerts(name: pet.name, alertCount: alertCount),
          const SizedBox(height: 5),
          _PetDescription(pet: pet),
        ],
      ),
    );
  }
}

class _PetNameWithAlerts extends StatelessWidget {
  final String name;
  final int alertCount;

  const _PetNameWithAlerts({required this.name, required this.alertCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        if (alertCount > 0) _AlertIndicator(count: alertCount),
      ],
    );
  }
}

class _AlertIndicator extends StatelessWidget {
  final int count;

  const _AlertIndicator({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(radius: 5, backgroundColor: AppColors.alert),
        const SizedBox(width: 5),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.alert,
          ),
        ),
      ],
    );
  }
}

class _PetDescription extends StatelessWidget {
  final Pet pet;

  const _PetDescription({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${pet.specie} • ${pet.breed} • ${pet.age} años',
      style: const TextStyle(fontSize: 14),
    );
  }
}
