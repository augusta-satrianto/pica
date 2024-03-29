import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pica/components/buttons.dart';
import 'package:pica/components/dialog.dart';
import 'package:pica/components/forms.dart';
import 'package:pica/components/drawer.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/services/dashboard_service.dart';
import 'package:pica/shared/methods.dart';
import 'package:pica/shared/theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class VerifikasiMobilePage extends StatefulWidget {
  const VerifikasiMobilePage({super.key});

  @override
  State<VerifikasiMobilePage> createState() => _VerifikasiMobilePageState();
}

class _VerifikasiMobilePageState extends State<VerifikasiMobilePage> {
  final nikController = TextEditingController(text: '');
  final phoneController = TextEditingController(text: '');
  final ketController = TextEditingController(text: '');

  File? selectedImage;

  // WidgetsToImageController to access widget
  WidgetsToImageController controller = WidgetsToImageController();
  // to save image bytes of widget
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
          // Periksa apakah widget masih terpasang
          latitude = result.latitude;
          longitude = result.longitude;
          // kabupaten = result.;
          isMock = result.isMockLocation;
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

  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    print(place.street); // Output nama jalan atau alamat
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
    ApiResponse response;
    String foto = file!.path;

    response = await verifikasiMobile(
        nik: nikController.text,
        noTelp: phoneController.text,
        keterangan: ketController.text,
        latitude: latitude!,
        longitude: longitude!,
        foto: foto);

    if (response.error == null) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      customDialog('Berhasil', 'Survey Berhasil Terkirim', 'Success', () {
        Navigator.pop(context);
        Navigator.pop(context);
      }, context);
    } else {
      // ignore: use_build_context_synchronously
      customDialog('Gagal', 'Coba kirim kembali', 'Failed', () {
        Navigator.pop(context);
      }, context);
      setState(() {
        isLoading = false;
      });
    }
  }

  _selectImage() async {
    final image = await selectImageCamera();

    setState(() {
      selectedImage = image;
    });
    final bytes = await controller.capture();
    await saveImage(bytes!);
    setState(() {
      this.bytes = bytes;
    });
    // saveUint8ListAsPng(bytes, 'nama');
    // setState(() {});
  }

  Future<void> saveImage(Uint8List imageBytes) async {
    final result = await ImageGallerySaver.saveImage(imageBytes);
    print('Image saved: $result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verifikasi Mobile',
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
        pageActive: 'mobile',
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
            title: 'No. Telp',
            placeholderText: 'No. Telp',
            controller: phoneController,
            numberOnly: true,
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
              selectedImage == null
                  ? GestureDetector(
                      onTap: () async {
                        if (isMock != null) {
                          if (isMock == false) {
                            TrustLocation.stop();
                            _selectImage();
                          } else {
                            if (latitude == null) {
                              customDialog(
                                  'Aktifkan GPS',
                                  'Silahkan aktifkan GPS terlebih dahulu',
                                  'Failed', () {
                                Navigator.pop(context);
                              }, context);
                            } else {
                              customDialog(
                                  'Lokasi Tiruan Terdeteksi',
                                  'Silahkan matikan terlebih dahulu dan coba kembali 3 menit lagi',
                                  'Failed', () {
                                Navigator.pop(context);
                              }, context);
                            }
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
                                  fontSize: 12, color: const Color(0xFFB1B1B1)),
                            )
                          ],
                        ),
                      ))
                  : GestureDetector(
                      onTap: () async {
                        if (isMock != null) {
                          if (isMock == false) {
                            TrustLocation.stop();
                            _selectImage();
                          } else {
                            if (latitude == null) {
                              customDialog(
                                  'Aktifkan GPS',
                                  'Silahkan aktifkan GPS terlebih dahulu',
                                  'Failed', () {
                                Navigator.pop(context);
                              }, context);
                            } else {
                              customDialog(
                                  'Lokasi Tiruan Terdeteksi',
                                  'Silahkan matikan terlebih dahulu dan coba kembali 3 menit lagi',
                                  'Failed', () {
                                Navigator.pop(context);
                              }, context);
                            }
                          }
                        }
                      },
                      child: WidgetsToImage(
                        controller: controller,
                        child: cardWidget(),
                      ),
                    ),
              Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  child: CustomElevatedButton(
                      title: isLoading ? 'Proses' : 'Kirim',
                      onPressed: () async {
                        if (isLoading == false) {
                          setState(() {
                            isLoading = true;
                          });

                          final bytes = await controller.capture();
                          print('1. Capture');
                          setState(() {
                            this.bytes = bytes;
                          });
                          String a = DateTime.now()
                              .toString()
                              .replaceAll(RegExp(r'[-:\s]'), '')
                              .replaceAll('.', '');
                          print('2. In SAve Uint');
                          saveUint8ListAsPng(bytes!, a);
                        }
                      })),
            ],
          ),
        ],
      ),
    );
  }

  Widget cardWidget() {
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
    String formattedTime = DateFormat('HH:mm:ss', 'id_ID').format(now);
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.width * (4 / 3),
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
                    formattedDate,
                    style: poppins.copyWith(
                        fontWeight: medium, fontSize: 10, color: Colors.white),
                  ),
                  Text(
                    '$formattedTime WIB',
                    style: poppins.copyWith(
                        fontWeight: medium, fontSize: 10, color: Colors.white),
                  ),
                  Text(
                    '$desa, $kecamatan,',
                    style: poppins.copyWith(
                        fontWeight: medium, fontSize: 10, color: Colors.white),
                  ),
                  Text(
                    '$kabupaten, $provinsi, $kodepos',
                    style: poppins.copyWith(
                        fontWeight: medium, fontSize: 10, color: Colors.white),
                  ),
                  Text(
                    '$latitude, $longitude',
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
