import 'dart:io';

import 'package:appointmentxpert/core/scaffolds/desktop_scaffold.dart';
import 'package:appointmentxpert/core/scaffolds/mobile_scaffold.dart';
import 'package:appointmentxpert/core/scaffolds/public_master_layout/public_master_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../core/app_export.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../domain/facebookauth/facebook_auth_helper.dart';
import '../../domain/googleauth/google_auth_helper.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_style.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/loader.dart';
import '../../widgets/responsive.dart';
import '../dashboard_screen/shared_components/responsive_builder.dart';
import '../login_success_dialog/controller/login_success_controller.dart';
import '../login_success_dialog/login_success_dialog.dart';
import '../sign_up_screen/sign_up_screen.dart';
import '../verify_number/controller/verify_number_controller.dart';
import '../verify_number/verify_number_screen.dart';
import 'controller/login_controller.dart';

class LoginScreen extends GetWidget<LoginController> {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        top: false,
        bottom: false,
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: ResponsiveBuilder(
              mobileBuilder: (context, constraints) {
                return MobileScaffold(
                    child: _buildSmallScreen(size, controller));
              },
              tabletBuilder: (context, constraints) {
                return PublicMasterLayout(
                    //isAppBarVisible: false,
                    body: _buildSmallScreen(size, controller));
              },
              desktopBuilder: (context, constraints) {
                return DesktopScaffold(
                  isAppBarVisible: false,
                  child: _buildLargeScreen(size, controller),
                );
              },
            )));
  }

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    LoginController loginController,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Image.asset(
              'assets/images/bannerbg.png',
              fit: BoxFit.fill,
              // height: size.height * 0.2,
              // width: size.width / 2,
            ),
          ),
          SizedBox(width: size.width * 0.06),
          Expanded(
            flex: 5,
            child: _buildMainBody(
              size,
              loginController,
            ),
          ),
        ],
      ),
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    LoginController loginController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        loginController,
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    LoginController simpleUIController,
  ) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(Get.context!).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                !Responsive.isDesktop(Get.context!)
                    ? 'assets' '/images/logo-opdxpert.png'
                    : '/images/logo-opdxpert.png',
                fit: BoxFit.contain,
                height: size.height * 0.145,
                width: size.width * 0.8,
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    /// username or Gmail
                    CustomTextFormField(
                      labelText: 'Mobile Number',
                      controller: controller.emailController,
                      textInputAction: TextInputAction.done,
                      isRequired: true,
                      maxLength: 10,
                      textInputType: TextInputType.phone,
                      validator: (value) {
                        return controller.numberValidator(value ?? "");
                      },
                      padding: TextFormFieldPadding.PaddingT14,
                      prefixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(56)),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    // Obx(() => CustomCheckbox(
                    //       text: "Remember me",
                    //       fontStyle:
                    //           CheckboxFontStyle.SFProDisplayRegular14Bluegray800,
                    //       value: controller.isRememberMe.value,
                    //       onChange: (p0) {
                    //         controller.isRememberMe.value = p0;
                    //       },
                    //     )),
                    // SizedBox(
                    //   height: size.height * 0.01,
                    // ),

                    /// Login Button
                    Obx(() => controller.isloading.value
                        ? SizedBox(height: 50, child: ThreeDotLoader())
                        : loginButton()),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                onTapTxtSignUp();
                              },
                              child: Padding(
                                padding: getPadding(left: 4, top: 1),
                                child: RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: "Don't have an account? ",
                                      style: AppStyle.txtRalewayRomanRegular15
                                          .copyWith(
                                              letterSpacing:
                                                  getHorizontalSize(0.5)),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Sign Up',
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                onTapTxtSignUp();
                                              }),
                                      ]),
                                ),
                              ))
                        ]),
                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    Padding(
                        padding: getPadding(top: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: getPadding(top: 8, bottom: 9),
                                  child: SizedBox(
                                      width: getHorizontalSize(30),
                                      child: Divider(
                                          height: getVerticalSize(1),
                                          thickness: getVerticalSize(1),
                                          color: ColorConstant.gray200))),
                              Text("lbl_or".tr,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtRalewayRomanRegular16),
                              Padding(
                                  padding: getPadding(top: 8, bottom: 9),
                                  child: SizedBox(
                                      width: getHorizontalSize(30),
                                      child: Divider(
                                          height: getVerticalSize(1),
                                          thickness: getVerticalSize(1),
                                          color: ColorConstant.gray200)))
                            ])),
                    GestureDetector(
                        onTap: () {
                          //onTapRowgoogle();
                        },
                        child: Center(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  // width:
                                  //     MediaQuery.of(Get.context!).size.width /
                                  //         1.5,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 18.0, bottom: 0.0),
                                    child: SignInButton(
                                      Buttons.google,
                                      text: "Sign in with Google",
                                      onPressed: () {
                                        onTapRowgoogle();
                                      },
                                    ),
                                  ),
                                ),

                                // CustomImageView(
                                //     svgPath: ImageConstant.imgGoogle,
                                //     height: getVerticalSize(20),
                                //     //width: getHorizontalSize(220),
                                //     margin: getMargin(top: 1, bottom: 1))),
                                // Container(
                                //     margin: getMargin(top: 20, left: 5),
                                //     padding: getPadding(
                                //         left: 16, top: 16, right: 16, bottom: 16),
                                //     decoration: AppDecoration.outlineGray200
                                //         .copyWith(
                                //             borderRadius:
                                //                 BorderRadiusStyle.roundedBorder8),
                                //     child: CustomImageView(
                                //         svgPath: ImageConstant.imgCamera,
                                //         height: getVerticalSize(20),
                                //         width: getHorizontalSize(16),
                                //         margin: getMargin(top: 1, bottom: 1),
                                //         onTap: () {
                                //           onTapImgCamera();
                                //         })),
                                // Container(
                                //     margin: getMargin(top: 20, left: 5),
                                //     padding: getPadding(
                                //         left: 16, top: 16, right: 16, bottom: 16),
                                //     decoration: AppDecoration.outlineGray200
                                //         .copyWith(
                                //             borderRadius:
                                //                 BorderRadiusStyle.roundedBorder8),
                                //     child: CustomImageView(
                                //         svgPath: ImageConstant.imgFacebook,
                                //         height: getVerticalSize(20),
                                //         color: Colors.blue,
                                //         width: getHorizontalSize(16),
                                //         margin: getMargin(top: 1, bottom: 1),
                                //         onTap: () {
                                //           //onTapImgCamera();
                                //           onTapRowfacebook();
                                //         })),
                              ]),
                        )),

                    !kIsWeb
                        ? Platform.isIOS
                            ? Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: SizedBox(
                                  width: 300,
                                  height: 40,
                                  child: SignInWithAppleButton(
                                    onPressed: () async {
                                      final credential = await SignInWithApple
                                          .getAppleIDCredential(
                                        scopes: [
                                          AppleIDAuthorizationScopes.email,
                                          AppleIDAuthorizationScopes.fullName,
                                        ],
                                      );
                                      Get.to(SignUpScreen(
                                          name: credential.givenName,
                                          email: credential.email));
                                      // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                                      // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                                    },
                                  ),
                                ),
                              )
                            : const SizedBox(
                                height: 20,
                              )
                        : const SizedBox(
                            height: 20,
                          ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Powered By',
                            style: AppStyle.txtInterRegular16,
                          ),
                          const SizedBox(
                            height: 75,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image(
                                image: AssetImage('assets/images/logof.png'),
                                fit: BoxFit.contain, // use this
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Login Button
  Widget loginButton() {
    return SizedBox(
      height: 40,
      width: 200,
      child: ElevatedButton(
          //height: getVerticalSize(55),
          child: Text(
            "lbl_login".tr,
            style: AppStyle.txtRalewayRomanMedium14WhiteA700,
          ),
          //margin: getMargin(top: 12, bottom: 10),
          onPressed: () async {
            if (controller.trySubmit()) {
              controller.isloading.value = true;
              bool resp = await controller.callOtp(
                  controller.emailController.text, "login");
              if (resp) {
                VerifyNumberController verifyNumberController =
                    Get.put(VerifyNumberController());

                !Responsive.isDesktop(Get.context!)
                    ? Get.to(() => VerifyPhoneNumberScreen(
                          phoneNumber: controller.emailController.text,
                        ))
                    // ? await showModalBottomSheet<dynamic>(
                    //     context: Get.context!,
                    //     isDismissible: true,
                    //     isScrollControlled: false,
                    //     enableDrag: false,
                    //     elevation: 2.0,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(20.0),
                    //     ),
                    //     builder: (context) {
                    //       return ClipRRect(
                    //         borderRadius: BorderRadius.circular(20),
                    //         child: VerifyPhoneNumberScreen(
                    //             phoneNumber: controller.emailController.text),
                    //       );
                    //     },
                    //   )
                    : WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                            context: Get.context!,
                            builder: (context) => AlertDialog(
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('Close'))
                                  ],
                                  title: const Text('Verify Phone Number'),
                                  content: SizedBox(
                                      height: Responsive.isMobile(context)
                                          ? 300
                                          : 400,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: VerifyPhoneNumberScreen(
                                          phoneNumber:
                                              controller.emailController.text)),
                                )).then((value) {
                          bool value = controller.trySubmit();
                          if (value) onTapSignin(controller);
                        });
                      });
              }
            }
          }),
    );
  }
}

