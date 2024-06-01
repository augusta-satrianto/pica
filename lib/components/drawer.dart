import 'package:flutter/material.dart';
import 'package:pica/services/auth_service.dart';
import 'package:pica/shared/theme.dart';
import 'package:pica/ui/auth/login_page.dart';
import 'package:pica/ui/home/comp/quick_count_page.dart';
import 'package:pica/ui/verifikasi_apk/verifikasi_apk_page.dart';
import 'package:pica/ui/home/home_page.dart';
import 'package:pica/ui/verifikasi_mobile/verifikasi_mobile_page.dart';

class DrawerView extends StatefulWidget {
  final String pageActive;
  final String role;
  const DrawerView({
    super.key,
    required this.pageActive,
    required this.role,
  });

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  String name = '';
  _getPrev() async {
    name = await getName();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _getPrev();
    super.initState();
  }

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
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/img_profile.png',
                            ),
                            fit: BoxFit.cover)),
                  ),
                  Text(
                    name,
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
                // Home
                CustomMenuDrawer(
                  urlIcon: 'assets/ic_home.png',
                  title: 'Home',
                  onPressed: () {
                    widget.pageActive == 'home'
                        ? Navigator.pop(context)
                        : Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                role: widget.role,
                                name: name,
                              ),
                            ),
                            (route) => false);
                  },
                ),

                // Verifikasi Mobile
                ['koordes', 'koortps', 'relawan'].contains(widget.role)
                    ? CustomMenuDrawer(
                        urlIcon: 'assets/ic_mobile.png',
                        title: 'Verifikasi Mobile',
                        onPressed: () {
                          Navigator.pop(context);
                          if (widget.pageActive != 'mobile' ||
                              widget.pageActive == 'validmobile') {
                            if (widget.pageActive != 'home' ||
                                widget.pageActive == 'validmobile') {
                              Navigator.pop(context);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifikasiMobilePage(
                                  role: widget.role,
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : Container(),

                // Verifikasi APK
                ['koordes', 'koortps', 'relawan'].contains(widget.role)
                    ? CustomMenuDrawer(
                        urlIcon: 'assets/ic_apk.png',
                        title: 'Verifikasi APK',
                        onPressed: () {
                          Navigator.pop(context);
                          if (widget.pageActive != 'apk' ||
                              widget.pageActive == 'validapk') {
                            if (widget.pageActive != 'home' ||
                                widget.pageActive == 'validapk') {
                              Navigator.pop(context);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifikasiApkPage(
                                  role: widget.role,
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : Container(),

                // Verifikasi Kampanye
                ['koordes', 'koortps', 'relawan'].contains(widget.role)
                    ? CustomMenuDrawer(
                        urlIcon: 'assets/ic_kampanye.png',
                        title: 'Verifikasi Kampanye',
                        onPressed: () {
                          Navigator.pop(context);
                          if (widget.pageActive != 'kampanye' ||
                              widget.pageActive == 'validkampanye') {
                            if (widget.pageActive != 'home' ||
                                widget.pageActive == 'validkampanye') {
                              Navigator.pop(context);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifikasiApkPage(
                                  role: widget.role,
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : Container(),

                CustomMenuDrawer(
                  urlIcon: 'assets/ic_quick.png',
                  title: 'Quick Count',
                  onPressed: () {
                    Navigator.pop(context);
                    if (widget.pageActive != 'quick') {
                      if (widget.pageActive != 'home') {
                        Navigator.pop(context);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuickCountPage(
                            role: widget.role,
                          ),
                        ),
                      );
                    }
                  },
                ),
                // CustomMenuDrawer(
                //   urlIcon: 'assets/ic_real.png',
                //   title: 'Real Count',
                //   onPressed: () {
                //     Navigator.pop(context);
                //     if (widget.pageActive != 'real') {
                //       if (widget.pageActive != 'home') {
                //         Navigator.pop(context);
                //       }
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => QuickCountPage(
                //             role: widget.role,
                //           ),
                //         ),
                //       );
                //     }
                //   },
                // ),
                CustomMenuDrawer(
                  urlIcon: 'assets/ic_logout.png',
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
            padding: const EdgeInsets.only(left: 50),
            child: Container(
              height: 1,
              width: double.infinity,
              color: const Color(0xFFEDEDED),
            ),
          ),
        ],
      ),
    );
  }
}
