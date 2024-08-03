import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:signup/Models/debtmodel.dart';

const String pageTitle = 'Utilities';
const String totalLabel = 'Total Utilities';
const String selectDateLabel = 'Select month';
const String image = 'images/Screenshot_2024-07-27_104448-removebg-preview.png';
const Color primaryColor = Color.fromARGB(255, 58, 55, 199); // تأكد من تعريف primaryColor

class UtilitiesPage extends StatefulWidget {
  const UtilitiesPage({super.key});

  @override
  _UtilitiesPageState createState() => _UtilitiesPageState();
}

class _UtilitiesPageState extends State<UtilitiesPage> {
  final TextEditingController _electricityController = TextEditingController(text: "0");
  final TextEditingController _internetController = TextEditingController(text: "0");
  final TextEditingController _cableController = TextEditingController(text: "0");
  final TextEditingController _otherSubscriptionsController = TextEditingController(text: "0");

  DateTime? _selectedDate;
  bool _isUtilitiesPaid = false;

  @override
  void initState() {
    super.initState();
    _electricityController.addListener(_updateTotalUtilities);
    _internetController.addListener(_updateTotalUtilities);
    _cableController.addListener(_updateTotalUtilities);
    _otherSubscriptionsController.addListener(_updateTotalUtilities);
  }

  @override
  void dispose() {
    _electricityController.removeListener(_updateTotalUtilities);
    _internetController.removeListener(_updateTotalUtilities);
    _cableController.removeListener(_updateTotalUtilities);
    _otherSubscriptionsController.removeListener(_updateTotalUtilities);
    _electricityController.dispose();
    _internetController.dispose();
    _cableController.dispose();
    _otherSubscriptionsController.dispose();
    super.dispose();
  }

  void _updateTotalUtilities() {
    setState(() {});
  }

  void _saveChanges() {
    double totalUtilities = _calculateTotalUtilities();

    if (_isUtilitiesPaid && _selectedDate != null) {
      Navigator.pop(
        context,
        Debt(
          title: pageTitle,
          date: _selectedDate!,
          amount: totalUtilities,
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

  double _calculateTotalUtilities() {
    double electricity = double.tryParse(_electricityController.text) ?? 0;
    double internet = double.tryParse(_internetController.text) ?? 0;
    double cable = double.tryParse(_cableController.text) ?? 0;
    double otherSubscriptions = double.tryParse(_otherSubscriptionsController.text) ?? 0;
    return electricity + internet + cable + otherSubscriptions;
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
                  const SizedBox(width: 95),
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
              const SizedBox(height: 5),
              const Text(
                'Details about Utilities expenses per month:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  _buildExpenseRow('• Electricity & Water & Gas Bill', _electricityController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 20),
                  _buildExpenseRow('• Internet & Phone Bill', _internetController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 20),
                  _buildExpenseRow('• Cable & Streaming Services Bill', _cableController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 20),
                  _buildExpenseRow('• Other Subscriptions', _otherSubscriptionsController),
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
                        '\$${_calculateTotalUtilities().toStringAsFixed(1)}',
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
                        _isUtilitiesPaid = selected ?? false;
                      });
                    },
                    uncheckedWidget: const Icon(Icons.ads_click_sharp, color: primaryColor),
                    animationDuration: const Duration(milliseconds: 40),
                    isChecked: _isUtilitiesPaid,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pay the utilities',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
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
