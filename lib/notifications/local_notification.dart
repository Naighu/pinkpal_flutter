import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';

class LocalNotification {
  int notificationId;
  bool fullScreenIntent;
  String channelKey;
  String? title, bigPicture, largeIcon;
  String? body;
  NotificationCategory? category;
  String? backgroundColor;
  String? color;
  late List<NotificationButton> buttons;

  LocalNotification(
      {required this.notificationId,
      required this.channelKey,
      this.title,
      this.bigPicture,
      this.fullScreenIntent = false,
      this.body,
      this.largeIcon,
      this.category,
      this.backgroundColor,
      this.color,
      required this.buttons});

  factory LocalNotification.fromJson(Map<String, dynamic> json) {
    final List<NotificationButton> buttons = [];
    if (json['buttons'] != null) {
      late List b;
      if (json["buttons"] is String) {
        b = jsonDecode(json["buttons"]);
      } else {
        b = json["buttons"];
      }
      for (var v in b) {
        buttons.add(NotificationButton.fromJson(v));
      }
    }

    return LocalNotification(
        notificationId: json['notification_id'] == null
            ? 2
            : int.parse(json['notification_id']),
        channelKey: json['channel_key'],
        title: json['title'],
        body: json['body'],
        largeIcon: json["largeIcon"],
        bigPicture: json["bigPicture"],
        fullScreenIntent: json["fullScreenIntent"] == null
            ? false
            : json["fullScreenIntent"] == "true"
                ? true
                : false,
        category: getNotificationCategory(json['category']),
        backgroundColor: json['backgroundColor'],
        buttons: buttons,
        color: json['color']);
  }

  static NotificationCategory getNotificationCategory(String catgeory) {
    switch (catgeory) {
      case "call":
        return NotificationCategory.Call;
      default:
        return NotificationCategory.Message;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['notification_id'] = notificationId;
    data['channel_key'] = channelKey;
    data['title'] = title;
    data['body'] = body;
    data['category'] = category;
    data['backgroundColor'] = backgroundColor;
    data['color'] = color;

    data['buttons'] = buttons.map((v) => v.toJson()).toList();

    return data;
  }
}

class NotificationButton {
  String? key;
  String? label;
  bool? isDangerousOption;
  String? color;
  ButtonAction? action;

  NotificationButton(
      {this.key, this.label, this.isDangerousOption, this.color, this.action});

  NotificationButton.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    isDangerousOption = json['isDangerousOption'];
    color = json['color'];
    action =
        json['action'] != null ? ButtonAction.fromJson(json['action']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['key'] = key;
    data['label'] = label;
    data['isDangerousOption'] = isDangerousOption;
    data['color'] = color;
    if (action != null) {
      data['action'] = action!.toJson();
    }
    return data;
  }
}

class ButtonAction {
  String? type;
  List<String>? arguments;

  ButtonAction({this.type, this.arguments});

  ButtonAction.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    arguments = json['arguments'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['arguments'] = arguments;
    return data;
  }
}
