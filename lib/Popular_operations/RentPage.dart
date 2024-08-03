import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:signup/Models/debtmodel.dart';
import 'package:signup/NavigationBar/Person.dart';

const String pageTitle = 'Rent';
const String totalLabel = 'Total rent';
const String selectDateLabel = 'Select month';
const String image = 'images/Screenshot_2024-07-27_101428-removebg-preview.png';

class RentPage extends StatefulWidget {
  const RentPage({super.key});

  @override
  _RentPageState createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  final TextEditingController _monthlyRentController =
      TextEditingController(text: "0");
  final TextEditingController _propertyTaxesController =
      TextEditingController(text: "0");
  final TextEditingController _rentersInsuranceController =
      TextEditingController(text: "0");

  DateTime? _selectedDate;
  bool _isRentPaid = false;

  @override
  void initState() {
    super.initState();
    _monthlyRentController.addListener(_updateTotalRent);
    _propertyTaxesController.addListener(_updateTotalRent);
    _rentersInsuranceController.addListener(_updateTotalRent);
  }

  @override
  void dispose() {
    _monthlyRentController.removeListener(_updateTotalRent);
    _propertyTaxesController.removeListener(_updateTotalRent);
    _rentersInsuranceController.removeListener(_updateTotalRent);
    _monthlyRentController.dispose();
    _propertyTaxesController.dispose();
    _rentersInsuranceController.dispose();
    super.dispose();
  }

  void _updateTotalRent() {
    setState(() {});
  }

  void _saveChanges() {
    double totalRent = _calculateTotalRent();

    if (_isRentPaid && _selectedDate != null) {
      Navigator.pop(
        context,
        Debt(
          title: pageTitle,
          date: _selectedDate!,
          amount: totalRent,
          image: image,
        ),
      );
    } else {
      _showAlertDialog(
          context, "Error", "Please confirm payment and select a date.");
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

  double _calculateTotalRent() {
    double monthlyRent = double.tryParse(_monthlyRentController.text) ?? 0;
    double propertyTaxes = double.tryParse(_propertyTaxesController.text) ?? 0;
    double rentersInsurance =
        double.tryParse(_rentersInsuranceController.text) ?? 0;
    return monthlyRent + propertyTaxes + rentersInsurance;
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
                      child: const Icon(Icons.arrow_back_rounded,
                          size: 24, color: primaryColor),
                    ),
                  ),
                  const SizedBox(width: 110),
                  const Text(
                    pageTitle,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ClipOval(
                  child: Image.asset(
                    image,
                    width: 270,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Details about rent expenses per month:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('• Monthly Rent Payments',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _monthlyRentController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 5),
                          ),
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 0.5,
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('• Property Taxes',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _propertyTaxesController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 5),
                          ),
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 0.5,
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('• Renters Insurance',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _rentersInsuranceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 5),
                          ),
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 0.5,
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(totalLabel,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      Text(
                        '\$${_calculateTotalRent().toStringAsFixed(1)}',
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
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
                        _isRentPaid = selected ?? false;
                      });
                    },
                    uncheckedWidget:
                        const Icon(Icons.ads_click_sharp, color: primaryColor),
                    animationDuration: const Duration(
                      milliseconds: 40,
                    ),
                    isChecked: _isRentPaid, // تأكد من تمرير قيمة الحالة الصحيحة
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Pay the rent',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 37),
                    child: Container(
                      height: 40,
                      width: 135,
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
