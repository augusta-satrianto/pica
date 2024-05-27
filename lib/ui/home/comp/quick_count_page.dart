import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pica/components/buttons.dart';
import 'package:pica/components/drawer.dart';
import 'package:pica/components/flushbar.dart';
import 'package:pica/shared/methods.dart';
import 'package:trust_location/trust_location.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../shared/theme.dart';
import '../../../components/forms.dart';

class QuickCountPage extends StatefulWidget {
  final String role;
  const QuickCountPage({super.key, required this.role});

  @override
  State<QuickCountPage> createState() => _QuickCountPageState();
}

class _QuickCountPageState extends State<QuickCountPage> {
  final kelController = TextEditingController();
  final tpsController = TextEditingController();
  final rtRwController = TextEditingController();

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void nextPage() {
    if (_currentPage < 2) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void prevPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  File? selectedImage1;
  File? selectedImage2;
  File? selectedImage3;
  File? selectedImage4;
  File? selectedImage5;
  final controller1 = WidgetsToImageController();
  final controller2 = WidgetsToImageController();
  final controller3 = WidgetsToImageController();
  final controller4 = WidgetsToImageController();
  final controller5 = WidgetsToImageController();

  Uint8List? bytes;
  String? latitude;
  String? longitude;
  String? negara;
  String? provinsi;
  String? kabupaten;
  String? kecamatan;
  String? desa;
  String? jalan;
  String? kodepos;
  bool? isMock;
  bool isLoading = false;

  void requestPermission() async {
    final permission = await Permission.location.request();

    if (permission == PermissionStatus.granted) {
      TrustLocation.start(1);
      getLocation();
    } else if (permission == PermissionStatus.denied) {
      await Permission.location.request();
    }
  }

  void getLocation() async {
    try {
      TrustLocation.onChange.listen((result) {
        if (mounted) {
          latitude = result.latitude;
          longitude = result.longitude;
          isMock = result.isMockLocation;
          setState(() {});
          geoCode();
        }
      });
    } catch (e) {
      print('Error');
    }
  }

  Placemark? place;
  void geoCode() async {
    List<Placemark> placemark = await placemarkFromCoordinates(
        double.parse(latitude!), double.parse(longitude!));
    negara = placemark[0].country;
    provinsi = placemark[0].administrativeArea;
    kabupaten = placemark[0].subAdministrativeArea;
    kecamatan = placemark[0].locality;
    desa = placemark[0].subLocality;
    jalan = placemark[0].street;
    kodepos = placemark[0].postalCode;
    place = placemark[0];
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    TrustLocation.stop();
    super.dispose();
  }

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  File? fileImageGeo;
  File? file;
  saveUint8ListAsPng(Uint8List uint8List, String fileName) async {
    // Konversi Uint8List ke objek Image
    img.Image image = img.decodeImage(uint8List)!;

    // Dapatkan direktori penyimpanan lokal
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Gabungkan path direktori dengan nama file dan ekstensi PNG
    String filePath = '$appDocPath/$fileName.png';

    // Tulis objek Image ke file PNG
    file = File(filePath);
    await file!.writeAsBytes(img.encodePng(image));

    int fileSize = await file!.length();
    print('Ukuran file: $fileSize bytes');
    print('3. Upload');
    upload();
  }

  upload() async {
    // ApiResponse response;
    // String foto = file!.path;

    // response = await verifikasiKampanye(
    //     nik: nikController.text,
    //     barang: barangController.text,
    //     keterangan: ketController.text,
    //     latitude: latitude!,
    //     longitude: longitude!,
    //     foto: foto);

    // if (response.error == null) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   // ignore: use_build_context_synchronously
    //   customDialog('Berhasil', 'Verifikasi Berhasil Terkirim', 'Success', () {
    //     Navigator.pop(context);
    //     Navigator.pop(context);
    //   }, context);
    // } else {
    //   // ignore: use_build_context_synchronously
    //   customDialog('Gagal', 'Coba kirim kembali', 'Failed', () {
    //     Navigator.pop(context);
    //   }, context);
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }

  String? fixlatitude;
  String? fixlongitude;
  String? fixnegara;
  String? fixprovinsi;
  String? fixkabupaten;
  String? fixkecamatan;
  String? fixdesa;
  String? fixjalan;
  String? fixkodepos;
  String? fixtanggal;
  String? fixjam;

  _selectImage({required String fotoKe}) async {
    final image = await selectImageCamera();
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
    String formattedTime = DateFormat('HH:mm:ss', 'id_ID').format(now);

    fixlatitude = latitude;
    fixlongitude = longitude;
    fixnegara = negara;
    fixprovinsi = provinsi;
    fixkabupaten = kabupaten;
    fixkecamatan = kecamatan;
    fixdesa = desa;
    fixjalan = jalan;
    fixkodepos = kodepos;
    fixtanggal = formattedDate;
    fixjam = formattedTime;

    setState(() {
      if (fotoKe == '1') {
        selectedImage1 = image;
      } else {
        selectedImage2 = image;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    kelController.addListener(() => setState(() {}));
    tpsController.addListener(() => setState(() {}));
    rtRwController.addListener(() => setState(() {}));

    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight - MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah\nQuick Count',
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
            _currentPage == 0 ? Navigator.pop(context) : prevPage();
          },
        ),
      ),
      drawer: DrawerView(
        pageActive: 'mobile',
        role: widget.role,
      ),
      body: SizedBox(
        height: bodyHeight,
        width: double.infinity,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: <Widget>[
            // Step 1
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  OutlineFormField(
                    title: 'Kelurahan',
                    placeholderText: 'Kelurahan',
                    controller: kelController,
                  ),
                  OutlineFormField(
                    title: 'TPS',
                    placeholderText: 'TPS',
                    controller: tpsController,
                  ),
                  OutlineFormField(
                    title: 'RT/RW',
                    placeholderText: 'RT/RW',
                    controller: rtRwController,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 20),
                      child: CustomElevatedButton(
                          title: 'Lanjut',
                          onPressed: () async {
                            if (kelController.text.trim().isNotEmpty &&
                                tpsController.text.trim().isNotEmpty &&
                                rtRwController.text.trim().isNotEmpty) {
                              nextPage();
                            }
                          })),
                ],
              ),
            ),
            // Step 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (int index) => Theme(
                        data: Theme.of(context).copyWith(
                          inputDecorationTheme: InputDecorationTheme(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color(0xFF808080),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color(0xFF808080),
                              ),
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'Paslon ${index + 1}',
                                  style: poppins.copyWith(
                                      fontWeight: semiBold,
                                      color: const Color(0xFF186968)),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 38,
                              child: TextFormField(
                                readOnly: true,
                                initialValue: 'Nama Paslon',
                                style: poppins.copyWith(
                                    fontSize: 12,
                                    color: const Color(0xFF232323)),
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 20),
                      child: CustomElevatedButton(
                          title: 'Lanjut',
                          onPressed: () async {
                            nextPage();
                          })),
                ],
              ),
            ),
            // Page 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Upload C-Hasil',
                        style: poppins.copyWith(
                            fontWeight: semiBold,
                            color: const Color(0xFF186968)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '*Maksimal 5 foto',
                        style: poppins.copyWith(
                            fontSize: 12, color: const Color(0xFF808080)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      selectedImage1 != null
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: GestureDetector(
                                onTap: () async {
                                  if (isMock != null) {
                                    if (isMock == false && latitude != null) {
                                      _selectImage(fotoKe: '1');
                                    } else {
                                      MyFlushbar.showFlushbar(
                                          context, "Aktifkan Internet dan GPS");
                                    }
                                  }
                                },
                                child: WidgetsToImage(
                                  controller: controller1,
                                  child: cardWidget(file: selectedImage1!),
                                ),
                              ),
                            )
                          : Container(),
                      selectedImage2 != null
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: GestureDetector(
                                onTap: () async {
                                  if (isMock != null) {
                                    if (isMock == false && latitude != null) {
                                      _selectImage(fotoKe: '2');
                                    } else {
                                      MyFlushbar.showFlushbar(
                                          context, "Aktifkan Internet dan GPS");
                                    }
                                  }
                                },
                                child: WidgetsToImage(
                                  controller: controller2,
                                  child: cardWidget(file: selectedImage2!),
                                ),
                              ),
                            )
                          : Container(),
                      selectedImage2 == null
                          ? GestureDetector(
                              onTap: () async {
                                if (isMock != null) {
                                  if (isMock == false && latitude != null) {
                                    _selectImage(
                                        fotoKe:
                                            selectedImage1 == null ? '1' : '2');
                                  } else {
                                    MyFlushbar.showFlushbar(
                                        context, "Aktifkan Internet dan GPS");
                                  }
                                }
                              },
                              child: Container(
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
                              ))
                          : Container(),
                      Padding(
                          padding: const EdgeInsets.only(top: 50, bottom: 20),
                          child: CustomElevatedButton(
                              title: isLoading ? 'Proses' : 'Kirim',
                              onPressed: () async {
                                // if (isLoading == false) {
                                //   setState(() {
                                //     isLoading = true;
                                //   });

                                //   final bytes = await controller!.capture();
                                //   setState(() {
                                //     this.bytes = bytes;
                                //   });
                                //   String a = DateTime.now()
                                //       .toString()
                                //       .replaceAll(RegExp(r'[-:\s]'), '')
                                //       .replaceAll('.', '');
                                //   saveUint8ListAsPng(bytes!, a);
                                // }
                              })),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardWidget({required File file}) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.width * (4 / 3),
          ),
          child: Image.file(
            File(file.path),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width - 48,
          ),
        ),
        if (latitude != null)
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: MediaQuery.of(context).size.width - 48,
              decoration: BoxDecoration(
                  color: const Color(0xFF909090).withOpacity(0.83)),
              child: Column(
                children: [
                  Text(
                    'Relawan',
                    style: poppins.copyWith(
                        fontWeight: medium, fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    fixtanggal!,
                    style: poppins.copyWith(
                        fontWeight: medium, fontSize: 10, color: Colors.white),
                  ),
                  Text(
                    '$fixjam WIB',
                    style: poppins.copyWith(
                        fontWeight: medium, fontSize: 10, color: Colors.white),
                  ),
                  Text(
                    '$fixdesa, $fixkecamatan,',
                    style: poppins.copyWith(
                        fontWeight: medium, fontSize: 10, color: Colors.white),
                  ),
                  Text(
                    '$fixkabupaten, $fixprovinsi, $fixkodepos',
                    style: poppins.copyWith(
                        fontWeight: medium, fontSize: 10, color: Colors.white),
                  ),
                  Text(
                    '$fixlatitude, $fixlongitude',
                    style: poppins.copyWith(
                        fontWeight: medium, fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
