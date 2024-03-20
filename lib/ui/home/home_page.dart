import 'package:flutter/material.dart';
import 'package:pica/components/drawer.dart';
import 'package:pica/shared/theme.dart';
import 'package:pica/ui/home/comp/verifikasi_apk_page.dart';
import 'package:pica/ui/home/comp/verifikasi_kampanye_page.dart';
import 'package:pica/ui/home/comp/verifikasi_logistik_page.dart';
import 'package:pica/ui/home/comp/verifikasi_mobile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const DrawerView(
        pageActive: 'home',
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  height: 244,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/img_appbar_home.png'),
                          fit: BoxFit.cover)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: paddingTop + 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(builder: (context) {
                            return IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: Image.asset(
                                'assets/ic_menu.png',
                                width: 30,
                              ),
                            );
                          }),
                          Container(
                            width: 45.76,
                            height: 45,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFD9D9D9),
                                ),
                                image: DecorationImage(
                                    image: AssetImage(
                                      'assets/img_profile.png',
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat Datang,',
                              style: poppins.copyWith(
                                  fontWeight: bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                            Text(
                              'LOREM IPSUM',
                              style: poppins.copyWith(
                                  fontWeight: bold,
                                  fontSize: 30,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 220,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 137 / 4,
                        width: 300 / 4,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/left.png'),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        height: 137 / 4,
                        width: MediaQuery.of(context).size.width - 150,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/middle.png'),
                                fit: BoxFit.fitHeight)),
                      ),
                      Container(
                        height: 137 / 4,
                        width: 300 / 4,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/right.png'),
                                fit: BoxFit.cover)),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Container(
              width: double.infinity,
              height: 117,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFD6EEEE), Colors.white],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.23),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 36,
                  ),
                  Text(
                    'Verifikasi Logistik',
                    style: poppins.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                        color: const Color(0xFF186968)),
                  ),
                  const Spacer(),
                  CustomButtonAdd(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifikasiLogistikPage(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 27,
            ),

            //Verifikasi Mobile
            Container(
              width: double.infinity,
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFD6EEEE), Colors.white],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.23),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Verifikasi Mobile',
                    style: poppins.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                        color: const Color(0xFF186968)),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Text(
                    'TOTAL',
                    style: poppins.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                        color: const Color(0xFF808080)),
                  ),
                  Text(
                    '50',
                    style: poppins.copyWith(
                        fontWeight: bold,
                        fontSize: 16,
                        color: const Color(0xFF232323)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HomeWidget1(title: 'Valid', value: 43),
                      SizedBox(
                        width: 30,
                      ),
                      HomeWidget1(title: 'Invalid', value: 7),
                    ],
                  ),
                  const Spacer(),
                  CustomButtonAdd(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifikasiMobilePage(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 27,
            ),
            //Verifikasi APK
            Container(
              width: double.infinity,
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFD6EEEE), Colors.white],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.23),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Verifikasi APK',
                    style: poppins.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                        color: const Color(0xFF186968)),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Text(
                    'TOTAL',
                    style: poppins.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                        color: const Color(0xFF808080)),
                  ),
                  Text(
                    '50',
                    style: poppins.copyWith(
                        fontWeight: bold,
                        fontSize: 16,
                        color: const Color(0xFF232323)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HomeWidget1(title: 'Valid', value: 43),
                      SizedBox(
                        width: 30,
                      ),
                      HomeWidget1(title: 'Invalid', value: 7),
                    ],
                  ),
                  const Spacer(),
                  CustomButtonAdd(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifikasiApkPage(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 27,
            ),

            //Verifikasi Kampanye
            Container(
              width: double.infinity,
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFD6EEEE), Colors.white],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.23),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Verifikasi Kampanye',
                    style: poppins.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                        color: const Color(0xFF186968)),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Text(
                    'TOTAL',
                    style: poppins.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                        color: const Color(0xFF808080)),
                  ),
                  Text(
                    '50',
                    style: poppins.copyWith(
                        fontWeight: bold,
                        fontSize: 16,
                        color: const Color(0xFF232323)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HomeWidget1(title: 'Valid', value: 43),
                      SizedBox(
                        width: 30,
                      ),
                      HomeWidget1(title: 'Invalid', value: 7),
                    ],
                  ),
                  const Spacer(),
                  CustomButtonAdd(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifikasiKampanyePage(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 27,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeWidget1 extends StatelessWidget {
  final String title;
  final int value;
  const HomeWidget1({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: poppins.copyWith(
              fontWeight: medium, fontSize: 12, color: const Color(0xFF808080)),
        ),
        Text(
          value.toString(),
          style: poppins.copyWith(
              fontWeight: bold, fontSize: 12, color: const Color(0xFF232323)),
        )
      ],
    );
  }
}

class CustomButtonAdd extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomButtonAdd({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xFF186968).withOpacity(0.8),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(double.infinity, 41),
        ),
      ).merge(
        ElevatedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_circle_outline,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Tambah',
            style: poppins.copyWith(
              color: Colors.white,
              fontSize: 12,
              fontWeight: semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