onTapTxtForgotPassword() {
  Get.toNamed(
    AppRoutes.resetPasswordEmailTabContainerScreen,
  );
}

Future<void> onTapSignin(LoginController controller) async {
  Map<String, dynamic> requestData = {
    'userName': controller.emailController.text,
    'password': "qwerty"
  };
  try {
    await controller.callCreateLogin(requestData);
    // onTapLoginOne();
  } on Map {
    _onOnTapSignInError();
  } on NoInternetException catch (e) {
    Get.rawSnackbar(message: e.toString());
  } catch (e) {
    Get.rawSnackbar(message: e.toString());
  }
}

void _onOnTapSignInError() {
  Fluttertoast.showToast(
    msg: "Invalid username or password!",
  );
}

onTapLoginOne() {
  Get.dialog(AlertDialog(
    backgroundColor: Colors.transparent,
    contentPadding: EdgeInsets.zero,
    insetPadding: const EdgeInsets.only(left: 0),
    content: LoginSuccessDialog(
      Get.put(
        LoginSuccessController(),
      ),
    ),
  ));
}

onTapTxtSignUp() {
  Get.toNamed(
    AppRoutes.signUpScreen,
  );
}

onTapRowgoogle() async {
  if (kIsWeb) {
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    final FirebaseAuth auth = FirebaseAuth.instance;
    //final GoogleSignIn googleSignIn = GoogleSignIn();
    auth.signInWithPopup(authProvider).then((result) {
      print(result);
    }).catchError((e) {
      print(e);
      var snackbar = const SnackBar(
          width: 500,
          padding: EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(seconds: 3),
          dismissDirection: DismissDirection.horizontal,
          closeIconColor: Colors.white,
          backgroundColor: Colors.redAccent,
          content: Center(
            child: Text(
              "Error, please try again later!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ));
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackbar);
    });
  } else {
    await GoogleAuthHelper().googleSignInProcess().then((googleUser) {
      if (googleUser != null) {
        //TODO Actions to be performed after signin
        Get.to(SignUpScreen(
            name: googleUser.displayName, email: googleUser.email));
      } else {
        Get.snackbar('Error', 'user data is empty');
      }
    }).catchError((onError) {
      Get.snackbar('Error', onError.toString());
    });
  }
}

onTapImgCamera() async {
  // await PermissionManager.askForPermission(Permission.camera);
  // await PermissionManager.askForPermission(Permission.storage);
  // List<String?>? imageList = [];
  // await FileManager().showModelSheetForImage(getImages: (value) async {
  //   imageList = value;
  // });
}

onTapRowfacebook() async {
  await FacebookAuthHelper().facebookSignInProcess().then((facebookUser) {
    //TODO Actions to be performed after signin
  }).catchError((onError) {
    Get.snackbar('Error', onError.toString());
  });
}

onTapArrowleft() {
  Get.back();
}
