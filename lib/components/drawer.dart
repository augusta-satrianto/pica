import 'package:flutter/material.dart';
import 'package:pica/services/auth_service.dart';
import 'package:pica/shared/theme.dart';
import 'package:pica/ui/auth/login_page.dart';
import 'package:pica/ui/home/comp/verifikasi_apk_page.dart';
import 'package:pica/ui/home/comp/verifikasi_kampanye_page.dart';
import 'package:pica/ui/home/comp/verifikasi_logistik_page.dart';
import 'package:pica/ui/home/comp/verifikasi_mobile_page.dart';
import 'package:pica/ui/home/home_page.dart';

class DrawerView extends StatelessWidget {
  final String pageActive;
  const DrawerView({super.key, required this.pageActive});

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 139 + paddingTop,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF186968),
                    Color(0xFF6BA3A2),
                    Color(0xFFD6EEEE),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 71.19,
                    height: 70,
                    margin: EdgeInsets.only(top: 20 + paddingTop, bottom: 5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD9D9D9),
                        ),
                        image: const DecorationImage(
                            image: AssetImage(
                              'assets/img_profile.png',
                            ),
                            fit: BoxFit.cover)),
                  ),
                  Text(
                    'Lorem Ipsum',
                    style: poppins.copyWith(
                        fontWeight: bold, fontSize: 16, color: Colors.white),
                  )
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 14,
                ),
                CustomMenuDrawer(
                  urlIcon: 'assets/ic_home.png',
                  title: 'Home',
                  onPressed: () {
                    pageActive == 'home'
                        ? Navigator.pop(context)
                        : Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false);
                  },
                ),
                CustomMenuDrawer(
                  urlIcon: 'assets/ic_logistik.png',
                  title: 'Verifikasi Logistik',
                  onPressed: () {
                    Navigator.pop(context);
                    if (pageActive == 'logistik upload') {
                      Navigator.pop(context);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifikasiLogistikPage(),
                        ),
                      );
                    }
                    if (pageActive != 'logistik' &&
                        pageActive != 'logistik upload') {
                      if (pageActive != 'home') {
                        Navigator.pop(context);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifikasiLogistikPage(),
                        ),
                      );
                    }
                  },
                ),
                CustomMenuDrawer(
                  urlIcon: 'assets/ic_mobile.png',
                  title: 'Verifikasi Mobile',
                  onPressed: () {
                    Navigator.pop(context);
                    if (pageActive != 'mobile') {
                      if (pageActive != 'home') {
                        Navigator.pop(context);
                      }
                      if (pageActive == 'logistik upload') {
                        Navigator.pop(context);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifikasiMobilePage(),
                        ),
                      );
                    }
                  },
                ),
                CustomMenuDrawer(
                  urlIcon: 'assets/ic_apk.png',
                  title: 'Verifikasi APK',
                  onPressed: () {
                    Navigator.pop(context);
                    if (pageActive != 'apk') {
                      if (pageActive != 'home') {
                        Navigator.pop(context);
                      }
                      if (pageActive == 'logistik upload') {
                        Navigator.pop(context);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifikasiApkPage(),
                        ),
                      );
                    }
                  },
                ),
                CustomMenuDrawer(
                  urlIcon: 'assets/ic_kampanye.png',
                  title: 'Verifikasi Kampanye',
                  onPressed: () {
                    Navigator.pop(context);
                    if (pageActive != 'kampanye') {
                      if (pageActive != 'home') {
                        Navigator.pop(context);
                      }
                      if (pageActive == 'logistik upload') {
                        Navigator.pop(context);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifikasiKampanyePage(),
                        ),
                      );
                    }
                  },
                ),
                CustomMenuDrawer(
                  urlIcon: 'assets/ic_kampanye.png',
                  title: 'Logout',
                  onPressed: () {
                    logout().then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomMenuDrawer extends StatelessWidget {
  final String urlIcon;
  final String title;
  final VoidCallback onPressed;
  const CustomMenuDrawer(
      {super.key,
      required this.urlIcon,
      required this.title,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        elevation: MaterialStateProperty.all<double>(0),
        overlayColor: MaterialStateProperty.all<Color?>(Colors.grey[300]),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 14,
          ),
          Row(
            children: [
              Image.asset(
                urlIcon,
                width: 35,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: poppins.copyWith(
                    fontWeight: medium, color: const Color(0xFF232323)),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: EdgeInsets.only(left: 50),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Color(0xFFEDEDED),
            ),
          ),
        ],
      ),
    );
  }
}
