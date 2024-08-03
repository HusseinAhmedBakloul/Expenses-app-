import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:signup/Models/debtmodel.dart';

const String pageTitle = 'Health';
const String totalLabel = 'Total Health Expenses';
const String selectDateLabel = 'Select month';
const String image = 'images/Screenshot_2024-07-27_111702-removebg-preview.png'; 
const Color primaryColor = Color.fromARGB(255, 58, 55, 199); 

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final TextEditingController _doctorVisitsController = TextEditingController(text: "0");
  final TextEditingController _medicationsController = TextEditingController(text: "0");
  final TextEditingController _medicalTestsController = TextEditingController(text: "0");
  final TextEditingController _otherExpensesController = TextEditingController(text: "0");

  DateTime? _selectedDate;
  bool _isHealthPaid = false;

  @override
  void initState() {
    super.initState();
    _doctorVisitsController.addListener(_updateTotalHealth);
    _medicationsController.addListener(_updateTotalHealth);
    _medicalTestsController.addListener(_updateTotalHealth);
    _otherExpensesController.addListener(_updateTotalHealth);
  }

  @override
  void dispose() {
    _doctorVisitsController.removeListener(_updateTotalHealth);
    _medicationsController.removeListener(_updateTotalHealth);
    _medicalTestsController.removeListener(_updateTotalHealth);
    _otherExpensesController.removeListener(_updateTotalHealth);
    _doctorVisitsController.dispose();
    _medicationsController.dispose();
    _medicalTestsController.dispose();
    _otherExpensesController.dispose();
    super.dispose();
  }

  void _updateTotalHealth() {
    setState(() {});
  }

  void _saveChanges() {
    double totalHealth = _calculateTotalHealth();

    if (_isHealthPaid && _selectedDate != null) {
      Navigator.pop(
        context,
        Debt(
          title: pageTitle,
          date: _selectedDate!,
          amount: totalHealth,
          image: image,
        ),
      );
    } else {
      _showAlertDialog(context, "Error", "Please confirm payment and select a date.");
    }
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  double _calculateTotalHealth() {
    double doctorVisits = double.tryParse(_doctorVisitsController.text) ?? 0;
    double medications = double.tryParse(_medicationsController.text) ?? 0;
    double medicalTests = double.tryParse(_medicalTestsController.text) ?? 0;
    double otherExpenses = double.tryParse(_otherExpensesController.text) ?? 0;
    return doctorVisits + medications + medicalTests + otherExpenses;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(119, 223, 225, 230),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, size: 24, color: primaryColor),
                    ),
                  ),
                  const SizedBox(width: 100),
                  const Text(
                    pageTitle,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: ClipOval(
                  child: Image.asset(
                    image,
                    width: 260,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Details about Health expenses per month:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  _buildExpenseRow('• Doctor Visits', _doctorVisitsController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 20),
                  _buildExpenseRow('• Medications', _medicationsController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 20),
                  _buildExpenseRow('• Medical Tests', _medicalTestsController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 20),
                  _buildExpenseRow('• Other Expenses', _otherExpensesController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        totalLabel,
                        style: TextStyle(
                            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${_calculateTotalHealth().toStringAsFixed(1)}',
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(height: 6),
                  RoundCheckBox(
                    checkedColor: primaryColor,
                    borderColor: primaryColor,
                    onTap: (selected) {
                      setState(() {
                        _isHealthPaid = selected ?? false;
                      });
                    },
                    uncheckedWidget: const Icon(Icons.ads_click_sharp, color: primaryColor),
                    animationDuration: const Duration(milliseconds: 40),
                    isChecked: _isHealthPaid,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Pay for health',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Container(
                      height: 40,
                      width: 125,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 231, 226, 226),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_selectedDate != null
                                ? '${_selectedDate!.month}/${_selectedDate!.year}'
                                : selectDateLabel),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: _saveChanges,
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('Save',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseRow(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 16)),
        SizedBox(
          width: 60,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5),
            ),
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
