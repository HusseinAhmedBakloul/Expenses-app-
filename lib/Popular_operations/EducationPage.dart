import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:signup/Models/debtmodel.dart';

const String pageTitle = 'Education';
const String totalLabel = 'Total Education';
const String selectDateLabel = 'Select month';
const String image = 'images/Screenshot_2024-07-27_112004-removebg-preview.png'; // استبدل بالصورة المناسبة
const Color primaryColor = Color.fromARGB(255, 58, 55, 199); // تأكد من تعريف primaryColor

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  _EducationPageState createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  final TextEditingController _tuitionFeesController = TextEditingController(text: "0");
  final TextEditingController _booksController = TextEditingController(text: "0");
  final TextEditingController _trainingCoursesController = TextEditingController(text: "0");
  final TextEditingController _educationalMaterialsController = TextEditingController(text: "0");

  DateTime? _selectedDate;
  bool _isEducationPaid = false;

  @override
  void initState() {
    super.initState();
    _tuitionFeesController.addListener(_updateTotalEducation);
    _booksController.addListener(_updateTotalEducation);
    _trainingCoursesController.addListener(_updateTotalEducation);
    _educationalMaterialsController.addListener(_updateTotalEducation);
  }

  @override
  void dispose() {
    _tuitionFeesController.removeListener(_updateTotalEducation);
    _booksController.removeListener(_updateTotalEducation);
    _trainingCoursesController.removeListener(_updateTotalEducation);
    _educationalMaterialsController.removeListener(_updateTotalEducation);
    _tuitionFeesController.dispose();
    _booksController.dispose();
    _trainingCoursesController.dispose();
    _educationalMaterialsController.dispose();
    super.dispose();
  }

  void _updateTotalEducation() {
    setState(() {});
  }

  void _saveChanges() {
    double totalEducation = _calculateTotalEducation();

    if (_isEducationPaid && _selectedDate != null) {
      Navigator.pop(
        context,
        Debt(
          title: pageTitle,
          date: _selectedDate!,
          amount: totalEducation,
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

  double _calculateTotalEducation() {
    double tuitionFees = double.tryParse(_tuitionFeesController.text) ?? 0;
    double books = double.tryParse(_booksController.text) ?? 0;
    double trainingCourses = double.tryParse(_trainingCoursesController.text) ?? 0;
    double educationalMaterials = double.tryParse(_educationalMaterialsController.text) ?? 0;
    return tuitionFees + books + trainingCourses + educationalMaterials;
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
                  const SizedBox(width: 85),
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
              const SizedBox(height: 5),
              const Text(
                'Details about Education expenses per month:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  _buildExpenseRow('• Tuition Fees', _tuitionFeesController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 20),
                  _buildExpenseRow('• Books', _booksController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 20),
                  _buildExpenseRow('• Training Courses', _trainingCoursesController),
                  const Divider(color: Colors.black, thickness: 0.5, height: 20),
                  _buildExpenseRow('• Educational Materials', _educationalMaterialsController),
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
                        '\$${_calculateTotalEducation().toStringAsFixed(1)}',
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
                        _isEducationPaid = selected ?? false;
                      });
                    },
                    uncheckedWidget: const Icon(Icons.ads_click_sharp, color: primaryColor),
                    animationDuration: const Duration(milliseconds: 40),
                    isChecked: _isEducationPaid,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pay education',
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
