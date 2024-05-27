import 'package:flutter/material.dart';
import 'package:pica/components/drawer.dart';
import 'package:pica/shared/theme.dart';

class InvalidKampanyePage extends StatefulWidget {
  final String role;
  const InvalidKampanyePage({super.key, required this.role});

  @override
  State<InvalidKampanyePage> createState() => _InvalidKampanyePageState();
}

class _InvalidKampanyePageState extends State<InvalidKampanyePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invalid\nVerifikasi Kampanye',
          textAlign: TextAlign.center,
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
      drawer: DrawerView(
        pageActive: 'validkampanye',
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
                                color: const Color(0xFF186968)),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          'Nama',
                          style: poppins.copyWith(
                              fontWeight: semiBold,
                              color: const Color(0xFF186968)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Admin',
                        style: poppins.copyWith(
                            fontWeight: semiBold,
                            color: const Color(0xFF186968)),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
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
                      children: List.generate(10, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
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
                              'Lorem Ipsum',
                              style: poppins.copyWith(
                                  color: const Color(0xFF232323)),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              width: 47.5,
                              child: Image.asset(
                                'assets/ic_wa.png',
                                height: 18,
                              )),
                          const SizedBox(
                            width: 15,
                          ),
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
