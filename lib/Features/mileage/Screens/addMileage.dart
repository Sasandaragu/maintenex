import 'package:flutter/material.dart';
import 'package:maintenex/Features/mileage/controllers/mileageControllers.dart';
import 'package:maintenex/features/mileage/models/mileageModels.dart';
import 'package:maintenex/features/reminders/screens/local_notifications.dart';

class AddMileageScreen extends StatefulWidget {
  final Function(MileageEntry) onMileageAdded;

  const AddMileageScreen({Key? key, required this.onMileageAdded})
      : super(key: key);

  @override
  _AddMileageScreenState createState() => _AddMileageScreenState();
}

class _AddMileageScreenState extends State<AddMileageScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Mileage',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Make sure you are adding the latest total Mileage count.",
              style: TextStyle(
                fontSize: 17,
                color: Color.fromARGB(255, 255, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: "Mileage",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 155, 155, 155),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final controller = MileageController();
                final double mileage = double.parse(_controller.text.trim());
                await controller.updateNewMileage(newMileage: mileage);
                
                //Setting the mileage updating reminder notification
                LocalNotifications.scheduleMileageReminder();
                // if (mileage != null && mileage > 0) {
                //   final mileageEntry = MileageEntry(mileage);
                //   widget.onMileageAdded(mileageEntry);
                //   //Navigator.of(context).pop();
                // }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, 
                backgroundColor: Colors.black,
                elevation: 0,
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
