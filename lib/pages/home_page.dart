import 'package:flutter/material.dart';
import 'package:pet_manager_app/widgets/cards.dart';
import 'package:pet_manager_app/widgets/custom_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('PetManager')),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ActionSeparator(), SizedBox(height: 15), PetCard()],
            ),
          ),
        ),
      ),
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
        const AddButton(),
      ],
    );
  }
}
