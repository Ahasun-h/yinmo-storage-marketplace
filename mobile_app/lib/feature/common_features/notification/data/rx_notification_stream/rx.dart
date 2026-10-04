import 'package:rxdart/rxdart.dart';

class NotificationRx {
  final BehaviorSubject<bool> hasNotification;
  NotificationRx({required this.hasNotification});
  void setNotification(bool value) => hasNotification.add(value);
  void clearNotification() => hasNotification.add(false);
}
