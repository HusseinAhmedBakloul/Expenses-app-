import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';  
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup/Models/AnalyticsModel.dart';
import 'package:signup/Models/IncomeModel.dart';
import 'package:signup/Models/debtmodel.dart';
import 'package:signup/NavigationBar/Analytics.dart';
import 'package:signup/NavigationBar/Person.dart';
import 'package:signup/Popular_operations/DebtsPage.dart';
import 'package:signup/Popular_operations/EducationPage.dart';
import 'package:signup/Popular_operations/FoodPage.dart';
import 'package:signup/Popular_operations/HealthPage.dart';
import 'package:signup/Popular_operations/InsurancePage.dart';
import 'package:signup/Popular_operations/LeisurePage.dart';
import 'package:signup/Popular_operations/PersonalPage.dart';
import 'package:signup/Popular_operations/RentPage.dart';
import 'package:signup/Popular_operations/TransportPage.dart';
import 'package:signup/Popular_operations/UtilitiesPage.dart';

const Color primaryColor = Color.fromARGB(255, 58, 55, 199);
const Color secondaryColor = Color.fromARGB(119, 223, 225, 230);

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Debt> _debts = [];
  File? imageFile;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDebts();
    final incomeModel = Provider.of<IncomeModel>(context, listen: false);
    _controller.text = incomeModel.income.toString();
  }

  void _loadDebts() async {
    final prefs = await SharedPreferences.getInstance();
    final debtStrings = prefs.getStringList('debts') ?? [];
    setState(() {
      _debts = debtStrings.map((debtString) => Debt.fromJson(debtString)).toList();
    });
  }

  void _saveDebts() async {
    final prefs = await SharedPreferences.getInstance();
    final debtStrings = _debts.map((debt) => debt.toJson()).toList();
    prefs.setStringList('debts', debtStrings);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) { // When navigating to Analytics page
        final analyticsModel = Provider.of<AnalyticsModel>(context, listen: false);
        analyticsModel.totalExpenses = getTotalExpenses(); // Update total expenses in AnalyticsModel
      }
    });
  }
   Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  double getTotalExpenses() {
    return _debts.fold(0, (sum, debt) => sum + debt.amount);
  }

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Homescreen(),
    Analytics(),
    Person(),
  ];
   
  void _clearDebts() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('debts'); // Clear all debts from SharedPreferences
  setState(() {
    _debts.clear(); // Clear local list
  });
}

 
  
 @override
