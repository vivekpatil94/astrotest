// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';
import 'dart:developer';

import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/main.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/bottomNavigationBarScreen.dart';
import 'package:AstrowayCustomer/views/chat/endDialog.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controllers/bottomNavigationController.dart';

class AcceptCallScreen extends StatefulWidget {
  final String? astrologerName;
  final int? astrologerId;
  final String? astrologerProfile;
  final String? token;
  final String? callChannel;
  final int? callId;
  bool isfromnotification;
  String? duration;
  AcceptCallScreen({
    super.key,
    this.astrologerName,
    this.callId,
    this.astrologerId,
    this.astrologerProfile,
    this.token,
    this.callChannel,
    this.duration,
    this.isfromnotification = false,
  });

  @override
  State<AcceptCallScreen> createState() => _AcceptCallScreenState();
}

class _AcceptCallScreenState extends State<AcceptCallScreen> {
  CallController _callController = Get.find<CallController>();

  int uid = 0;
  int? remoteUid;
  int? remoteIdForStop;
  late RtcEngine agoraEngine;
  bool isJoined = false;
  bool isCalling = true;
  Timer? timer;
  Timer? timer2;
  Timer? secTimer;
  bool isMuted = false;
  bool isSpeaker = false;
  int callVolume = 50;
  int? min;
  int? sec;
  int totalSecond = 0;
  bool isHostJoin = false;
  int? localUserId;
  int? endTime;

