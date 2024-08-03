import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signup/Models/AnalyticsModel.dart';
import 'package:signup/Models/IncomeModel.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  final List<String> months = [
    'Ja', 'Fe', 'Ma', 'Ap', 'Ma', 'Jn',
    'Jl', 'Au', 'Se', 'Oc', 'No', 'De'
  ];

  final Color primaryColor = Color.fromARGB(255, 58, 55, 199);
  final Color gridColor = Colors.black;
  final double gridLineWidth = 0.1;
  final Color backgroundColor = Color.fromARGB(255, 255, 239, 188); // بيج فاتح

  @override
  Widget build(BuildContext context) {
     final incomeModel = Provider.of<IncomeModel>(context);
    final analyticsModel = Provider.of<AnalyticsModel>(context);
    
    double provided = incomeModel.income - analyticsModel.totalExpenses;

    // إعداد البيانات للنقاط
    List<FlSpot> incomeSpots = List.generate(12, (index) {
      // يمكنك تعديل القيم هنا لتعكس الدخل الشهري الفعلي
      return FlSpot(index.toDouble(), incomeModel.income); 
    });

    List<FlSpot> expenseSpots = List.generate(12, (index) {
      // يمكنك تعديل القيم هنا لتعكس المصروفات الشهرية الفعلية
      return FlSpot(index.toDouble(), analyticsModel.totalExpenses); 
    });

    List<FlSpot> providedSpots = List.generate(12, (index) {
      // يمكنك تعديل القيم هنا لتعكس التوفير الشهري الفعلي
      return FlSpot(index.toDouble(), incomeModel.income - analyticsModel.totalExpenses); 
    });
   
    final currentMonthIndex = DateTime.now().month - 1; // تحديد الشهر الحالي

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Analytics',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset('images/Screenshot 2024-08-01 215318.png', height: 25,)
                  ],
                ),
              ),
              const SizedBox(height: 45),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: true,
                        horizontalInterval: 1,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: gridColor,
                            strokeWidth: gridLineWidth,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: gridColor,
                            strokeWidth: gridLineWidth,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              String month = '';
                              if (value.toInt() >= 0 && value.toInt() < months.length) {
                                month = months[value.toInt()];
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  month,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: value.toInt() == currentMonthIndex ? primaryColor : Colors.black, // الخط الذهبي على الشهر الحالي
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: primaryColor,
                          width: 1,
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: incomeSpots,
                          isCurved: true,
                          curveSmoothness: 0.2,
                          color: Colors.green,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: true, color: primaryColor.withOpacity(0.1)),
                        ),
                        LineChartBarData(
                          spots: expenseSpots,
                          isCurved: true,
                          curveSmoothness: 0.2,
                          color: Colors.red,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: true, color: primaryColor.withOpacity(0.2)),
                        ),
                        LineChartBarData(
                          spots: providedSpots,
                          isCurved: true,
                          curveSmoothness: 0.2,
                          color: primaryColor,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: true, color: primaryColor.withOpacity(0.2)),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipMargin: 8,
                          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                            return lineBarsSpot.map((spot) {
                              String label;
                              switch (spot.barIndex) {
                                case 0:
                                  label = 'Income:';
                                  break;
                                case 1:
                                  label = 'Expense:';
                                  break;
                                case 2:
                                  label = 'Provided:';
                                  break;
                                default:
                                  label = '';
                              }
                              return LineTooltipItem(
                                '$label ${spot.y.toStringAsFixed(1)}',
                                TextStyle(color: Colors.white),
                              );
                            }).toList();
                          },
                        ),
                        handleBuiltInTouches: true,
                      ),
                      backgroundColor: backgroundColor,
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: 3000, // الخط الأحمر في المنتصف
                            color: Colors.red,
                            strokeWidth: 2,
                            dashArray: [5, 5], // إذا كنت تريد خط منقط
                            label: HorizontalLineLabel(
                              show: true,
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        verticalLines: [
                          VerticalLine(
                            x: currentMonthIndex.toDouble(), // الخط الذهبي على الشهر الحالي
                            color: Colors.orange,
                            strokeWidth: 2,
                            dashArray: [5, 5], // إذا كنت تريد خط منقط
                            label: VerticalLineLabel(
                              show: true,
                              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Analyze the savings rate during the last month',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('• Gross income',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18)),
                    Text(
                     '\$${incomeModel.income.toStringAsFixed(1)}',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Divider(
                  height: 2,
                  thickness: .5,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('• Expense total', style:const TextStyle(color: Colors.black, fontSize: 18)),
                    Text('\$${analyticsModel.totalExpenses.toStringAsFixed(1)}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Divider(
                  height: 2,
                  thickness: .5,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Provided',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text('\$${provided.toStringAsFixed(1)}',
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
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
