import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/apple_sign_in_fab.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/google_sign_in_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class OtherProviderFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PlatformType>(
        distinct: true,
        converter: (store) => store.state.systemInfo.platform,
        builder: (context, platform) =>
            (platform == PlatformType.ios || platform == PlatformType.macOS)
                ? GoogleSignInFAB()
                : AppleSignInFAB());
  }
}
