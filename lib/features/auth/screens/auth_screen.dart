import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/common/custom_button.dart';
import 'package:budget_tracker/common/custom_text_field.dart';
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/features/auth/services/auth_service.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _onAuthModeChanged(Auth mode) {
    setState(() {
      _auth = mode;
      _animationController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: GlobalVariables.appBarGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 300,
                    child: CupertinoSegmentedControl(
                      children: {
                        Auth.signup: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              color: _auth == Auth.signup
                                  ? Colors.white
                                  : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Auth.signin: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: _auth == Auth.signin
                                  ? Colors.white
                                  : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      },
                      groupValue: _auth,
                      onValueChanged: (value) => _onAuthModeChanged(value),
                      borderColor: GlobalVariables.secondaryColor,
                      selectedColor: GlobalVariables.secondaryColor,
                      unselectedColor: GlobalVariables.backgroundColor,
                      pressedColor: GlobalVariables.utilityColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedCrossFade(
                  firstChild: _buildSignUpForm(),
                  secondChild: _buildSignInForm(),
                  crossFadeState: _auth == Auth.signup
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: GlobalVariables.utilityColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _signUpFormKey,
        child: Column(
          children: [
            CustomTextField(
              textEditingController: _nameController,
              hintText: 'Name',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              textEditingController: _emailController,
              hintText: 'Email',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              textEditingController: _passwordController,
              hintText: 'Password',
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Sign Up',
              onTap: () {
                if (_signUpFormKey.currentState!.validate()) {
                  signUpUser();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: GlobalVariables.utilityColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _signInFormKey,
        child: Column(
          children: [
            CustomTextField(
              textEditingController: _emailController,
              hintText: 'Email',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              textEditingController: _passwordController,
              hintText: 'Password',
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Sign In',
              onTap: () {
                if (_signInFormKey.currentState!.validate()) {
                  signInUser();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
