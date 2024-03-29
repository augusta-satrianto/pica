import 'package:flutter/material.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/models/auth_model.dart';
import 'package:pica/services/auth_service.dart';
import 'package:pica/shared/theme.dart';
import 'package:pica/ui/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isObscure = true;
  bool isChecked = false;

  void _loginUser() async {
    ApiResponse response = await login(
        email: emailController.text, password: passwordController.text);

    if (response.error == null) {
      _saveAndRedirectToHome(response.data as AuthModel);
    } else {
      isLoading = false;
      dialogFailedLogin(
          'Email atau kata sandi anda salah! silahkan cek kembali');
    }
  }

  void _saveAndRedirectToHome(AuthModel userModel) async {
    isLoading = false;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('userId', userModel.id);
    await preferences.setString('name', userModel.name);
    await preferences.setString('token', userModel.token);

    if (isChecked) {
      await preferences.setString('emaillogin', emailController.text);
      await preferences.setString('passwordlogin', passwordController.text);
    } else {
      await preferences.remove('emaillogin');
      await preferences.remove('passwordlogin');
    }

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  void checkRemember() async {
    String emaillogin = await getEmailLogin();
    String passwordlogin = await getPasswordLogin();
    setState(() {
      if (emaillogin.isNotEmpty) {
        emailController.text = emaillogin;
        passwordController.text = passwordlogin;
        isChecked = true;
      }
    });
  }

  @override
  void initState() {
    checkRemember();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: mediaQueryHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/img_splash_u.png',
                  width: 180,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img_logo.png',
                    width: MediaQuery.of(context).size.width * 7 / 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: emailController,
                      style: poppins.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                          color: const Color(0xFF808080)),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: poppins.copyWith(
                            fontSize: 16,
                            fontWeight: medium,
                            color: const Color(0xFF808080)),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Image.asset(
                            'assets/ic_user.png',
                            width: 20,
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF808080)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF808080)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: isObscure,
                      style: poppins.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                          color: const Color(0xFF808080)),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: poppins.copyWith(
                            fontSize: 16,
                            fontWeight: medium,
                            color: const Color(0xFF808080)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF808080)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF808080)),
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(isObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            color: const Color(0xFF808080),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          child: Checkbox(
                              value: isChecked,
                              activeColor: const Color(0xFF186968),
                              side: const BorderSide(color: Color(0xFFC1C2C4)),
                              onChanged: (value) {
                                isChecked = !isChecked;
                                setState(() {});
                              }),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Remember Me',
                          style: poppins.copyWith(
                              color: const Color(0xFF808080),
                              fontSize: 12,
                              fontWeight: medium),
                        ),
                        const Spacer(),
                        Text(
                          'Forgot Password?',
                          style: poppins.copyWith(
                              fontSize: 12,
                              fontWeight: semiBold,
                              color: Color(0xFF186968)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (emailController.text.trim().isNotEmpty &&
                        passwordController.text.trim().isNotEmpty &&
                        !isLoading) {
                      isLoading = true;
                      _loginUser();
                    } else {
                      dialogFailedLogin('Lengkapi Email dan Kata Sandi');
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryMain),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    shadowColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(0, 0, 0, 1),
                    ),
                    elevation: MaterialStateProperty.all<double>(4),
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(double.infinity, 47)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        style: poppins.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: semiBold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 75,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dialogFailedLogin(String text) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              width: 290,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: neutral100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: neutral100,
                        margin: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/ic_close_circle.png',
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Anda tidak bisa masuk!',
                      style: poppins.copyWith(
                          fontWeight: semiBold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Text(
                      text,
                      style: poppins.copyWith(fontSize: 12, color: neutral600),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
