import 'package:expense_tracker/db/expense_db.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/pages/login_page.dart';
import 'package:expense_tracker/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BudgetInputPage extends StatefulWidget {
  const BudgetInputPage({Key? key}) : super(key: key);

  @override
  State<BudgetInputPage> createState() => BudgetInputPageState();
}

class BudgetInputPageState extends State<BudgetInputPage> {
  //form key
  final _formKey = GlobalKey<FormState>();
  //creating an object for class Budget
  static Budget budget = Budget();
  // list of budget
  List<Budget> budgetData = [];
  //variable to hold selected budget id
  static int? bId;
  //variable to hold selected budget amount
  static int? bAmount;
  //variable to hold selected budget description
  static String? bDescription;
  // budget Description text edit controller
  final TextEditingController budgetDescController = TextEditingController();
// budget amount text edit controller
  final TextEditingController budgetAmountController = TextEditingController();
  //currency format
  final oCcy = NumberFormat("#,##0.00", "en_US");
  static DataBaseHelper? _dbHelper;
  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DataBaseHelper.instance;
    });
    fetchBudget();
  }

  @override
  Widget build(BuildContext context) {
    //budget description optional
    final budgetDescField = TextFormField(
      autofocus: false,
      controller: budgetDescController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        budget.description = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.description),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Budget Description(optional)",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //budget amount text field
    final budgetField = TextFormField(
      autofocus: false,
      controller: budgetAmountController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your Budget");
        }
        // reg expression for mail validation
        if (!RegExp("^[0-9+]+").hasMatch(value)) {
          return ("Enter a valid Budget");
        }
        //if(value.length>)
        return null;
      },
      onSaved: (value) {
        budget.amount = int.parse(value!);
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.attach_money),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Budget",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //login button
    final budgetButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Colors.indigo,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(10, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () => onSubmit(),
        child: Text(
          budget.id == null ? "Input Budget" : "Update Budget",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 46,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 200,
              child: Text(
                "WELCOME " + LoginPageState.username!.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w300),
                overflow: TextOverflow.fade,
              ),
            ),
            SizedBox(
              height: 35,
              child: Material(
                color: Colors.red.shade900,
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  onPressed: () {
                    //ActivityManager am=
                    SystemNavigator.pop();
                  },
                  child: const Text(
                    "Exit",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        "assets/tracker.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    budgetDescField,
                    const SizedBox(height: 20),
                    budgetField,
                    const SizedBox(height: 20),
                    budgetButton,
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 30,
                      child: Text(
                        "Budgets",
                        style: TextStyle(
                            color: Colors.indigo.shade600,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 350,
                      color: Colors.white,
                      child: Card(
                        color: Colors.white,
                        //margin: const EdgeInsets.fromLTRB(20, 30, 10, 10),
                        child: ListView.builder(
                          // padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Text(
                                    oCcy.format(budgetData[index].amount),
                                    style: const TextStyle(
                                        height: 2,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87),
                                  ),
                                  title: Text(
                                    budgetData[index].description!,
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  trailing: SizedBox(
                                    height: 30,
                                    width: 100,
                                    // color: Colors.white,
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.end,
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.indigo,
                                          ),
                                          onPressed: () {
                                            budget.id = budgetData[index].id;
                                            budgetDescController.text =
                                                budgetData[index].description!;
                                            budgetAmountController.text =
                                                budgetData[index]
                                                    .amount
                                                    .toString();
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 30,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            _dbHelper!.deleteBudget(
                                                budgetData[index].id!);
                                            fetchBudget();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      MainPageState.bId = budgetData[index].id;
                                      MainPageState.bAmount =
                                          budgetData[index].amount;
                                      bDescription =
                                          budgetData[index].description;
                                    });

                                    Navigator.pushAndRemoveUntil(
                                        (context),
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainPage()),
                                        (route) => false);
                                  },
                                ),
                                // Title(color: Colors.black, child: const Text("title")),

                                const Divider(height: 5),
                              ],
                            );
                          },
                          itemCount: budgetData.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  clearText() {
    budgetAmountController.clear();
    budgetDescController.clear();
  }

  onSubmit() async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      budget.userId = LoginPageState.userId;
      if (budget.id == null) {
        await _dbHelper?.insertBudget(budget);
      } else if (budget.id != null) {
        await _dbHelper?.updateBudget(budget);
        budget.id = null;
      }
      clearText();
      fetchBudget();
    }
  }

  fetchBudget() async {
    List<Budget> x = await _dbHelper!.fetchBudget(LoginPageState.userId!);
    setState(() {
      budgetData = x;
    });
  }
}
