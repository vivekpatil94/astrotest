import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:get/get.dart';

String GOOGLE_PLACES_API_KEY =
    "AIzaSyAY-pgTvvA-cg_DYqYunSVT8NWYqyfIfDI"; //places api key

// class SearchPlaceController extends GetxController {
//   FlutterGooglePlacesSdk? placesSdk;
//   double? latitude;
//   double? longitude;
//   List<AutocompletePrediction>? predictions = [];
//   TextEditingController searchController = TextEditingController();
//   @override
//   void onInit() {
//     placesSdk = FlutterGooglePlacesSdk(GOOGLE_PLACES_API_KEY);
//     super.onInit();
//   }

//   autoCompleteSearch(String? value) async {
//     if (value!.isNotEmpty) {
//       try {
//         final result = await placesSdk!.findAutocompletePredictions(
//           value,
//           newSessionToken: false,
//         );
//         log('searched place : ${result.predictions}');
//         predictions = result.predictions;
//         update();
//       } catch (e) {
//         debugPrint('$e');
//       }
//     } else {
//       predictions = [];
//       update();
//     }
//   }
// }
class SearchPlaceController extends GetxController {
  FlutterGooglePlacesSdk? placesSdk;
  double? latitude;
  double? longitude;
  List<AutocompletePrediction>? predictions = [];
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    placesSdk = FlutterGooglePlacesSdk(GOOGLE_PLACES_API_KEY);
    super.onInit();
  }

  autoCompleteSearch(String? value) async {
    if (value!.isNotEmpty) {
      final result;
      try {
        if (kIsWeb) {
          result = await _getHardcodedPredictions();
        } else {
          result = await _getPredictions(value);
        }
        log('searched place : ${result.predictions}');
        predictions = result.predictions;
        update();
      } catch (e) {
        debugPrint('$e');
      }
    } else {
      predictions = [];
      update();
    }
  }

  Future<FindAutocompletePredictionsResponse> _getPredictions(
      String value) async {
    if (kIsWeb) {
      // Return hardcoded data for web
      return _getHardcodedPredictions();
    } else {
      // Use Google Places SDK for other platforms
      return await placesSdk!.findAutocompletePredictions(
        value,
        newSessionToken: false,
      );
    }
  }

  // Hardcoded data for testing on web
  Future<FindAutocompletePredictionsResponse> _getHardcodedPredictions() async {
    // Example hardcoded data
    List<AutocompletePrediction> hardcodedPredictions = [
      AutocompletePrediction(
        primaryText: "New York City",
        secondaryText: "NY, USA",
        placeId: "ChIJOwg_06VPwokRYv534QaPC8g",
        distanceMeters: 12,
        fullText: 'oyeahh 1',
      ),
      AutocompletePrediction(
        primaryText: "Los Angeles",
        secondaryText: "CA, USA",
        placeId: "ChIJE9on3F3HwoAR9AhGJW_fL-I",
        distanceMeters: 12,
        fullText: 'oyeahh 2',
      ),
    ];
    return FindAutocompletePredictionsResponse(
      hardcodedPredictions,
    );
  }
}
