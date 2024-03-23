import 'package:flutter/material.dart';
import 'package:maintenex/Features/fuelTracking/controllers/fuel_form_controller.dart';

class FuelEntryForm extends StatefulWidget {
  @override
  _FuelEntryFormState createState() => _FuelEntryFormState();
}

class _FuelEntryFormState extends State<FuelEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fuelAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add fuel records form',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Enter how much fuel you have entered here :",
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _fuelAmountController,
                decoration: const InputDecoration(
                  hintText: "Fuel Amount",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 155, 155, 155),
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveFuelData(_fuelAmountController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 20),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveFuelData(String fuelAmount) async {
    double amount = double.tryParse(fuelAmount) ?? 0.0;
    final controller = FuelController();

    await controller.addFuelRecord(amount: amount);
  }
}
