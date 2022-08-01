import 'package:expense_tracker/db/expense_db.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/pages/login_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //form key
  final _formKey = GlobalKey<FormState>();
  //SignUp class object
  static SignUp user = SignUp();
  // editing controllers
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  static DataBaseHelper? _dbHelper;
  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DataBaseHelper.instance;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Register button
    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Colors.indigo,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp();
        },
        child: const Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    //firstName field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Enter your first name");
        }
        if (value.length < 3) {
          return ("Enter valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        user.firstName = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "First Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //secondName field
    final secondNameField = TextFormField(
      autofocus: false,
      controller: secondNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Enter your first name");
        }

        return null;
      },
      onSaved: (value) {
        user.secondName = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Second Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
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
        user.email = value!;
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
          return ("Password is require for registration");
        }
        if (value.length < 6) {
          return ("Enter valid password(Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //confirm field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: confirmPasswordController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("This field is require for registration");
        }
        if (passwordController.text != value) {
          return ("Password dont match");
        }
        return null;
      },
      onSaved: (value) {
        user.password = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Re-Type Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
      ),
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
                    const SizedBox(height: 30),
                    firstNameField,
                    const SizedBox(height: 30),
                    secondNameField,
                    const SizedBox(height: 30),
                    emailField,
                    const SizedBox(height: 30),
                    passwordField,
                    const SizedBox(height: 30),
                    confirmPasswordField,
                    const SizedBox(height: 30),
                    registerButton,
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      await _dbHelper!.insertUser(user);
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    }
  }
}
