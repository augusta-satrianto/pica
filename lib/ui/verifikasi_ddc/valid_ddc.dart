import 'package:flutter/material.dart';
import 'package:pica/components/drawer.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/models/valid_invalid_model.dart';
import 'package:pica/services/valid_invalid_service.dart';
import 'package:pica/shared/methods.dart';
import 'package:pica/shared/theme.dart';

class ValidDdcPage extends StatefulWidget {
  final String role;
  final String jenis;
  final String title;
  final String drawer;
  final String colorHex;
  const ValidDdcPage(
      {super.key,
      required this.role,
      required this.jenis,
      required this.title,
      required this.drawer,
      required this.colorHex});

  @override
  State<ValidDdcPage> createState() => _ValidDdcPageState();
}

class _ValidDdcPageState extends State<ValidDdcPage> {
  List<dynamic> verifikasiList = [];
  void _getVerifikasi() async {
    ApiResponse response =
        await getVerifikasi(jenis: widget.jenis, status: 'Valid');
    if (response.error == null) {
      verifikasiList = response.data as List<dynamic>;
      if (mounted) {
        setState(() {});
      }
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
                      Text(
                        'NKK',
                        style: poppins.copyWith(
                            fontWeight: semiBold,
                            color: hexToColor(widget.colorHex)),
                      )
                    ],
                  ),
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xFFD6D6D6),
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  Column(
                      children: List.generate(verifikasiList.length, (index) {
                    VerifikasiModel verifikasi = verifikasiList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
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
                          // Expanded(
                          //   child: Text(
                          //     verifikasi.nkk,
                          //     style: poppins.copyWith(
                          //         color: const Color(0xFF232323)),
                          //   ),
                          // )
                        ],
                      ),
                    );
                  })),
                ],
              )),
        ],
      ),
    );
  }
}
