// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/loginController.dart';
import 'package:AstrowayCustomer/controllers/search_controller.dart';
import 'package:AstrowayCustomer/views/bottomNavigationBarScreen.dart';
import 'package:AstrowayCustomer/views/settings/privacyPolicyScreen.dart';
import 'package:AstrowayCustomer/views/settings/termsAndConditionScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final LoginController loginController = Get.find<LoginController>();
  final HomeController homeController = Get.find<HomeController>();
  final _initialPhone = PhoneNumber(isoCode: "IN");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Get.back();
        Get.back();
        print('call on will pop');
        SystemNavigator.pop();
        //exit(0);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipPath(
                          clipper: CustomClipPath(),
                          child: Container(
                              color: Get.theme.primaryColor,
                              width: Get.width,
                              height: Get.height * 0.27,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.find<SearchControllerCustom>()
                                              .serachTextController
                                              .clear();
                                          Get.find<SearchControllerCustom>()
                                              .searchText = '';
                                          homeController.myOrders.clear();
                                          BottomNavigationController
                                              bottomNavigationController =
                                              Get.find<
                                                  BottomNavigationController>();
                                          bottomNavigationController.setIndex(
                                              0, 0);
                                          Get.off(() =>
                                              BottomNavigationBarScreen(
                                                  index: 0));
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6.0),
                                          child: Text(
                                            "Skip",
                                            textAlign: TextAlign.end,
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                              color: Colors.white,
                                            ),
                                          ).tr(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.02),
                                  Image.asset(
                                    "assets/images/splash.png",
                                    fit: BoxFit.cover,
                                    height: Get.height * 0.15,
                                  ),
                                  Text('Get Daily Horoscope',
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center)
                                      .tr()
                                ],
                              )))),
                      Container(
                          width: Get.width,
                          margin: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Get.height * 0.06,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Login to Astroway',
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800),
                                          textAlign: TextAlign.center)
                                      .tr(),
                                ],
                              ),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                              GetBuilder<LoginController>(
                                  builder: (loginController) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Container(
                                    //   height: 55,
                                    //   decoration: BoxDecoration(
                                    //       color: Colors.white,
                                    //       borderRadius: const BorderRadius.all(
                                    //           Radius.circular(10)),
                                    //       border:
                                    //           Border.all(color: Colors.grey)),
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     child: SizedBox(
                                    //         child: IntlPhoneField(
                                    //       pickerDialogStyle: PickerDialogStyle(
                                    //           backgroundColor: Colors.white),
                                    //       autovalidateMode: null,
                                    //       showDropdownIcon: false,
                                    //       controller:
                                    //           loginController.phoneController,
                                    //       decoration: InputDecoration(
                                    //           //labelText: 'Phone Number',
                                    //           contentPadding:
                                    //               const EdgeInsets.symmetric(
                                    //                   vertical: 5,
                                    //                   horizontal: 10),
                                    //           hintText: 'Phone Number',
                                    //           border: const OutlineInputBorder(
                                    //             borderSide: BorderSide.none,
                                    //           ),
                                    //           enabledBorder:
                                    //               const OutlineInputBorder(
                                    //             borderSide: BorderSide.none,
                                    //           ),
                                    //           disabledBorder:
                                    //               const OutlineInputBorder(
                                    //             borderSide: BorderSide.none,
                                    //           ),
                                    //           focusedBorder:
                                    //               const OutlineInputBorder(
                                    //             borderSide: BorderSide.none,
                                    //           ),
                                    //           errorBorder:
                                    //               const OutlineInputBorder(
                                    //             borderSide: BorderSide.none,
                                    //           ),
                                    //           errorText: null,
                                    //           counterText: ''),
                                    //       initialCountryCode: 'IN',
                                    //       onChanged: (phone) {
                                    //         //print(phone.completeNumber);
                                    //         loginController.updateCountryCode(
                                    //             phone.countryCode);
                                    //       },
                                    //     )),
                                    //   ),
                                    // ),
                                    Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: SizedBox(
                                        child: Theme(
                                          data: ThemeData(
                                            dialogTheme: DialogTheme(
                                              contentTextStyle: const TextStyle(color: Colors.white),
                                              backgroundColor: Colors.grey[800],
                                              surfaceTintColor: Colors.grey[800],
                                            ),
                                          ),
                                          //MOBILE
                                          child: SizedBox(
                                            child: InternationalPhoneNumberInput(
                                              textFieldController: loginController.phoneController,
                                              inputDecoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Phone number',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontFamily: "verdana_regular",
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                              onInputValidated: (bool value) {
                                               // log('$value');
                                              },
                                              selectorConfig: const SelectorConfig(
                                                leadingPadding: 2,
                                                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                              ),
                                              ignoreBlank: false,
                                              autoValidateMode: AutovalidateMode.disabled,
                                              selectorTextStyle: const TextStyle(color: Colors.black),
                                              searchBoxDecoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(2.w)),
                                                    borderSide: const BorderSide(color: Colors.white),
                                                  ),
                                                  hintText: "Search",
                                                  hintStyle: const TextStyle(
                                                    color: Colors.black,
                                                  )),
                                              initialValue: _initialPhone,
                                              formatInput: false,
                                              keyboardType: const TextInputType.numberWithOptions(
                                                  signed: true, decimal: false),
                                              inputBorder: InputBorder.none,
                                              onSaved: (PhoneNumber number) {
                                                log('On Saved: ${number.dialCode}');
                                                loginController.updateCountryCode(number.dialCode);
                                                loginController.updateCountryCode(number.dialCode);
                                              },
                                              onFieldSubmitted: (value) {
                                                log('On onFieldSubmitted: $value');
                                                FocusScope.of(context).unfocus();
                                              },
                                              onInputChanged: (PhoneNumber number) {
                                                log('On onInputChanged: ${number.dialCode}');
                                                loginController.updateCountryCode(number.dialCode);
                                                loginController.updateCountryCode(number.dialCode);
                                              },
                                              onSubmit: () {
                                                log('On onSubmit:');
                                                FocusScope.of(context).unfocus();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                    GestureDetector(
                                      onTap: () async {
                                        bool isValid =
                                            loginController.validedPhone();

                                        if (isValid) {
                                          await loginController.verifyOTP(context);
                                        } else {
                                          global.showToast(
                                            message: loginController.errorText!,
                                            textColor: global.textColor,
                                            bgColor: global.toastBackGoundColor,
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 45,
                                        width: double.infinity,
                                        margin: EdgeInsets.only(top: 20),
                                        decoration: BoxDecoration(
                                          color: Get.theme.primaryColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'SEND OTP',
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ).tr(),
                                            Image.asset(
                                              'assets/images/arrow_left.png',
                                              color: Colors.white,
                                              width: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.01,
                                    ),
                                    SizedBox(
                                      child: Row(children: [
                                        Text(
                                          'By signing up, you agree to our ',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                        ).tr(),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => TermAndConditionScreen());
                                          },
                                          child: Text(
                                            'Terms of use',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 11,
                                                color: Colors.blue),
                                          ).tr(),
                                        ),
                                        Text(' and ',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 11))
                                            .tr(),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => PrivacyPolicyScreen());
                                          },
                                          child: Text(
                                            ' Privacy',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 11,
                                                color: Colors.blue),
                                          ).tr(),
                                        ),
                                      ]),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => PrivacyPolicyScreen());
                                      },
                                      child: Text(
                                        'Policy',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 11,
                                          color: Colors.blue,
                                        ),
                                      ).tr(),
                                    ),
                                  ],
                                );
                              }),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                              // InkWell(
                              //   splashColor: Colors.transparent,
                              //   highlightColor: Colors.transparent,
                              //   onTap: () {
                              //     loginController.truecaller(context);
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: Get.width * 0.02,
                              //         vertical: Get.height * 0.005),
                              //     decoration: BoxDecoration(
                              //         color: Colors.blue,
                              //         borderRadius:
                              //             BorderRadius.circular(Get.width * 0.10)),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         CircleAvatar(
                              //             radius: Get.width * 0.05,
                              //             backgroundColor: Colors.white,
                              //             child: Icon(
                              //               Icons.call,
                              //               color: Colors.blue,
                              //               size: Get.width * 0.07,
                              //             )),
                              //         Expanded(
                              //           child: Row(
                              //             mainAxisAlignment: MainAxisAlignment.center,
                              //             children: [
                              //               Text(
                              //                 'Login via Truecaller',
                              //                 style: TextStyle(
                              //                     fontSize: Get.width * 0.040,
                              //                     fontWeight: FontWeight.w600,
                              //                     color: Colors.white),
                              //               ).tr(),
                              //             ],
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: Get.height * 0.15,
                              ),
                              Container(
                                child: IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '100%',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ).tr(),
                                            Text(
                                              'Privacy',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ).tr()
                                          ],
                                        ),
                                        Container(
                                          width: 1,
                                          height: 60,
                                          color: Colors.black,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Top Astrologer of',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ).tr(),
                                            Text(
                                              'India',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ).tr()
                                          ],
                                        ),
                                        Container(
                                          width: 1,
                                          height: 60,
                                          color: Colors.black,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Happy',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ).tr(),
                                            Text(
                                              'Customers',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ).tr()
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 5.0;
  @override
  Path getClip(Size size) {
    Path path_1 = Path();
    path_1.moveTo(size.width * -0.0034000, size.height * -0.0005200);
    path_1.lineTo(size.width * 1.0044000, size.height * 0.0041400);
    path_1.quadraticBezierTo(size.width * 1.0017750, size.height * 0.6117900,
        size.width * 1.0009000, size.height * 0.8143400);
    path_1.cubicTo(
        size.width * 0.7438000,
        size.height * 1.0302400,
        size.width * 0.3289375,
        size.height * 1.0551400,
        size.width * 0.0006000,
        size.height * 0.8136600);
    path_1.quadraticBezierTo(size.width * -0.0010250, size.height * 0.6101200,
        size.width * -0.0034000, size.height * -0.0005200);
    path_1.close();

    return path_1;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
