import 'package:flutter/material.dart';
import 'package:pica/components/drawer.dart';
import 'package:pica/shared/theme.dart';
import 'package:pica/ui/home/comp/verifikasi_logistik_upload_page.dart';
import 'package:pica/ui/home/home_page.dart';

class VerifikasiLogistikPage extends StatelessWidget {
  const VerifikasiLogistikPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verifikasi Logistik',
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Builder(builder: (context) {
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
          ),
        ],
        leadingWidth: 80,
        leading: IconButton(
          icon: Image.asset(
            'assets/ic_arrow_back.png',
            width: 10,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: const DrawerView(
        pageActive: 'logistik',
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          CustomLogistik(
              title: 'Banner 1',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerifikasiLogistikUploadPage(
                      title: 'Banner 1',
                    ),
                  ),
                );
              }),
          CustomLogistik(
              title: 'Banner 2',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerifikasiLogistikUploadPage(
                      title: 'Banner 2',
                    ),
                  ),
                );
              }),
          CustomLogistik(
              title: 'Poster 1',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerifikasiLogistikUploadPage(
                      title: 'Poster 1',
                    ),
                  ),
                );
              }),
          CustomLogistik(
              title: 'Poster 2',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerifikasiLogistikUploadPage(
                      title: 'Poster 2',
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class CustomLogistik extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const CustomLogistik(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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
            height: 23,
          ),
          Text(
            title,
            style: poppins.copyWith(
                fontWeight: semiBold,
                fontSize: 16,
                color: const Color(0xFF186968)),
          ),
          const Spacer(),
          CustomButtonAdd(
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
