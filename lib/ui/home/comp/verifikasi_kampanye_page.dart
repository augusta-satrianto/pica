import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pica/components/buttons.dart';
import 'package:pica/components/forms.dart';
import 'package:pica/components/drawer.dart';
import 'package:pica/shared/methods.dart';
import 'package:pica/shared/theme.dart';

class VerifikasiKampanyePage extends StatefulWidget {
  const VerifikasiKampanyePage({super.key});

  @override
  State<VerifikasiKampanyePage> createState() => _VerifikasiKampanyePageState();
}

class _VerifikasiKampanyePageState extends State<VerifikasiKampanyePage> {
  final nikController = TextEditingController(text: '');
  final barangController = TextEditingController(text: '');
  final ketController = TextEditingController(text: '');

  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verifikasi Kampanye',
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
        pageActive: 'kampanye',
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        children: [
          const SizedBox(
            height: 20,
          ),
          OutlineFormField(
            title: 'NIK',
            placeholderText: 'NIK',
            controller: nikController,
            numberOnly: true,
          ),
          OutlineFormField(
            title: 'Barang yang Diberi',
            placeholderText: 'Barang yang Diberi',
            controller: barangController,
          ),
          OutlineFormField(
            title: 'Keterangan',
            placeholderText: 'Keterangan',
            controller: ketController,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              Text(
                'Upload Foto',
                style: poppins.copyWith(
                    fontWeight: semiBold, color: const Color(0xFF186968)),
              ),
              const SizedBox(
                height: 4,
              ),
              GestureDetector(
                  onTap: () async {
                    final image = await selectImageGalery();
                    setState(() {
                      selectedImage = image;
                    });
                    // String a = selectedImage!.path;

                    // String? image2 = getStringImage(selectedImage);
                    // await updateSettings(avatar: a);
                    // print('Berhasil');
                  },
                  child: selectedImage == null
                      ? Container(
                          width: double.infinity,
                          height: 73,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color(0xFF808080),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/ic_image.png',
                                width: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Upload Foto',
                                style: poppins.copyWith(
                                    fontSize: 12,
                                    color: const Color(0xFFB1B1B1)),
                              )
                            ],
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 200,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 6),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(
                                  File(selectedImage!.path),
                                ),
                                fit: BoxFit.fitHeight),
                          ))),
              Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  child:
                      CustomElevatedButton(title: 'Kirim', onPressed: () {})),
            ],
          ),
        ],
      ),
    );
  }
}
