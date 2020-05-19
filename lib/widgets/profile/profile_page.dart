import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/actions/profile/retrieve_profile_leaguer.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/profile/vm_profile_page.dart';
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

            return GestureDetector(
              child: Image.network(vm.leaguer.photoUrl),
              onTap: () {
                context.dispatch(PickProfilePic());
              },
            );
          }),
    );
  }
}
