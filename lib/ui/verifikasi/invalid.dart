import 'package:flutter/material.dart';
import 'package:pica/components/drawer.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/models/valid_invalid_model.dart';
import 'package:pica/services/valid_invalid_service.dart';
import 'package:pica/shared/methods.dart';
import 'package:pica/shared/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class InvalidPage extends StatefulWidget {
  final String role;
  final String jenis;
  final String title;
  final String drawer;
  final String colorHex;
  const InvalidPage(
      {super.key,
      required this.role,
      required this.jenis,
      required this.title,
      required this.drawer,
      required this.colorHex});

  @override
  State<InvalidPage> createState() => _InvalidPageState();
}

class _InvalidPageState extends State<InvalidPage> {
  List<dynamic> verifikasiList = [];
  void _getVerifikasi() async {
    ApiResponse response =
        await getVerifikasi(jenis: widget.jenis, status: 'Invalid');
    if (response.error == null) {
      verifikasiList = response.data as List<dynamic>;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _launchWhatsApp({required String telepon}) async {
    if (telepon.startsWith("0")) {
      telepon = "62${telepon.substring(1)}";
    }
    String phoneNumber = '+$telepon';
    String message = 'Halo Admin, ... ';
    String uri =
        'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeFull(message)}';

    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      print('Could not launch $uri');
    }
  }

  @override
  void initState() {
    _getVerifikasi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: hexToColor(widget.colorHex),
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
      drawer: DrawerView(
        pageActive: widget.drawer,
        role: widget.role,
      ),
      body: ListView(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 30,
                          child: Text(
                            'No.',
                            style: poppins.copyWith(
                                fontWeight: semiBold,
                                color: hexToColor(widget.colorHex)),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          'Nama',
                          style: poppins.copyWith(
                              fontWeight: semiBold,
                              color: hexToColor(widget.colorHex)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Admin',
                        style: poppins.copyWith(
                            fontWeight: semiBold,
                            color: hexToColor(widget.colorHex)),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xFFD6D6D6),
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  Column(
                      children: List.generate(verifikasiList.length, (index) {
                    VerifikasiModel verifikasi = verifikasiList[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 30,
                            child: Text(
                              '${index + 1}.',
                              style: poppins.copyWith(
                                  color: const Color(0xFF232323)),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            verifikasi.name,
                            style: poppins.copyWith(
                                color: const Color(0xFF232323)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () =>
                              _launchWhatsApp(telepon: verifikasi.telepon),
                          child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              width: 47.5,
                              child: Image.asset(
                                'assets/ic_wa.png',
                                height: 18,
                              )),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    );
                  })),
                ],
              )),
        ],
      ),
    );
  }
}
