// import 'package:edulicense/components/buttons.dart';
// import 'package:edulicense/components/dialog.dart';
// import 'package:edulicense/models/api_response_model.dart';
// import 'package:edulicense/models/auth_model.dart';
// import 'package:edulicense/service/auth_service.dart';
// import 'package:edulicense/ui/auth/login_page.dart';
// import 'package:edulicense/shared/theme.dart';
// import 'package:edulicense/ui/base/base.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final namaController = TextEditingController();
//   final emailController = TextEditingController();
//   final usernameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmController = TextEditingController();
//   bool isLoading = false;
//   bool isObscure = true;
//   bool isObscure2 = true;

//   void _registerUser() async {
//     ApiResponse response = await register(
//         name: namaController.text,
//         email: emailController.text,
//         username: usernameController.text,
//         telepon: phoneController.text,
//         password: passwordController.text,
//         passwordConfirm: confirmController.text);
//     if (response.error == null) {
//       // ignore: use_build_context_synchronously
//       customDialog(
//           'Registrasi Anda Berhasil',
//           'Registrasi anda berhasil dan akan diarahkan ke halaman berikutnya',
//           'Success', () {
//         _loginUser();
//       }, context);
//       isLoading = false;
//     } else {
//       // ignore: use_build_context_synchronously
//       customDialog('Registrasi Anda Gagal', response.error.toString(), 'Failed',
//           () => Navigator.pop(context), context);
//       isLoading = false;
//     }
//   }

//   void _loginUser() async {
//     ApiResponse response = await login(
//         email: usernameController.text, password: passwordController.text);

//     if (response.error == null) {
//       _saveAndRedirectToHome(response.data as AuthModel);
//     } else {
//       isLoading = false;
//       // dialogFailedLogin();
//     }
//   }

//   void _saveAndRedirectToHome(AuthModel userModel) async {
//     isLoading = false;
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.setInt('userId', userModel.id);
//     await preferences.setString('email', userModel.email);
//     await preferences.setString('name', userModel.name);
//     if (userModel.role != 'penyelia') {
//       await preferences.setString('role', userModel.role);
//     } else {
//       await preferences.setString('role', 'verifikator');
//     }
//     await preferences.setString('token', userModel.token);

