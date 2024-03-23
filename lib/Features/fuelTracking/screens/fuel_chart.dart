import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/repositories/vehicle/vehicle_repository.dart';
import '../../../utils/constants/colors.dart';


class FuelUsageChart extends StatelessWidget {
  final String userId;
  String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;

  FuelUsageChart({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection("Vehicle")
          .doc(vehicleNo)
          .collection('FuelRecords')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching data: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No fuel data available'));
        }

        List<BarChartGroupData> barGroups = processData(snapshot.data!.docs);

        return BarChart(BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int index = value.toInt();
                  if (index < barGroups.length) {
                    String monthKey = monthlyTotals.keys.elementAt(index);
                    DateTime monthDate = DateFormat('yyyy-MM').parse(monthKey);
                    String monthName = DateFormat.MMM().format(monthDate);
                    return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(monthName,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)));
                  }
                  return Text('');
                },
                reservedSize: 40,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text('${value.toStringAsFixed(1)}L',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12));
                },
                reservedSize: 50,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ));
      },
    );
  }

  final Map<String, double> monthlyTotals = {};

  List<BarChartGroupData> processData(List<QueryDocumentSnapshot> docs) {
    final DateTime now = DateTime.now();
    final int currentYear = now.year;
    monthlyTotals.clear();

    for (int month = 1; month <= 12; month++) {
      String monthKey = "$currentYear-${month.toString().padLeft(2, '0')}";
      monthlyTotals[monthKey] = 0.0;
    }

    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;
      Timestamp timestamp = data['date'];
      DateTime date = timestamp.toDate();
      String monthKey = DateFormat('yyyy-MM').format(date);
      double amount = data['amount'] as double;

      if (monthlyTotals.containsKey(monthKey)) {
        monthlyTotals[monthKey] = monthlyTotals[monthKey]! + amount;
      }
    }

    List<BarChartGroupData> barGroups = [];
    int barGroupIndex = 0;

    monthlyTotals.forEach((month, total) {
      final barGroup = BarChartGroupData(
        x: barGroupIndex++,
        barRods: [
          BarChartRodData(
            toY: total,
            color: TColors.buttonPrimary,
            width: 9,
          ),
        ],
      );
      barGroups.add(barGroup);
    });

    barGroups.sort((a, b) => a.x.compareTo(b.x));

    return barGroups;
  }
}