  bool isStart = false;
  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    log('widget.isfromnotification  -> ${widget.isfromnotification}');
    if (widget.isfromnotification == false) {
      print("akjsbdkjsnad");
      print("${DateTime.now().millisecondsSinceEpoch + 1000 * 300}");
      setupVoiceSDKEngine();
      timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        print('timer call');
        print("local uid " + global.localUid.toString());
        if (global.localUid != null && !isStart) {
          setState(() {
            isStart = true;
          });
          CallController callController = Get.find<CallController>();
          await callController.getAgoraResourceId(
              widget.callChannel!, global.localUid!);
          await callController.getAgoraResourceId2(
              widget.callChannel!, remoteUid!);
          await startRecord();
        }
      });
    } else {
      log('you are coming from notificaiotn');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        global.showToast(
          message: tr('Please leave the call by pressing leave button'),
          textColor: global.textColor,
          bgColor: global.toastBackGoundColor,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              color: Get.theme.primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          widget.astrologerName ?? 'User',
                          style: Get.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        SizedBox(
                          child: status(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  height: 120,
                  width: 120,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: Get.height * 0.1),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60,
                    child: widget.astrologerProfile == null
                        ? Image.asset(
                      Images.deafultUser,
                      fit: BoxFit.cover,
                    )
                        : CachedNetworkImage(
                      height: 12.h,
                      width: 12.h,
                      imageUrl:
                      '${global.imgBaseurl}${widget.astrologerProfile}',
                      imageBuilder: (context, imageProvider) =>
                          CircleAvatar(
                            radius: 5.h,
                            backgroundColor: Colors.transparent,
                            child: Image.network(
                              height: 12.h,
                              width: 12.h,
                              '${global.imgBaseurl}${widget.astrologerProfile}',
                              fit: BoxFit.cover,
                            ),
                          ),
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.asset(
                        Images.deafultUser,
                        fit: BoxFit.contain,
                        height: 60,
                        width: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomSheet: Container(
          height: Get.height * 0.1,
          padding: EdgeInsets.all(10),
          color: Get.theme.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    callVolume = 100;
                    isSpeaker = !isSpeaker;
                  });
                  onVolume(isSpeaker);
                },
                child: Icon(
                  Icons.volume_up,
                  color: isSpeaker ? Colors.blue : Colors.white,
                ),
              ),
              InkWell(
                onTap: () async {
                  print("jaksndkjnsa");
                  print("${_callController.totalSeconds}");
                  if (_callController.totalSeconds < 60 && endTime != null) {
                    // Get.dialog(
                    //   AlertDialog(
                    //     backgroundColor: Colors.white,
                    //     contentPadding: const EdgeInsets.all(0),
                    //     titlePadding: const EdgeInsets.symmetric(
                    //         vertical: 8, horizontal: 10),
                    //     title: Text(
                    //       "You can end chat after one minute",
                    //       style: Get.textTheme.titleMedium,
                    //     ).tr(),
                    //     content: TextButton(
                    //       onPressed: () {
                    //         Get.back();
                    //       },
                    //       child: Text('Ok',
                    //               style:
                    //                   TextStyle(color: Get.theme.primaryColor))
                    //           .tr(),
                    //     ),
                    //   ),
                    // );
                    Get.dialog(
                      EndDialog(),
                    );
                  } else {
                    print('leave call from cut');
                    global.showOnlyLoaderDialog(Get.context);
                    await leave();
                    global.hideLoader();
                    log('leave call from cut');
                    Get.back();
                    Get.back();
                    BottomNavigationController bottomNavigationController =
                    Get.find<BottomNavigationController>();
                    bottomNavigationController.setIndex(0, 0);
                    Get.to(() => BottomNavigationBarScreen(
                      index: 0,
                    ));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isMuted = !isMuted;
                    log('mute $isMuted');
                  });
                  onMute(isMuted);
                },
                child: Icon(
                  Icons.mic_off,
                  color: isMuted ? Colors.blue : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setupVoiceSDKEngine() async {
    // retrieve or request microphone permission
    await [Permission.microphone].request();
    //create an instance of the Agora engine
    try {
      agoraEngine = createAgoraRtcEngine();
      await agoraEngine.initialize(RtcEngineContext(
          appId:
          global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)));
    } catch (e) {
      print('Exception in setupVoiceSDKEngine:- ${e.toString()}');
    }

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            isJoined = true;
            localUserId = connection.localUid;
            global.localUid = localUserId;
            print('userid : - ${connection.localUid}');
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUId, int elapsed) {
          setState(() {
            isHostJoin = true;
            remoteUid = remoteUId;
            endTime = DateTime.now().millisecondsSinceEpoch +
                1000 * int.parse(widget.duration.toString());
            remoteIdForStop = remoteUId;

            _callController.totalSeconds = 0;
            _callController.update();
            timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
              _callController.totalSeconds = _callController.totalSeconds + 1;


              _callController.update();
              print('totalsecons ${_callController.totalSeconds}');
            });
          });
          callController.isLeaveCall = false;
          callController.update();
          print("RemoteId for call" + remoteUid.toString());
        },
        onUserOffline: (RtcConnection connection, int remoteUId,
            UserOfflineReasonType reason) async {
          print('leave call from userOffline');
          await leave();
          log('leave call from cut');
          Get.back();
          Get.back();
          BottomNavigationController bottomNavigationController =
          Get.find<BottomNavigationController>();
          bottomNavigationController.setIndex(0, 0);
          Get.to(() => BottomNavigationBarScreen(
            index: 0,
          ));
        },
        onRtcStats: (connection, stats) {},
      ),
    );
    onVolume(isSpeaker);
    onMute(isMuted);
    join();
  }

  Widget status() {
    return endTime == null
        ? Text("Joining..")
        : CountdownTimer(
      endTime: endTime,
      widgetBuilder: (_, CurrentRemainingTime? time) {
        if (time == null) {
          return Text(
            '00:00:00',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 16.sp,
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: time.hours != null && time.hours != 0
              ? Text(
            '${time.hours ?? '00'} :${time.min! <= 9 ? '0${time.min}' : time.min ?? '00'} :${time.sec! <= 9 ? '0${time.sec}' : time.sec}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 16.sp,
            ),
          )
              : time.min != null
              ? Text(
            '${time.min! <= 9 ? '0${time.min}' : time.min ?? '00'} :${time.sec! <= 9 ? '0${time.sec}' : time.sec}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 16.sp,
            ),
          )
              : Text(
            '${time.sec! <= 9 ? '0${time.sec}' : time.sec}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        );
        // child: time.min != null || time.hours != null
        //     ? Text(
        //         '${time.hours ?? "00"} :${time.min! <= 9 ? '0${time.min}' : time.min ?? '00'} :${time.sec! <= 9 ? '0${time.sec}' : time.sec ?? '00'}',
        //         style: const TextStyle(
        //             fontWeight: FontWeight.w500, color: Colors.white))
        //     : Text(
        //         '${time.sec}',
        //         style: const TextStyle(
        //             fontWeight: FontWeight.w500, color: Colors.white),
        //       ),
        //  );
      },
      onEnd: () async {
        log('in onEnd ${callController.isLeaveCall}');
        if (callController.isLeaveCall == false) {
          global.showOnlyLoaderDialog(Get.context);
          await leave();
          global.hideLoader();
          Get.back();
          Get.back();
          BottomNavigationController bottomNavigationController =
          Get.find<BottomNavigationController>();
          bottomNavigationController.setIndex(1, 0);
          Get.to(() => BottomNavigationBarScreen(
            index: 0,
          ));
          //call the disconnect method from requested customer
        }
      },
    );
  }

  void join() async {
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    print('in join method of customer call');
    await agoraEngine.joinChannel(
      token: widget.token!,
      channelId: widget.callChannel!,
      options: options,
      uid: uid,
    );
  }

  Future startRecord() async {
    CallController callController = Get.find<CallController>();
    await callController.agoraStartRecording(
        widget.callChannel!, global.localUid!, widget.token!);
    await callController.agoraStartRecording2(
        widget.callChannel!, remoteIdForStop!, widget.token!);
  }

  Future stopRecord() async {
    CallController callController = Get.find<CallController>();
    await callController.agoraStopRecording(
        widget.callId!, widget.callChannel!, global.localUid!);
    await callController.agoraStopRecording2(
        widget.callId!, widget.callChannel!, remoteIdForStop!);
  }

  void onMute(bool mute) {
    agoraEngine.muteLocalAudioStream(mute);
  }

  void onVolume(bool isSpeaker) {
    agoraEngine.setEnableSpeakerphone(isSpeaker);
  }

  Future<void> leave() async {
    CallController callController = Get.find<CallController>();
    callController.showBottomAcceptCall = false;
    callController.callBottom = false;
    callController.isLeaveCall = true;
    global.sp!.remove('callBottom');
    global.sp!.setInt('callBottom', 0);
    callController.callBottom = false;
    callController.update();
    await stopRecord();
    global.showOnlyLoaderDialog(Get.context);
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
    if (timer2 != null) {
      timer2?.cancel();
      timer2 = null;
    }
    await callController.endCall(widget.callId!, _callController.totalSeconds,
        global.agoraSid1, global.agoraSid2);
    await global.splashController.getCurrentUserData();
    global.hideLoader();
    if (mounted) {
      setState(() {
        isJoined = false;
        remoteUid = null;
        global.localUid = null;
      });
    }
    agoraEngine.leaveChannel();
    agoraEngine.release(sync: true);
    global.localUid = null;
//    callNotificationHandler().cancelNotification();

    Get.back();
  }

  @override
  void dispose() {
    //callNotificationHandler().cancelNotification();

    if (timer != null) {
      timer!.cancel();
      print('stop timer in despose');
      global.localUid = null;
    }
    if (secTimer != null) {
      secTimer!.cancel();
    }
    super.dispose();
  }
}
