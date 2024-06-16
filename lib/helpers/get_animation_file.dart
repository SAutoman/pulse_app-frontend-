import 'package:lottie/lottie.dart';

LottieBuilder getAnimationFile(String notificationType, double deviceWidth) {
  switch (notificationType) {
    case 'INVALID_ACTIVITY':
      return LottieBuilder.asset(
        'assets/lotties/Failed-Animation.json',
        width: deviceWidth * 0.25,
      );
    case 'NEW_ACTIVITY':
      return LottieBuilder.asset(
        'assets/lotties/Success-Animation.json',
        width: deviceWidth * 0.50,
      );
    default:
      return LottieBuilder.asset(
        'assets/lotties/Notification-Animation.json',
        width: deviceWidth * 0.25,
      );
  }
}
