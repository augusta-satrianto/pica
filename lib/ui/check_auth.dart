import 'package:flutter/material.dart';
import 'package:pica/shared/theme.dart';
import 'package:pica/ui/auth/login_page.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key}) : super(key: key);

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  void _checkToken() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    // String token = await getToken();
    // if (token == '') {
    //   // ignore: use_build_context_synchronously
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => const LoginPage()),
    //       (route) => false);
    // } else {
    //   // ignore: use_build_context_synchronously
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => BasePage(
    //                 role: role,
    //               )),
    //       (route) => false);
    // }
  }

  @override
  void initState() {
    _checkToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color(0xFFB1DCDB)
                ], // Ganti warna sesuai keinginan
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img_logo.png',
                    width: MediaQuery.of(context).size.width * 7 / 10,
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/img_splash_u.png',
                width: 180,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 75),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
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
                        'Get Started',
                        style: poppins.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: semiBold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/ic_arrow_r.png',
                        width: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
