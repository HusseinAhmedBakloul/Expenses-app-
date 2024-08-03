import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:signup/Models/debtmodel.dart';

const String pageTitle = 'Leisure';
const String totalLabel = 'Total Leisure';
const String selectDateLabel = 'Select month';
const String image = 'images/Screenshot_2024-07-27_114939-removebg-preview.png'; // استبدل بالصورة المناسبة
const Color primaryColor = Color.fromARGB(255, 58, 55, 199); // تأكد من تعريف primaryColor

class LeisurePage extends StatefulWidget {
  const LeisurePage({super.key});

  @override
  _LeisurePageState createState() => _LeisurePageState();
}

class _LeisurePageState extends State<LeisurePage> {
  final TextEditingController _outdoorActivitiesController = TextEditingController(text: "0");
  final TextEditingController _gamesController = TextEditingController(text: "0");
  final TextEditingController _partiesController = TextEditingController(text: "0");
  final TextEditingController _subscriptionsController = TextEditingController(text: "0");

  DateTime? _selectedDate;
  bool _isLeisurePaid = false;

  @override
  void initState() {
    super.initState();
    _outdoorActivitiesController.addListener(_updateTotalLeisure);
    _gamesController.addListener(_updateTotalLeisure);
    _partiesController.addListener(_updateTotalLeisure);
    _subscriptionsController.addListener(_updateTotalLeisure);
  }

  @override
  void dispose() {
    _outdoorActivitiesController.removeListener(_updateTotalLeisure);
    _gamesController.removeListener(_updateTotalLeisure);
    _partiesController.removeListener(_updateTotalLeisure);
    _subscriptionsController.removeListener(_updateTotalLeisure);
    _outdoorActivitiesController.dispose();
    _gamesController.dispose();
    _partiesController.dispose();
    _subscriptionsController.dispose();
    super.dispose();
  }

  void _updateTotalLeisure() {
    setState(() {});
  }

  void _saveChanges() {
    double totalLeisure = _calculateTotalLeisure();

    if (_isLeisurePaid && _selectedDate != null) {
      Navigator.pop(
        context,
        Debt(
          title: pageTitle,
          date: _selectedDate!,
          amount: totalLeisure,
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

  double _calculateTotalLeisure() {
    double outdoorActivities = double.tryParse(_outdoorActivitiesController.text) ?? 0;
    double games = double.tryParse(_gamesController.text) ?? 0;
    double parties = double.tryParse(_partiesController.text) ?? 0;
    double subscriptions = double.tryParse(_subscriptionsController.text) ?? 0;
    return outdoorActivities + games + parties + subscriptions;
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
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.center,
                child: ClipOval(
                  child: Image.asset(
                    image,
                    width: 240,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Details about Leisure expenses per month:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  _buildExpenseRow('• Outdoor Activities', _outdoorActivitiesController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 20),
                  _buildExpenseRow('• Games', _gamesController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 20),
                  _buildExpenseRow('• Parties', _partiesController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 20),
                  _buildExpenseRow('• Subscriptions', _subscriptionsController),
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
                        '\$${_calculateTotalLeisure().toStringAsFixed(1)}',
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
                        _isLeisurePaid = selected ?? false;
                      });
                    },
                    uncheckedWidget: const Icon(Icons.ads_click_sharp, color: primaryColor),
                    animationDuration: const Duration(milliseconds: 40),
                    isChecked: _isLeisurePaid,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pay the leisure',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
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
