import 'package:flutter/material.dart';
import 'package:pica/components/drawer.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/models/dashboard_model.dart';
import 'package:pica/services/dashboard_service.dart';
import 'package:pica/shared/theme.dart';
import 'package:pica/ui/home/comp/verifikasi_apk_page.dart';
import 'package:pica/ui/home/comp/verifikasi_kampanye_page.dart';
import 'package:pica/ui/home/comp/verifikasi_logistik_page.dart';
import 'package:pica/ui/home/comp/verifikasi_mobile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DashboardModel? dashboardModel;
  void _getDashboard() async {
    ApiResponse response = await getDashboard();
    if (response.error == null) {
      dashboardModel = response.data as DashboardModel;
      setState(() {});
    } else {
      // ignore: use_build_context_synchronously
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getDashboard();
  }

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
                            margin: const EdgeInsets.only(right: 10),
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

            // Verifikasi Logistik
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
                    text: 'Detail',
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
            CustomVerifikasi(
              title: 'Verifikasi Mobile',
              countTotal: dashboardModel != null
                  ? dashboardModel!.validasiMobile.total.toString()
                  : '',
              countValid: dashboardModel != null
                  ? dashboardModel!.validasiMobile.valid.toString()
                  : '',
              countInvalid: dashboardModel != null
                  ? dashboardModel!.validasiMobile.invalid.toString()
                  : '',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerifikasiMobilePage(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 27,
            ),
            //Verifikasi APK
            CustomVerifikasi(
              title: 'Verifikasi APK',
              countTotal: dashboardModel != null
                  ? dashboardModel!.validasiAPK.total.toString()
                  : '',
              countValid: dashboardModel != null
                  ? dashboardModel!.validasiAPK.valid.toString()
                  : '',
              countInvalid: dashboardModel != null
                  ? dashboardModel!.validasiAPK.invalid.toString()
                  : '',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerifikasiApkPage(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 27,
            ),

            //Verifikasi Kampanye
            CustomVerifikasi(
              title: 'Verifikasi Kampanye',
              countTotal: dashboardModel != null
                  ? dashboardModel!.validasiKampanye.total.toString()
                  : '',
              countValid: dashboardModel != null
                  ? dashboardModel!.validasiKampanye.valid.toString()
                  : '',
              countInvalid: dashboardModel != null
                  ? dashboardModel!.validasiKampanye.invalid.toString()
                  : '',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerifikasiKampanyePage(),
                  ),
                );
              },
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

class CustomVerifikasi extends StatelessWidget {
  final String title;
  final String countTotal;
  final String countValid;
  final String countInvalid;
  final VoidCallback onPressed;
  const CustomVerifikasi(
      {super.key,
      required this.title,
      required this.countTotal,
      required this.countValid,
      required this.countInvalid,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            title,
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
            countTotal,
            style: poppins.copyWith(
                fontWeight: bold, fontSize: 16, color: const Color(0xFF232323)),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Valid',
                    style: poppins.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                        color: const Color(0xFF808080)),
                  ),
                  Text(
                    countValid,
                    style: poppins.copyWith(
                        fontWeight: bold,
                        fontSize: 12,
                        color: const Color(0xFF232323)),
                  )
                ],
              ),
              const SizedBox(
                width: 30,
              ),
              Column(
                children: [
                  Text(
                    'Invalid',
                    style: poppins.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                        color: const Color(0xFF808080)),
                  ),
                  Text(
                    countInvalid,
                    style: poppins.copyWith(
                        fontWeight: bold,
                        fontSize: 12,
                        color: const Color(0xFF232323)),
                  )
                ],
              ),
            ],
          ),
          const Spacer(),
          CustomButtonAdd(onPressed: onPressed)
        ],
      ),
    );
  }
}

class CustomButtonAdd extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const CustomButtonAdd(
      {super.key, required this.onPressed, this.text = 'Tambah'});

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
          Image.asset(
            text == 'Tambah'
                ? 'assets/ic_circle_plus.png'
                : 'assets/ic_circle_arrow_r.png',
            width: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
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
