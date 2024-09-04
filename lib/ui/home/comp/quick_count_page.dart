import 'dart:io';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pica/components/buttons.dart';
import 'package:pica/components/dialog.dart';
import 'package:pica/components/drawer.dart';
import 'package:pica/components/flushbar.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/models/kelurahan_model.dart';
import 'package:pica/models/paslon_model.dart';
import 'package:pica/services/auth_service.dart';
import 'package:pica/services/kelurahan_service.dart';
import 'package:pica/services/paslon_service.dart';
import 'package:pica/services/quickcount_service.dart';
import 'package:pica/shared/methods.dart';
import 'package:trust_location/trust_location.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../shared/theme.dart';
import '../../../components/forms.dart';
import 'package:gps_connectivity/gps_connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class QuickCountPage extends StatefulWidget {
  final String role;
  final String colorHex;
  const QuickCountPage({super.key, required this.role, required this.colorHex});

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
    } catch (e) {
      // ignore: avoid_print
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
    if (mounted) {
      setState(() {});
    }
  }

  KelurahanModel? kelurahan;
  void _getKelurahan() async {
    ApiResponse response = await getKelurahan();
    if (response.error == null) {
      kelurahan = response.data as KelurahanModel;
      kelController.text = kelurahan!.name;
      if (mounted) {
        setState(() {});
      }
    }
  }

  List<dynamic> paslonList = [];
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _idControllers = [];
  final List<TextEditingController> _suaraControllers = [];
  void _getPaslon() async {
    ApiResponse response = await getPaslon();
    if (response.error == null) {
      paslonList = response.data as List<dynamic>;
      for (int i = 0; i < paslonList.length; i++) {
        PaslonModel paslon = paslonList[i];

        _nameControllers.add(TextEditingController(text: paslon.namaCalon));
        _idControllers.add(TextEditingController(text: paslon.id.toString()));
        _suaraControllers.add(TextEditingController());
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  bool areAllFieldsFilled() {
    for (var controller in _suaraControllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    requestPermission();
    _getKelurahan();
    _getPaslon();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    TrustLocation.stop();
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _idControllers) {
      controller.dispose();
    }
    for (var controller in _suaraControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<String> imagePaths = [];
  bool loadingGeotag = false;
  saveUint8ListAsPng(WidgetsToImageController controller, String fotoKe) async {
    File? file;
    final bytes = await controller.capture();
    if (mounted) {
      setState(() {
        this.bytes = bytes;
      });
    }

    Uint8List newBytes = await compressUintList(bytes!);
    String fileName = DateTime.now()
        .toString()
        .replaceAll(RegExp(r'[-:\s]'), '')
        .replaceAll('.', '');
    img.Image image = img.decodeImage(newBytes)!;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String filePath = '$appDocPath/$fileName.png';
    file = File(filePath);
    await file.writeAsBytes(img.encodePng(image));
    int index = int.parse(fotoKe) - 1;
    // print('Ukuran' + File(file.path).lengthSync().toString());
    if (index < imagePaths.length) {
      imagePaths[index] = file.path;
    } else {
      imagePaths.add(file.path);
    }
    loadingGeotag = false;
    if (mounted) {
      setState(() {});
    }
    // upload();
  }

  upload() async {
    ApiResponse response;
    response = await postQuickCount(
      rtrw: rtRwController.text,
      tps: tpsController.text,
      paslonId: _idControllers.map((controller) => controller.text).toList(),
      paslonSuara:
          _suaraControllers.map((controller) => controller.text).toList(),
      fotos: imagePaths,
    );
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

  _selectImage({required String fotoKe}) async {
    if (!loadingGeotag) {
      loadingGeotag = true;
      final image = await selectImageCamera();

      if (image != null) {
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
        if (mounted) {
          setState(() {
            if (fotoKe == '1') {
              selectedImage1 = image;
            } else if (fotoKe == '2') {
              selectedImage2 = image;
            } else if (fotoKe == '3') {
              selectedImage3 = image;
            } else if (fotoKe == '4') {
              selectedImage4 = image;
            } else {
              selectedImage5 = image;
            }
          });
        }

        await Future.delayed(const Duration(milliseconds: 2000));
        if (mounted) {
          if (fotoKe == '1') {
            saveUint8ListAsPng(controller1, fotoKe);
          } else if (fotoKe == '2') {
            saveUint8ListAsPng(controller2, fotoKe);
          } else if (fotoKe == '3') {
            saveUint8ListAsPng(controller3, fotoKe);
          } else if (fotoKe == '4') {
            saveUint8ListAsPng(controller4, fotoKe);
          } else {
            saveUint8ListAsPng(controller5, fotoKe);
          }
        }
      }
    } else {
      loadingGeotag = false;
      MyFlushbar.showFlushbar(context, "Tunggu Sebentar");
    }
  }

  Future<bool> _checkInternetGps() async {
    bool isGpsEnabled = await (GpsConnectivity().checkGpsConnectivity());
    bool isInternetEnabled = await InternetConnectionChecker().hasConnection;
    if (!isGpsEnabled && !isInternetEnabled) {
      // ignore: use_build_context_synchronously
      MyFlushbar.showFlushbar(context, "Aktifkan Koneksi Internet dan GPS");
      return false;
    } else if (isGpsEnabled && !isInternetEnabled) {
      // ignore: use_build_context_synchronously
      MyFlushbar.showFlushbar(context, "Aktifkan Koneksi Internet");
      return false;
    } else if (!isGpsEnabled && isInternetEnabled) {
      // ignore: use_build_context_synchronously
      MyFlushbar.showFlushbar(context, "Aktifkan Koneksi GPS");
      return false;
    }
    return true;
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
        backgroundColor: hexToColor(widget.colorHex),
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
                    readOnly: true,
                    controller: kelController,
                    colorHex: widget.colorHex,
                  ),
                  OutlineFormField(
                    title: 'TPS',
                    placeholderText: 'TPS',
                    controller: tpsController,
                    colorHex: widget.colorHex,
                  ),
                  OutlineFormField(
                    title: 'RT/RW',
                    placeholderText: 'RT/RW',
                    controller: rtRwController,
                    colorHex: widget.colorHex,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 20),
                      child: CustomElevatedButton(
                          title: 'Lanjut',
                          colorHex: widget.colorHex,
                          onPressed: () async {
                            if (kelController.text.trim().isNotEmpty &&
                                tpsController.text.trim().isNotEmpty &&
                                rtRwController.text.trim().isNotEmpty) {
                              if (FocusScope.of(context).isFirstFocus) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }
                              nextPage();
                            } else {
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
                                          'Harap isi semua kolom!',
                                          style: poppins.copyWith(
                                              fontSize: 12,
                                              fontWeight: medium,
                                              color: Colors.white),
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
                      _idControllers.length,
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
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Paslon ${index + 1}',
                              style: poppins.copyWith(
                                  fontWeight: semiBold,
                                  color: hexToColor(widget.colorHex)),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              height: 38,
                              child: TextFormField(
                                readOnly: true,
                                controller: _nameControllers[index],
                                style: poppins.copyWith(
                                    fontSize: 12,
                                    color: const Color(0xFF232323)),
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              height: 38,
                              child: TextFormField(
                                controller: _suaraControllers[index],
                                keyboardType: TextInputType.number,
                                style: poppins.copyWith(
                                    fontSize: 12,
                                    color: const Color(0xFF232323)),
                                decoration: InputDecoration(
                                  hintText:
                                      'Masukkan suara paslon ${index + 1}',
                                  hintStyle:
                                      poppins.copyWith(color: neutral200),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                      colorHex: widget.colorHex,
                      onPressed: () async {
                        if (areAllFieldsFilled()) {
                          if (FocusScope.of(context).isFirstFocus) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                          nextPage();
                        } else {
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
                                      'Harap isi semua kolom!',
                                      style: poppins.copyWith(
                                          fontSize: 12,
                                          fontWeight: medium,
                                          color: Colors.white),
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
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Step 3
            ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload C-Hasil',
                            style: poppins.copyWith(
                                fontWeight: semiBold,
                                color: hexToColor(widget.colorHex)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '*Maksimal 5 foto',
                            style: poppins.copyWith(
                                fontSize: 12, color: const Color(0xFF808080)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: selectedImage1 != null
                          ? MediaQuery.of(context).size.width * (3.4 / 3)
                          : 73,
                      child: ListView(
                        // reverse: true,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        scrollDirection: Axis.horizontal,
                        children: [
                          if (selectedImage5 == null)
                            Column(
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      bool isAvailable =
                                          await _checkInternetGps();
                                      if (isAvailable) {
                                        _selectImage(
                                            fotoKe: selectedImage1 == null
                                                ? '1'
                                                : selectedImage2 == null
                                                    ? '2'
                                                    : selectedImage3 == null
                                                        ? '3'
                                                        : selectedImage4 == null
                                                            ? '4'
                                                            : '5');
                                      }
                                    },
                                    child: selectedImage1 != null ||
                                            selectedImage2 != null ||
                                            selectedImage3 != null ||
                                            selectedImage4 != null ||
                                            selectedImage5 != null
                                        ? SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (3.4 / 3),
                                            width: 80,
                                            child: Center(
                                              child: Container(
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      color: loadingGeotag
                                                          ? neutral200
                                                          : hexToColor(
                                                              widget.colorHex),
                                                      shape: BoxShape.circle,
                                                      border: loadingGeotag
                                                          ? Border.all(
                                                              color: const Color(
                                                                  0xFF808080),
                                                            )
                                                          : null),
                                                  child: Icon(
                                                    Icons.add_photo_alternate,
                                                    color: loadingGeotag
                                                        ? const Color(
                                                            0xFF808080)
                                                        : white,
                                                  )),
                                            ),
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                48,
                                            height: 73,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF808080),
                                                )),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                      color: const Color(
                                                          0xFFB1B1B1)),
                                                )
                                              ],
                                            ),
                                          )),
                              ],
                            ),
                          if (selectedImage5 != null)
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 20,
                                  left: selectedImage5 != null ? 0 : 20),
                              child: GestureDetector(
                                onTap: () async {
                                  bool isAvailable = await _checkInternetGps();
                                  if (isAvailable) {
                                    _selectImage(fotoKe: '5');
                                  }
                                },
                                child: Stack(
                                  children: [
                                    WidgetsToImage(
                                      controller: controller5,
                                      child: cardWidget(
                                          file: selectedImage5!, name: name!),
                                    ),
                                    if (imagePaths.length > 4)
                                      Image.file(
                                        File(imagePaths[4]),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                48,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                (3.4 / 3),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          if (selectedImage4 != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, left: 20),
                              child: GestureDetector(
                                onTap: () async {
                                  bool isAvailable = await _checkInternetGps();
                                  if (isAvailable) {
                                    _selectImage(fotoKe: '4');
                                  }
                                },
                                child: Stack(
                                  children: [
                                    WidgetsToImage(
                                      controller: controller4,
                                      child: cardWidget(
                                          file: selectedImage4!, name: name!),
                                    ),
                                    if (imagePaths.length > 3)
                                      Image.file(
                                        File(imagePaths[3]),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                48,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                (3.4 / 3),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          if (selectedImage3 != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, left: 20),
                              child: GestureDetector(
                                onTap: () async {
                                  bool isAvailable = await _checkInternetGps();
                                  if (isAvailable) {
                                    _selectImage(fotoKe: '3');
                                  }
                                },
                                child: Stack(
                                  children: [
                                    WidgetsToImage(
                                      controller: controller3,
                                      child: cardWidget(
                                          file: selectedImage3!, name: name!),
                                    ),
                                    if (imagePaths.length > 2)
                                      Image.file(
                                        File(imagePaths[2]),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                48,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                (3.4 / 3),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          if (selectedImage2 != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, left: 20),
                              child: GestureDetector(
                                onTap: () async {
                                  bool isAvailable = await _checkInternetGps();
                                  if (isAvailable) {
                                    _selectImage(fotoKe: '2');
                                  }
                                },
                                child: Stack(
                                  children: [
                                    WidgetsToImage(
                                      controller: controller2,
                                      child: cardWidget(
                                          file: selectedImage2!, name: name!),
                                    ),
                                    if (imagePaths.length > 1)
                                      Image.file(
                                        File(imagePaths[1]),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                48,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                (3.4 / 3),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          if (selectedImage1 != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, left: 20),
                              child: GestureDetector(
                                onTap: () async {
                                  bool isAvailable = await _checkInternetGps();
                                  if (isAvailable) {
                                    _selectImage(fotoKe: '1');
                                  }
                                },
                                child: Stack(
                                  children: [
                                    WidgetsToImage(
                                      controller: controller1,
                                      child: cardWidget(
                                          file: selectedImage1!, name: name!),
                                    ),
                                    if (imagePaths.isNotEmpty)
                                      Image.file(
                                        File(imagePaths[0]),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                48,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                (3.4 / 3),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // FloatingActionButton(
                    //     onPressed: () async {
                    //       final bytes = await controller1.capture();
                    //       await saveImage(bytes!);
                    //       // ignore: use_build_context_synchronously
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(
                    //               content: Text('Berhasil Mengunduh')));
                    //       setState(() {
                    //         isLoading = false;
                    //       });
                    //     },
                    //     child: const Icon(Icons.download)),

                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            24, selectedImage1 != null ? 20 : 50, 24, 20),
                        child: CustomElevatedButton(
                            title: 'Kirim',
                            colorHex: widget.colorHex,
                            onPressed: () async {
                              if (!loadingGeotag && !isLoading) {
                                if (selectedImage1 != null) {
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
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Center(
                                                      child: SizedBox(
                                                          width: 60,
                                                          height: 60,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: hexToColor(
                                                                widget
                                                                    .colorHex),
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
                                  isLoading = true;
                                  upload();
                                } else {
                                  MyFlushbar.showFlushbar(
                                      context, "Lengkapi semua formulir");
                                }
                              }
                            })),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cardWidget({required File file, required String name}) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * (3.4 / 3),
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

  // Widget buildImage(Uint8List bytes) => Image.memory(bytes);
  Uint8List? imageBytes2;
  Future<void> saveImage(Uint8List imageBytes) async {
    setState(() {
      imageBytes2 = imageBytes;
      print(imageBytes2);
    });
    final result = await ImageGallerySaver.saveImage(imageBytes);
    print('Image saved: $result');
  }
}
