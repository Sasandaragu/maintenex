import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenex/Features/vehicle/models/vehicle_model.dart';

class VehicleList extends StatefulWidget {
  final String userID;
  final Function(VehicleModel)? onVehicleSelected;

  const VehicleList({super.key, required this.userID, this.onVehicleSelected});

  @override
  VehicleListState createState() => VehicleListState();
}

class VehicleListState extends State<VehicleList> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<VehicleModel> vehicles = [];
  VehicleModel? selectedVehicle;

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  void fetchVehicles() async {
    var vehiclesCollection = _db.collection('Users/${widget.userID}/Vehicle');
    var snapshot = await vehiclesCollection.get();
    var vehicles = snapshot.docs.map((doc) => VehicleModel.fromFirestore(doc.data())).toList();

    setState(() {
      vehicles = vehicles;
    });
  }

  @override

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(vehicles[index].vehicleNo),
          subtitle: Text(vehicles[index].vehicleNickname),
          onTap: () {
            setState(() {
              selectedVehicle = vehicles[index]; // Store the selected vehicle
            });
          },
        );
      },
    );
  }
}
