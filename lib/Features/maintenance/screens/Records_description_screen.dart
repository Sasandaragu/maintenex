import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenex/Features/Home/screens/home_screens.dart';
import 'package:maintenex/Features/maintenance/screens/part_replacement_records_screen.dart';
import 'package:maintenex/Features/maintenance/screens/repair_records_screen.dart';
import 'package:maintenex/Features/maintenance/screens/service_records_screen.dart';
import 'package:maintenex/common/widgets/appbar.dart';

class ExplanationScreen extends StatelessWidget {
  const ExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
          title: const Text('Maintenence Records',
              style: TextStyle(
                  color: Colors
                      .black)), // Ensure the title style matches your app's theme
          showBackArrow: false,
          leadingIcon: Icons.arrow_back,
          leadingOnPressed: () => Get.to(() =>
              const HomeScreen()) // Adjust if using a different navigation method
          ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          SectionCard(
            title: 'Service Record',
            description: 'Service records are like a diary for your vehicle or equipment...',
            icon: Icons.build_circle,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceRecordsScreen())),
          ),
          SectionCard(
            title: 'Part Replacement Record',
            description: "Part replacement records list the parts that have been replaced...",
            icon: Icons.swap_horiz,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PartReplacementRecordsScreen())),
          ),
          SectionCard(
            title: 'Repair Record',
            description: "Repair records are like a doctor's notes for your vehicle or equipment...",
            icon: Icons.settings,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RepairRecordsScreen())),
          ),
        ],
      ),
    );
  }
}


class SectionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap; // Add this line

  const SectionCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap, // Modify this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell( // Wrap the Card widget with InkWell
      onTap: onTap, // Use the onTap callback here
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 56.0, color: Colors.blueGrey[900]),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blueGrey[900])),
                    SizedBox(height: 10.0),
                    Text(description, style: TextStyle(fontSize: 16.0, color: Colors.blueGrey[800])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: const ExplanationScreen(),
  ));
}
