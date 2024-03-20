import 'package:flutter/material.dart';
import 'package:pica/shared/theme.dart';
import 'package:pica/ui/home/home_page.dart';

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

  // void _loginUser() async {
  //   ApiResponse response = await login(
  //       email: emailController.text, password: passwordController.text);

  //   if (response.error == null) {
  //     _saveAndRedirectToHome(response.data as AuthModel);
  //   } else {
  //     isLoading = false;
  //     dialogFailedLogin();
  //   }
  // }

  // void _saveAndRedirectToHome(AuthModel userModel) async {
  //   isLoading = false;
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.setInt('userId', userModel.id);
  //   await preferences.setString('email', userModel.email);
  //   await preferences.setString('name', userModel.name);
  //   print(userModel.role);
  //   if (userModel.role == 'penyelia') {
  //     await preferences.setString('role', 'verifikator');
  //   } else if (userModel.role == 'admin-dinas') {
  //     print('JALAN');
  //     await preferences.setString('role', 'dinas');
  //   } else {
  //     await preferences.setString('role', userModel.role);
  //   }
  //   await preferences.setString('token', userModel.token);

  //   // ignore: use_build_context_synchronously
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => BasePage(
  //                 role: userModel.role == 'penyelia'
  //                     ? 'verifikator'
  //                     : userModel.role == 'admin-dinas'
  //                         ? 'dinas'
  //                         : userModel.role,
  //               )),
  //       (route) => false);
  // }

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
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (route) => false);
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
              SizedBox(
                height: 75,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Don’t have an account?',
                              style: poppins.copyWith(
                                  color: neutral600, fontSize: 12)),
                          TextSpan(
                            text: ' Sign Up',
                            style: poppins.copyWith(
                                fontWeight: bold,
                                fontSize: 12,
                                color: const Color(0xFF186968)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dialogFailedLogin() {
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
              height: 150,
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
                      'Username dan kata sandi anda salah! silahkan cek kembali',
                      style: poppins.copyWith(fontSize: 12, color: neutral600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Text(
                          'Ganti kata sandi?',
                          style: poppins.copyWith(
                              fontWeight: medium,
                              fontSize: 12,
                              color: const Color(0xFFFA0D0D)),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFFFA0D0D),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
