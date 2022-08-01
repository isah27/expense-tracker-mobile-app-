import 'package:expense_tracker/db/expense_db.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/pages/insert_budget_page.dart';
import 'package:expense_tracker/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  //form key
  final _formKey = GlobalKey<FormState>();
  static int? userId;
  static String? username;
  //editing controller
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static String? loginError;
  static DataBaseHelper? _dbHelper;
  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DataBaseHelper.instance;
      loginError = "hi";
    });
  }

  @override
  Widget build(BuildContext context) {
    //mail field
    final emailField = TextFormField(
      autofocus: false,
      controller: mailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email");
        }
        // reg expression for mail validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        mailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Password is require to loggin");
        }
        if (value.length < 6) {
          return ("Enter valid password(Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //login button
    final logingButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Colors.indigo,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(mailController.text, passwordController.text);
        },
        child: const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    return Scaffold(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        "assets/tracker.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    emailField,
                    const SizedBox(
                      height: 30,
                    ),
                    passwordField,
                    SizedBox(
                      height: 25,
                      child: Text(
                        loginError!,
                        style: TextStyle(
                            color: loginError!.length != 2
                                ? Colors.red
                                : Colors.white,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    logingButton,
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Don't have an account?"),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () => checkUser(),
                          child: const Text(
                            "SignUp",
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      List<SignUp> user = await _dbHelper!.fetchUser(email, password);
      if (user.isNotEmpty) {
        if (user.first.email == email && user.first.password == password) {
          setState(() {
            userId = user.first.id;
            username = user.first.firstName! + " " + user.first.secondName!;
            loginError = "hi";
          });

          Navigator.pushAndRemoveUntil(
              (context),
              MaterialPageRoute(builder: (context) => const BudgetInputPage()),
              (route) => false);
        }
      } else {
        setState(() {
          loginError = "User not found!";
          Fluttertoast.showToast(msg: "User not found!");
        });
      }
    }
  }

//check if user table has data
  checkUser() async {
    int numOfUsers = await _dbHelper!.fetchAllUser();
    if (numOfUsers == 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const RegisterPage()));
    } else {
      setState(() {
        loginError = "Can't open multiple account";
      });
    }
  }
}