//     // ignore: use_build_context_synchronously
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//             builder: (context) => BasePage(
//                   role: userModel.role == 'penyelia'
//                       ? 'verifikator'
//                       : userModel.role,
//                 )),
//         (route) => false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     namaController.addListener(() => setState(() {}));
//     emailController.addListener(() => setState(() {}));
//     usernameController.addListener(() => setState(() {}));
//     phoneController.addListener(() => setState(() {}));
//     passwordController.addListener(() => setState(() {}));
//     confirmController.addListener(() => setState(() {}));
//     return Scaffold(
//       backgroundColor: backgroundDark,
//       body: ListView(
//         physics: const BouncingScrollPhysics(),
//         children: [
//           const SizedBox(
//             height: 50,
//           ),
//           Container(
//             height: 82,
//             margin: const EdgeInsets.symmetric(horizontal: 30),
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(36)),
//             width: double.infinity,
//             child: Image.asset(
//               'assets/img_logo.png',
//               height: 82,
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
//             padding: const EdgeInsets.fromLTRB(18, 17, 18, 27),
//             decoration: BoxDecoration(
//                 color: const Color(0xFF000000).withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(37)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     'Buat Akun',
//                     style: poppins.copyWith(
//                       fontWeight: extraBold,
//                       fontSize: 34,
//                       color: neutral100,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 52,
//                 ),
//                 Text(
//                   'Nama Lengkap (Sesuai Identitas)',
//                   style: poppins.copyWith(fontSize: 12, color: white),
//                 ),
//                 TextFormField(
//                   controller: namaController,
//                   style: poppins.copyWith(fontSize: 12, color: white),
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.all(0),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 14,
//                 ),
//                 Text(
//                   'Email',
//                   style: poppins.copyWith(fontSize: 12, color: white),
//                 ),
//                 TextFormField(
//                   controller: emailController,
//                   style: poppins.copyWith(fontSize: 12, color: white),
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.all(0),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 14,
//                 ),
//                 Text(
//                   'Masukan Username Anda',
//                   style: poppins.copyWith(fontSize: 12, color: white),
//                 ),
//                 TextFormField(
//                   controller: usernameController,
//                   style: poppins.copyWith(fontSize: 12, color: white),
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.all(0),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 14,
//                 ),
//                 Text(
//                   'Nomor Handphone',
//                   style: poppins.copyWith(fontSize: 12, color: white),
//                 ),
//                 TextFormField(
//                   controller: phoneController,
//                   style: poppins.copyWith(fontSize: 12, color: white),
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.all(0),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 14,
//                 ),
//                 Text(
//                   'Kata Sandi',
//                   style: poppins.copyWith(fontSize: 12, color: white),
//                 ),
//                 TextFormField(
//                   controller: passwordController,
//                   obscureText: isObscure,
//                   style: poppins.copyWith(fontSize: 12, color: white),
//                   decoration: InputDecoration(
//                     enabledBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                     focusedBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                     suffixIcon: IconButton(
//                         icon: Icon(isObscure
//                             ? Icons.visibility
//                             : Icons.visibility_off),
//                         color: white,
//                         onPressed: () {
//                           setState(() {
//                             isObscure = !isObscure;
//                           });
//                         }),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 14,
//                 ),
//                 Text(
//                   'Konfirmasi Kata Sandi',
//                   style: poppins.copyWith(fontSize: 12, color: white),
//                 ),
//                 TextFormField(
//                   controller: confirmController,
//                   obscureText: isObscure2,
//                   style: poppins.copyWith(fontSize: 12, color: white),
//                   decoration: InputDecoration(
//                     enabledBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                     focusedBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                     suffixIcon: IconButton(
//                         icon: Icon(isObscure2
//                             ? Icons.visibility
//                             : Icons.visibility_off),
//                         color: white,
//                         onPressed: () {
//                           setState(() {
//                             isObscure2 = !isObscure2;
//                           });
//                         }),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 68,
//                 ),
//                 CustomFilledButtonArrow(
//                     title: 'Daftar Sekarang',
//                     isActive: namaController.text.trim().isNotEmpty &&
//                         emailController.text.trim().isNotEmpty &&
//                         usernameController.text.trim().isNotEmpty &&
//                         phoneController.text.trim().isNotEmpty &&
//                         passwordController.text.trim().isNotEmpty &&
//                         confirmController.text.trim().isNotEmpty,
//                     onPressed: () {
//                       if (namaController.text.trim().isNotEmpty &&
//                           emailController.text.trim().isNotEmpty &&
//                           usernameController.text.trim().isNotEmpty &&
//                           phoneController.text.trim().isNotEmpty &&
//                           passwordController.text.trim().isNotEmpty &&
//                           confirmController.text.trim().isNotEmpty &&
//                           !isLoading) {
//                         isLoading = true;
//                         _registerUser();
//                       } else {
//                         // dialogFailedLogin();
//                         isLoading = false;
//                       }
//                     }),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('Sudah punya akun? ',
//                         style:
//                             poppins.copyWith(color: neutral100, fontSize: 12)),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const LoginPage()),
//                             (route) => false);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         child: Text(
//                           'Masuk',
//                           style: poppins.copyWith(
//                               fontWeight: bold,
//                               fontSize: 16,
//                               color: neutral100),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   // void dialogFailedLogin() {
//   //   showDialog(
//   //       barrierDismissible: false,
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         return AlertDialog(
//   //           shape: const RoundedRectangleBorder(
//   //               borderRadius: BorderRadius.all(Radius.circular(10.0))),
//   //           contentPadding: const EdgeInsets.all(0),
//   //           content: Container(
//   //             width: 290,
//   //             height: 320,
//   //             decoration: BoxDecoration(
//   //               borderRadius: BorderRadius.circular(10),
//   //               color: neutral100,
//   //             ),
//   //             child: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.center,
//   //               children: [
//   //                 Align(
//   //                   alignment: Alignment.topRight,
//   //                   child: IconButton(
//   //                       onPressed: () {}, icon: const Icon(Icons.close)),
//   //                 ),
//   //                 Padding(
//   //                   padding: const EdgeInsets.symmetric(vertical: 10),
//   //                   child: SizedBox(
//   //                     width: 190,
//   //                     child: Text(
//   //                       'Anda tidak bisa masuk!',
//   //                       textAlign: TextAlign.center,
//   //                       style: poppins.copyWith(
//   //                           fontWeight: semiBold,
//   //                           fontSize: 15,
//   //                           color: Colors.black),
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 SizedBox(
//   //                   width: 190,
//   //                   child: Text(
//   //                     'Username dan kata sandi anda salah! silahkan cek kembali',
//   //                     textAlign: TextAlign.center,
//   //                     style: poppins.copyWith(fontSize: 12, color: neutral600),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(
//   //                   height: 8,
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         );
//   //       });
//   // }
// }
