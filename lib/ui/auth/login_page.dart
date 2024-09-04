import 'package:another_flushbar/flushbar.dart';
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
      // ignore: use_build_context_synchronously
      Flushbar(
        messageText: Row(
          children: [
            Image.asset(
              'assets/ic_warning.png',
              width: 13,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                response.error!,
                style: poppins.copyWith(
                    fontSize: 12, fontWeight: medium, color: Colors.white),
              ),
            )
          ],
        ),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(21),
        padding: const EdgeInsets.all(10),
        backgroundColor: const Color(0xFFFD4C4C),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
      ).show(context);
    }
  }

  void _saveAndRedirectToHome(AuthModel userModel) async {
    isLoading = false;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('userId', userModel.id);
    await preferences.setString('name', userModel.name);
    await preferences.setString('token', userModel.token);
    await preferences.setString('role', userModel.role);
    await preferences.setInt('teamId', userModel.teamId);
    await preferences.setString('kabupatenCode', userModel.kabupatenCode);
    await preferences.setString('kecamatanCode', userModel.kecamatanCode);
    await preferences.setString('kecamatanName', userModel.kecamatanName);
    if (userModel.kelurahanCode != null) {
      await preferences.setString('kelurahanCode', userModel.kelurahanCode!);
      await preferences.setString('kelurahanName', userModel.kelurahanName!);
    }

    await preferences.setString('colorHex', userModel.colorHex);

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
        MaterialPageRoute(
          builder: (context) => HomePage(
            role: userModel.role,
            name: userModel.name,
            kelurahanName: userModel.role == 'koordes'
                ? userModel.kelurahanName!
                : userModel.kecamatanName,
            colorHex: userModel.colorHex,
          ),
        ),
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
          child: Stack(
            children: [
              Column(
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
                                  side: const BorderSide(
                                      color: Color(0xFFC1C2C4)),
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = !isChecked;
                                    });
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
                          Flushbar(
                            messageText: Row(
                              children: [
                                Image.asset(
                                  'assets/ic_warning.png',
                                  width: 13,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    "Lengkapi email dan password Anda",
                                    style: poppins.copyWith(
                                        fontSize: 12,
                                        fontWeight: medium,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            duration: const Duration(seconds: 3),
                            margin: const EdgeInsets.all(21),
                            padding: const EdgeInsets.all(10),
                            backgroundColor: const Color(0xFFFD4C4C),
                            borderRadius: BorderRadius.circular(8),
                            flushbarPosition: FlushbarPosition.TOP,
                            flushbarStyle: FlushbarStyle.FLOATING,
                          ).show(context);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryMain),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: primaryMain,
                      )),
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
