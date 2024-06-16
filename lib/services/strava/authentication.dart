import 'package:strava_client/strava_client.dart';

class StravaAuth {
  final StravaClient stravaClient;
  StravaAuth(this.stravaClient);

  Future<TokenResponse> launchAuthentication(
      List<AuthenticationScope> scopes, String redirectUrl) {
    return stravaClient.authentication.authenticate(
        scopes: scopes,
        redirectUrl: redirectUrl,
        forceShowingApproval: false,
        callbackUrlScheme: "stravaflutter",
        preferEphemeral: true);
  }

  Future<void> launchDeauthorize() {
    return stravaClient.authentication.deAuthorize();
  }
}
