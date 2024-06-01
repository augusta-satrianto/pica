import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pica/components/buttons.dart';
import 'package:pica/components/dialog.dart';
import 'package:pica/components/flushbar.dart';
import 'package:pica/components/forms.dart';
import 'package:pica/components/drawer.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/services/auth_service.dart';
import 'package:pica/services/kampanye_service.dart';
import 'package:pica/shared/methods.dart';
import 'package:pica/shared/theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:gps_connectivity/gps_connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class VerifikasiKampanyePage extends StatefulWidget {
  final String role;

  const VerifikasiKampanyePage({super.key, required this.role});

  @override
  State<VerifikasiKampanyePage> createState() => _VerifikasiKampanyePageState();
}

class _VerifikasiKampanyePageState extends State<VerifikasiKampanyePage> {
  final nikController = TextEditingController(text: '');
  final barangController = TextEditingController(text: '');
  final ketController = TextEditingController(text: '');

  File? selectedImage;
  WidgetsToImageController controller = WidgetsToImageController();

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
  String? name;

  void requestPermission() async {
    name = await getName();
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
          geoCode();
        }
      });
      // ignore: empty_catches
    } catch (e) {}
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
    TrustLocation.stop();
    super.dispose();
  }

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  File? file;
  saveUint8ListAsPng(Uint8List uint8List, String fileName) async {
    img.Image image = img.decodeImage(uint8List)!;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String filePath = '$appDocPath/$fileName.png';
    file = File(filePath);
    await file!.writeAsBytes(img.encodePng(image));
    upload();
  }

  upload() async {
    ApiResponse response;
    String foto = file!.path;

    response = await verifikasiKampanye(
        nik: nikController.text,
        barang: barangController.text,
        keterangan: ketController.text,
        latitude: latitude!,
        longitude: longitude!,
        foto: foto);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    if (response.error == null) {
      // ignore: use_build_context_synchronously
      customDialog('Berhasil', 'Verifikasi Berhasil Terkirim', 'Success', () {
        Navigator.pop(context);
        Navigator.pop(context);
      }, context);
    } else {
      // ignore: use_build_context_synchronously
      customDialog('Gagal', 'Coba kirim kembali', 'Failed', () {
        Navigator.pop(context);
      }, context);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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

  _selectImage() async {
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
      selectedImage = image;
    });
  }

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
      drawer: DrawerView(
        pageActive: 'kampanye',
        role: widget.role,
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
              bool isGpsEnabled =
                  await (GpsConnectivity().checkGpsConnectivity());
              bool isInternetEnabled =
                  await InternetConnectionChecker().hasConnection;
              if (!isGpsEnabled && !isInternetEnabled) {
                // ignore: use_build_context_synchronously
                MyFlushbar.showFlushbar(
                    context, "Aktifkan Koneksi Internet dan GPS");
              } else if (isGpsEnabled && !isInternetEnabled) {
                // ignore: use_build_context_synchronously
                MyFlushbar.showFlushbar(context, "Aktifkan Koneksi Internet");
              } else if (!isGpsEnabled && isInternetEnabled) {
                // ignore: use_build_context_synchronously
                MyFlushbar.showFlushbar(context, "Aktifkan Koneksi GPS");
              } else {
                if (isMock != null &&
                    isMock == false &&
                    latitude != null &&
                    longitude != null) {
                  _selectImage();
                }
              }
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
                              fontSize: 12, color: const Color(0xFFB1B1B1)),
                        )
                      ],
                    ),
                  )
                : WidgetsToImage(
                    controller: controller,
                    child: cardWidget(name!),
                  ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              child: CustomElevatedButton(
                  title: 'Kirim',
                  onPressed: () async {
                    if (nikController.text.trim().isNotEmpty &&
                        barangController.text.trim().isNotEmpty &&
                        ketController.text.trim().isNotEmpty &&
                        selectedImage != null) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return WillPopScope(
                            onWillPop: () async => true,
                            child: Center(
                              child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                          child: SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: CircularProgressIndicator(
                                                color: primaryMain,
                                                strokeWidth: 6,
                                              ))),
                                      Center(
                                        child: Image.asset(
                                          'assets/img_logo2.png',
                                          width: 40,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          );
                        },
                      );
                      final bytes = await controller.capture();
                      setState(() {
                        this.bytes = bytes;
                      });
                      String a = DateTime.now()
                          .toString()
                          .replaceAll(RegExp(r'[-:\s]'), '')
                          .replaceAll('.', '');
                      saveUint8ListAsPng(bytes!, a);
                    } else {
                      MyFlushbar.showFlushbar(
                          context, "Lengkapi semua formulir");
                    }
                  })),
        ],
      ),
    );
  }

  Widget cardWidget(String name) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.width * (3.4 / 3),
          ),
          child: Image.file(
            File(selectedImage!.path),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width - 48,
          ),
        ),
        if (latitude != null && selectedImage != null)
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              width: MediaQuery.of(context).size.width - 48,
              decoration: BoxDecoration(
                  color: const Color(0xFF909090).withOpacity(0.75)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
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
        Positioned(
          bottom: 0,
          left: 0,
          child: Image.asset(
            'assets/img_logo2.png',
            width: 30,
          ),
        ),
      ],
    );
  }
}
