import 'package:crowdleague/actions/profile/retrieve_profile_leaguer.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/profile/vm_profile_page.dart';
import 'package:crowdleague/widgets/profile/background_photo.dart';
import 'package:crowdleague/widgets/profile/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: StoreConnector<AppState, VmProfilePage>(
          onInit: (store) => store.dispatch(RetrieveProfileLeaguer()),
          distinct: true,
          converter: (store) => store.state.profilePage,
          builder: (context, vm) {
            if (vm.leaguer == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Stack(
              children: [
                BackgroundPhoto(),
                Positioned(
                  bottom: 30,
                  left: 30,
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                      value: (vm.pickingProfilePic) ? null : 1,
                      strokeWidth: 8,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 30,
                  child: ProfileAvatar(vm.leaguer.photoUrl),
                ),
              ],
            );
          }),
    );
  }
}
