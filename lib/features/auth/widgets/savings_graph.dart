import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/features/bank_card/services/bank_services.dart';
import 'package:budget_tracker/models/savings_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NewSavingsGraph extends StatefulWidget {
  const NewSavingsGraph({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewSavingsGraphState createState() => _NewSavingsGraphState();
}

class _NewSavingsGraphState extends State<NewSavingsGraph> {
  late Future<List<SavingsData>> savingsData;

  @override
  void initState() {
    super.initState();
    savingsData = BankService(context).getAllMonthsData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FutureBuilder<List<SavingsData>>(
        future: savingsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return SfCartesianChart(
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                minorGridLines: const MinorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              primaryYAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                labelStyle: const TextStyle(color: Colors.transparent),
              ),
              plotAreaBorderWidth: 0,
              legend: Legend(
                isVisible: true,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              series: _buildSeries(snapshot.data!),
              tooltipBehavior: TooltipBehavior(enable: true),
            );
          }
        },
      ),
    );
  }

  List<ChartSeries<SavingsData, String>> _buildSeries(List<SavingsData> data) {
    return [
      BarSeries<SavingsData, String>(
        dataSource: data,
        xValueMapper: (SavingsData savings, _) => savings.month,
        yValueMapper: (SavingsData savings, _) =>
            savings.balance - savings.amountSpent,
        name: 'Savings (in ₹)',
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        color: GlobalVariables.graphSavingsColor,
      ),
      BarSeries<SavingsData, String>(
        dataSource: data,
        xValueMapper: (SavingsData savings, _) => savings.month,
        yValueMapper: (SavingsData savings, _) => savings.amountSpent,
        name: 'Amt Spent (in ₹)',
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        color: GlobalVariables.graphIncomeColor,
      ),
    ];
  }
}
