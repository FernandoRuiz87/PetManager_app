import 'package:flutter/material.dart';
import 'package:pet_manager_app/colors/app_colors.dart';

class PetCard extends StatelessWidget {
  const PetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'login_page');
      },
      child: Card(
        elevation: 0,
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: AppColors.cardStroke, width: 1.5),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [PetPicture(), SizedBox(width: 15), PetDetails()],
          ),
        ),
      ),
    );
  }
}

class PetPicture extends StatelessWidget {
  const PetPicture({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: AppColors.background,
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: AppColors.secondary),
        ),
      ),
    );
  }
}

class PetDetails extends StatelessWidget {
  const PetDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PetNameAndAlert(),
          SizedBox(height: 5),
          Text('Perro • Golden Retriever • 3 años'),
        ],
      ),
    );
  }
}

class _PetNameAndAlert extends StatelessWidget {
  const _PetNameAndAlert();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Rocky',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 138),
        Row(
          children: [
            CircleAvatar(radius: 5, backgroundColor: AppColors.alert),
            const SizedBox(width: 5),
            Text(
              '2',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.alert,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
