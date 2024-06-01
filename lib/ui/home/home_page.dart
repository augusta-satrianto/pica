import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pica/components/drawer.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/models/dashboard_model.dart';
import 'package:pica/services/dashboard_service.dart';
import 'package:pica/shared/theme.dart';
import 'package:pica/ui/home/comp/quick_count_page.dart';
import 'package:pica/ui/verifikasi_apk/invalid_apk.dart';
import 'package:pica/ui/verifikasi_apk/valid_apk.dart';
import 'package:pica/ui/verifikasi_apk/verifikasi_apk_page.dart';
import 'package:pica/ui/verifikasi_kampanye/invalid_mobile.dart';
import 'package:pica/ui/verifikasi_kampanye/valid_mobile.dart';
import 'package:pica/ui/verifikasi_mobile/invalid_mobile.dart';
import 'package:pica/ui/verifikasi_mobile/valid_mobile.dart';
import 'package:pica/ui/verifikasi_kampanye/verifikasi_kampanye_page.dart';
import 'package:pica/ui/verifikasi_mobile/verifikasi_mobile_page.dart';

class HomePage extends StatefulWidget {
  final String role;
  final String name;
  const HomePage({super.key, required this.role, required this.name});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DashboardModel? dashboardModel;

  bool isFirst = true;
  void _getDashboard() async {
    ApiResponse response = await getDashboard();
    if (response.error == null) {
      dashboardModel = response.data as DashboardModel;
      if (mounted) {
        setState(() {});
      }
      await Future.delayed(const Duration(milliseconds: 3000));
      isFirst = false;
      _getDashboard();
    } else {
      if (isFirst) {
        isFirst = false;
        await Future.delayed(const Duration(milliseconds: 3000));
        if (mounted) {
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
                    'Periksa koneksi internet anda',
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
        _getDashboard();
      } else {
        await Future.delayed(const Duration(milliseconds: 3000));
        _getDashboard();
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
      backgroundColor: const Color(0xFFFAFAFA),
      drawer: DrawerView(
        pageActive: 'home',
        role: widget.role,
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: [
            Container(
              height: 244,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/img_appbar_home.png'),
                      fit: BoxFit.cover)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: paddingTop + 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
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
                        dashboardModel == null ||
                                dashboardModel!.team.fotoAtas == null
                            ? Container(
                                width: 45.76,
                                height: 45,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                          'assets/img_profile.png',
                                        ),
                                        fit: BoxFit.cover)),
                              )
                            : Container(
                                width: 45.76,
                                height: 45,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            dashboardModel!.team.fotoAtas!),
                                        fit: BoxFit.cover)),
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
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
                          widget.name,
                          style: poppins.copyWith(
                              fontWeight: bold,
                              fontSize: 30,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 25,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                  )
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.fromLTRB(30, 46, 30, 27),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                        height: 55,
                      ),
                      Text(
                        dashboardModel != null
                            ? dashboardModel!.team.name!
                            : '',
                        textAlign: TextAlign.center,
                        style: poppins.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                            color: const Color(0xFF186968)),
                      ),
                      Text(
                        dashboardModel != null
                            ? dashboardModel!.team.partai!
                            : '',
                        textAlign: TextAlign.center,
                        style: poppins.copyWith(
                            fontWeight: medium, color: const Color(0xFF232323)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 9.5, bottom: 4.5),
                        height: 1,
                        width: double.infinity,
                        color: const Color(0xFFD6D6D6),
                      ),
                      Text(
                        'Visi',
                        style: poppins.copyWith(
                            fontSize: 12,
                            fontWeight: medium,
                            color: const Color(0xFF404040)),
                      ),
                      if (dashboardModel != null)
                        Column(children: [
                          CustomVisiMisi(text: dashboardModel!.team.visi1!),
                          if (dashboardModel!.team.visi2 != null)
                            CustomVisiMisi(text: dashboardModel!.team.visi2!),
                          if (dashboardModel!.team.visi3 != null)
                            CustomVisiMisi(text: dashboardModel!.team.visi3!),
                          if (dashboardModel!.team.visi4 != null)
                            CustomVisiMisi(text: dashboardModel!.team.visi3!),
                          if (dashboardModel!.team.visi5 != null)
                            CustomVisiMisi(text: dashboardModel!.team.visi3!),
                        ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Misi',
                        style: poppins.copyWith(
                            fontSize: 12,
                            fontWeight: medium,
                            color: const Color(0xFF404040)),
                      ),
                      if (dashboardModel != null)
                        Column(children: [
                          CustomVisiMisi(text: dashboardModel!.team.misi1!),
                          if (dashboardModel!.team.misi2 != null)
                            CustomVisiMisi(text: dashboardModel!.team.misi2!),
                          if (dashboardModel!.team.misi3 != null)
                            CustomVisiMisi(text: dashboardModel!.team.misi3!),
                          if (dashboardModel!.team.misi4 != null)
                            CustomVisiMisi(text: dashboardModel!.team.misi3!),
                          if (dashboardModel!.team.misi5 != null)
                            CustomVisiMisi(text: dashboardModel!.team.misi3!),
                        ]),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dashboardModel == null ||
                            dashboardModel!.team.fotoBawah == null
                        ? Container(
                            width: 93,
                            height: 93,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/img_profile2.png',
                                  ),
                                  fit: BoxFit.cover),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: 93,
                            height: 93,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      dashboardModel!.team.fotoBawah!),
                                  fit: BoxFit.cover),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ],
            ),

            //Verifikasi Mobile
            ['koordes', 'koortps', 'relawan'].contains(widget.role)
                ? CustomVerifikasi(
                    title: 'Verifikasi Mobile',
                    countTotal: dashboardModel != null
                        ? dashboardModel!.verifikasiMobile.total.toString()
                        : '-',
                    countValid: dashboardModel != null
                        ? dashboardModel!.verifikasiMobile.valid.toString()
                        : '-',
                    countInvalid: dashboardModel != null
                        ? dashboardModel!.verifikasiMobile.invalid.toString()
                        : '-',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifikasiMobilePage(
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                    onPressedValid: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ValidMobilePage(
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                    onPressedInvalid: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvalidMobilePage(
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                  )
                : Container(),
            const SizedBox(
              height: 27,
            ),

            //Verifikasi APK
            ['koordes', 'koortps', 'relawan'].contains(widget.role)
                ? CustomVerifikasi(
                    title: 'Verifikasi APK',
                    countTotal: dashboardModel != null
                        ? dashboardModel!.verifikasiAPK.total.toString()
                        : '-',
                    countValid: dashboardModel != null
                        ? dashboardModel!.verifikasiAPK.valid.toString()
                        : '-',
                    countInvalid: dashboardModel != null
                        ? dashboardModel!.verifikasiAPK.invalid.toString()
                        : '-',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifikasiApkPage(
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                    onPressedValid: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ValidApkPage(
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                    onPressedInvalid: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvalidApkPage(
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                  )
                : Container(),
            const SizedBox(
              height: 27,
            ),

            //Verifikasi Kampanye
            ['koordes', 'koortps', 'relawan'].contains(widget.role)
                ? CustomVerifikasi(
                    title: 'Verifikasi Kampanye',
                    countTotal: dashboardModel != null
                        ? dashboardModel!.verifikasiKampanye.total.toString()
                        : '-',
                    countValid: dashboardModel != null
                        ? dashboardModel!.verifikasiKampanye.valid.toString()
                        : '-',
                    countInvalid: dashboardModel != null
                        ? dashboardModel!.verifikasiKampanye.invalid.toString()
                        : '-',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifikasiKampanyePage(
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                    onPressedValid: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ValidKampanyePage(
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                    onPressedInvalid: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvalidKampanyePage(
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                  )
                : Container(),
            const SizedBox(
              height: 27,
            ),

            //Quick Count
            CustomCount(
              title: 'Quick Count',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuickCountPage(
                      role: widget.role,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 27,
            ),

            // //Real Count
            // CustomCount(
            //   title: 'Real Count',
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => QuickCountPage(
            //           role: widget.role,
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // const SizedBox(
            //   height: 27,
            // ),
          ],
        ),
      ),
    );
  }
}

class CustomVisiMisi extends StatelessWidget {
  final String text;
  const CustomVisiMisi({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 7, top: 6),
          height: 2.5,
          width: 2.5,
          decoration: const BoxDecoration(
              color: Color(0xFF808080), shape: BoxShape.circle),
        ),
        Expanded(
          child: Text(
            text,
            style:
                poppins.copyWith(fontSize: 10, color: const Color(0xFF808080)),
          ),
        ),
      ],
    );
  }
}

class CustomVerifikasi extends StatelessWidget {
  final String title;
  final String countTotal;
  final String countValid;
  final String countInvalid;
  final VoidCallback onPressed;
  final VoidCallback onPressedValid;
  final VoidCallback onPressedInvalid;
  const CustomVerifikasi(
      {super.key,
      required this.title,
      required this.countTotal,
      required this.countValid,
      required this.countInvalid,
      required this.onPressed,
      required this.onPressedValid,
      required this.onPressedInvalid});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 215,
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
                fontSize: 18,
                color: const Color(0xFF186968)),
          ),
          const SizedBox(
            height: 9,
          ),
          Text(
            'TOTAL',
            style: poppins.copyWith(
                fontWeight: medium, color: const Color(0xFF808080)),
          ),
          Text(
            countTotal,
            style: poppins.copyWith(
                fontWeight: bold, fontSize: 18, color: const Color(0xFF232323)),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: onPressedValid,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 60) / 3,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Color(0xFFD6EEEE)],
                    ),
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
                      Text(
                        'Valid',
                        style: poppins.copyWith(
                            fontWeight: medium, color: const Color(0xFF808080)),
                      ),
                      Text(
                        countValid,
                        style: poppins.copyWith(
                            fontWeight: bold, color: const Color(0xFF232323)),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: onPressedInvalid,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 60) / 3,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Color(0xFFD6EEEE)],
                    ),
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
                      Text(
                        'Invalid',
                        style: poppins.copyWith(
                            fontWeight: medium, color: const Color(0xFF808080)),
                      ),
                      Text(
                        countInvalid,
                        style: poppins.copyWith(
                            fontWeight: bold, color: const Color(0xFF232323)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Spacer(),
          CustomButtonAdd(onPressed: onPressed)
        ],
      ),
    );
  }
}

class CustomCount extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const CustomCount({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 135,
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
          const Spacer(),
          Text(
            title,
            style: poppins.copyWith(
                fontWeight: semiBold,
                fontSize: 18,
                color: const Color(0xFF186968)),
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
