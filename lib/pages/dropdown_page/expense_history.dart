import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/pages/login_page.dart';
import 'package:expense_tracker/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../db/expense_db.dart';

class ExpenseHistory extends StatefulWidget {
  const ExpenseHistory({Key? key}) : super(key: key);
  @override
  State<ExpenseHistory> createState() => _ExpenseHistoryState();
}

class _ExpenseHistoryState extends State<ExpenseHistory> {
  final oCcy = NumberFormat("#,##0.00", "en_US");
  DataBaseHelper? _dbHelper;
  List<Expense> expense = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DataBaseHelper.instance;
      fetchExpense();
    });
    fetchExpense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      (context),
                      MaterialPageRoute(
                          builder: (context) => const MainPage()));
                },
                icon: const Icon(Icons.home, size: 30, color: Colors.white)),
            const Text("Expense"),
            const SizedBox(width: 5),
            const Text("History"),
          ],
        ),
      ),
      body: Container(
        height: double.maxFinite,
        color: Colors.white,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(20, 30, 10, 10),
          child: ListView.builder(
            // padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Text(
                      oCcy.format(int.parse(expense[index].price!)),
                      style: const TextStyle(
                          height: 2,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                    title: Text(
                      expense[index].description!,
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w400),
                    ),
                    subtitle: Text(expense[index].date!),
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
                              size: 30,
                              color: Colors.indigo,
                            ),
                            onPressed: () {
                              MainPageState.budgetDescriptionController.text =
                                  expense[index].description!;
                              MainPageState.budgetCostController.text =
                                  expense[index].price.toString();
                              MainPageState.expense.id = expense[index].id;
                              MainPageState.initPrice =
                                  int.parse(expense[index].price!);
                              MainPageState.chartExpense.bId =
                                  expense[index].bId;
                              MainPageState.chartExpense.date =
                                  expense[index].date;
                              MainPageState.expense.bId = expense[index].bId;
                              MainPageState.chartExpense.userId =
                                  LoginPageState.userId;
                              MainPageState.expense.userId =
                                  LoginPageState.userId;
                              Navigator.pushReplacement(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (context) => const MainPage()));
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              //setState

                              _dbHelper!.deleteFromSumInDays(ChartExpense(
                                  id: expense[index].id!,
                                  userId: LoginPageState.userId,
                                  bId: expense[index].bId,
                                  price: expense[index].price,
                                  date: expense[index].date));
                              _dbHelper?.deleteExpense(expense[index].id!);
                              fetchExpense();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Title(color: Colors.black, child: const Text("title")),

                  const Divider(height: 5),
                ],
              );
            },
            itemCount: expense.length,
          ),
        ),
      ),
    );
  }

  fetchExpense() async {
    List<Expense> x = await _dbHelper!.fetchExpense(MainPageState.bId);
    setState(() {
      expense = x;
    });
  }

 
}
