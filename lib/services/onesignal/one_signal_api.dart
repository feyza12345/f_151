import 'dart:io';

import 'package:f151/constants/constants.dart';
import 'package:f151/models/messages_model.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalApi {
  static OneSignal get oneSignalShared => OneSignal.shared;

  static Future<OSDeviceState?> get getDeviceState async =>
      await OneSignal.shared.getDeviceState();

  static Future<String?> get getPlayerId async =>
      await getDeviceState.then((value) => value?.userId);

  static Future setupOneSignal() async {
    final String deviceLang = Platform.localeName;

    //Bildirim izini
    oneSignalShared.promptUserForPushNotificationPermission();

    oneSignalShared
      ..setAppId(kOneSignalAppId)
      ..setLanguage(deviceLang)
      ..sendTag('deviceLang', deviceLang);

    oneSignalShared.setNotificationOpenedHandler((openedResult) {
      String? data = openedResult.notification.additionalData as String?;
      if (data != null) {
        // islemler
      }
    });
  }

  static Future sendMessageNotification({
    required MessagesModel message,
    required String userName,
    required String otherUserNotificationId,
  }) async {
    final additionalData = message.toMap()..remove('timestamp');
    return oneSignalShared.postNotification(OSCreateNotification(
        playerIds: [otherUserNotificationId],
        content: 'Yeni Mesaj\n$userName:\n${message.content}',
        additionalData: additionalData));
  }
}