Widget build(BuildContext context) {
  final incomeModel = Provider.of<IncomeModel>(context);
  return Scaffold(
    backgroundColor: Colors.white,
    body: _selectedIndex == 0
      ? CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
              sliver: SliverToBoxAdapter(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(234, 255, 255, 255),
                        shape: CircleBorder(
                          side: BorderSide(width: 0.1, color: primaryColor),
                        ),
                        padding: EdgeInsets.zero,
                        minimumSize: Size(55, 55),
                      ),
                      child: imageFile == null
                          ? Icon(Icons.person, size: 40, color: primaryColor)
                          : ClipOval(
                              child: Image.file(
                                imageFile!,
                                fit: BoxFit.contain,
                                width: 55,
                                height: 55,
                              ),
                            ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hey Hussein!', style: TextStyle(color: Colors.black, fontSize: 11, decoration: TextDecoration.none)),
                          SizedBox(height: 7),
                          Text('Hussein Ahmed', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
              SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20,),
            sliver: SliverToBoxAdapter(
              child: Container(
                height: 175,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text('Gross income', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                           SizedBox(height: 10,),
                           Container(
                            height: 55,
                            width: 180,
                            child: TextField(
                            controller: _controller,
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                            onChanged: (value) {
                            incomeModel.income = double.tryParse(value) ?? 0;
                            })
                           ),
                           
                        ],
                      ),
                    ),
                    Image.asset('images/Screenshot_2024-07-26_174140-removebg-preview.png', width: 140),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            sliver: SliverToBoxAdapter(
              child: const Text('Popular operations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            sliver: SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RentPage()),
                        );
                        if (result != null) {
                          setState(() {
                            _debts.add(result);
                            _saveDebts(); 
                          });
                        }
                      },
                      child: CategoryWidget(name: 'Rent', imagePath: 'images/Screenshot_2024-07-27_101428-removebg-preview.png'),
                    ),
                     GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UtilitiesPage()),
                        );
                        if (result != null) {
                          setState(() {
                            _debts.add(result);
                            _saveDebts(); 
                          });
                        }
                      },
                    child: CategoryWidget(name: 'Utilities', imagePath: 'images/Screenshot_2024-07-27_104448-removebg-preview.png')
                    ),
                     GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Foodpage()),
                        );
                        if (result != null) {
                          setState(() {
                            _debts.add(result);
                            _saveDebts(); 
                          });
                        }
                      },
                    child: CategoryWidget(name: 'Food', imagePath: 'images/Screenshot_2024-07-27_105127-removebg-preview.png')
                    ),
                  GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TransportPage()),
                        );
                        if (result != null) {
                          setState(() {
                            _debts.add(result);
                            _saveDebts(); 
                          });
                        }
                      },
                    child: CategoryWidget(name: 'Transport', imagePath: 'images/Screenshot_2024-07-27_110134-removebg-preview.png')
                    ),
                  GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LeisurePage()),
                        );
                        if (result != null) {
                          setState(() {
                            _debts.add(result);
                            _saveDebts(); 
                          });
                        }
                      },
                    child: CategoryWidget(name: 'Leisure', imagePath: 'images/Screenshot_2024-07-27_114939-removebg-preview.png')
                    ),
                  GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EducationPage()),
                        );
                        if (result != null) {
                          setState(() {
                            _debts.add(result);
                            _saveDebts(); 
                          });
                        }
                      },
                    child: CategoryWidget(name: 'Education', imagePath: 'images/Screenshot_2024-07-27_112004-removebg-preview.png')
                    ),
                  GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PersonalPage()),
                        );
                        if (result != null) {
                          setState(() {
                            _debts.add(result);
                            _saveDebts(); 
                          });
                        }
                      },
                    child: CategoryWidget(name: 'Personal', imagePath: 'images/8345667-removebg-preview.png')
                    ),
                  GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HealthPage()),
                        );
                        if (result != null) {
                          setState(() {
                            _debts.add(result);
                            _saveDebts(); 
                          });
                        }
                      },
                    child: CategoryWidget(name: 'Health', imagePath: 'images/Screenshot_2024-07-27_111702-removebg-preview.png')
                    ),
                  GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DebtsPage()),
                        );
                        if (result != null) {
                          setState(() {
                            _debts.add(result);
                            _saveDebts(); 
                          });
                        }
                      },
                    child: CategoryWidget(name: 'Debts', imagePath: 'images/Screenshot_2024-07-27_122908-removebg-preview.png')
                    ),
                  GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => InsurancePage()),
                        );
                        if (result != null) {
                          setState(() {
                            _debts.add(result);
                            _saveDebts(); 
                          });
                        }
                      },
                    child: CategoryWidget(name: 'Insurance', imagePath: 'images/Screenshot_2024-07-27_112705-removebg-preview.png')
                    ), 
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 8),
            sliver: SliverToBoxAdapter(
              child: const Text('Expenses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final debt = _debts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListTile(
                    title: Text(debt.title, style: TextStyle(fontSize: 16)),
                    subtitle: Text('${DateFormat('dd/MM/yyyy').format(debt.date)}', style: TextStyle(color: Colors.grey)),
                    trailing: Text('\$${debt.amount.toStringAsFixed(1)}', style: TextStyle(color: Colors.red, fontSize: 16)),
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryColor,
                        border: Border.all(width: .1, color: primaryColor),
                      ),
                      child: ClipOval(
                        child: debt.image.isEmpty
                          ? Icon(Icons.image, size: 50, color: Colors.grey)
                          : Image.asset(debt.image, height: 50, width: 50, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                );
              },
              childCount: _debts.length,
            ),
          ),
          SliverToBoxAdapter(
              child: Visibility(
                visible: _debts.isEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                  child: Center(
                    child: Text(
                      'Paid invoices will be added here',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
        ],
      )
        
      : _pages[_selectedIndex],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ),
   floatingActionButton: _selectedIndex == 0
        ? FloatingActionButton(
            
            foregroundColor: primaryColor,
            onPressed: _clearDebts,
            child: Icon(Icons.delete_forever),
            backgroundColor: Colors.white,
          )
        : null, // Set to null for other pages


  );
 }
}

class CategoryWidget extends StatelessWidget {
  final String name;
  final String imagePath;

  const CategoryWidget({required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: secondaryColor,
              border: Border.all(width: .1,color: primaryColor),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover,),
            ),
          ),
          const SizedBox(height: 10),
          Text(name, style: TextStyle(fontSize: 14)),
        ],
      ),
      
    );
  }
}       

