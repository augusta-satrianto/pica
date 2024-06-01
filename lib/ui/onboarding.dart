import 'package:flutter/material.dart';
import 'package:pica/shared/theme.dart';
import 'package:pica/ui/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: _currentPage == 0
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                end: _currentPage == 0
                    ? Alignment.bottomCenter
                    : Alignment.topCenter,
                colors: const [Colors.white, Color(0xFFB1DCDB)],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/img_splash_u.png',
                  width: 180,
                ),
              ),
              _currentPage == 0
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'assets/img_splash_b.png',
                        width: 180,
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: 2,
              itemBuilder: (context, i) {
                return i == 0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/img_logo.png',
                            width: MediaQuery.of(context).size.width * 7 / 10,
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Image.asset(
                            'assets/img_logo_circle.png',
                            width: MediaQuery.of(context).size.width * 5 / 10,
                          ),
                          const SizedBox(
                            height: 26,
                          ),
                          Text(
                            'Mobile Application',
                            style: poppins.copyWith(
                                fontSize: 24,
                                fontWeight: semiBold,
                                color: const Color(0xFF186968)),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(top: 8.5, bottom: 11.5),
                            width: 235,
                            height: 1,
                            color: const Color(0xFF186968),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Supported by ',
                                  style: poppins.copyWith(
                                      fontSize: 12,
                                      color: const Color(0xFF186968))),
                              Image.asset(
                                'assets/img_logo.png',
                                width: 32,
                              ),
                            ],
                          ),
                          const Spacer(),
                          _currentPage == 1
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      SharedPreferences.getInstance()
                                          .then((prefs) {
                                        prefs.setBool('isFirstTime', false);
                                      });
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()),
                                          (route) => false);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              primaryMain),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      shadowColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(0, 0, 0, 1),
                                      ),
                                      elevation:
                                          MaterialStateProperty.all<double>(4),
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                              const Size(double.infinity, 47)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                )
                              : Container(),
                          const SizedBox(
                            height: 34 + 50 + 7,
                          ),
                        ],
                      );
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    2,
                    (int index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 7,
                          width: 7,
                          decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? const Color(0xFF186968)
                                  : const Color(0xFF186968).withOpacity(0.5),
                              shape: BoxShape.circle),
                        )),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ],
      ),
    );
  }
}
