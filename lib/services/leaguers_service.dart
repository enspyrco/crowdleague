import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/extensions/add_problem_extensions.dart';
import 'package:crowdleague/models/actions/leaguers/store_leaguers.dart';
import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/enums/problem_type.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';

class LeaguersService {
  final Firestore firestore;

  LeaguersService({this.firestore});

  Future<ReduxAction> get retrieveLeaguers async {
    try {
      final collection = await firestore.collection('users');
      final snapshot = await collection.getDocuments();
      final leaguers = snapshot.documents.map<
          Leaguer>((user) => Leaguer((b) => b
        ..id = user.data['uid'] as String
        ..name = user.data['name'] as String ?? user.data['uid'] as String
        ..photoUrl = user.data['photoUrl'] as String ??
            'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y'));

      // TODO: this is for testing and can be removed when there is enough real data
      // final vm = VmNewConversationLeaguers.fromJson(leaguers_data_json);
      // return StoreLeaguers((b) => b..leaguers.replace(vm.leaguers));

      return StoreLeaguers((b) => b..leaguers.replace(leaguers));
    } catch (error, trace) {
      return AddProblemObject.from(error, trace, ProblemType.retrieveLeaguers);
    }
  }
}

// TODO: this is for testing and can be removed when there is enough real data
final leaguers_data_json = '''
{"leaguers":[{"id":"1","name":"Andrea Jonus","photoUrl":"https://lh3.googleusercontent.com/a-/AOh14GgpUMMFMDDMSfOSCUunGMkJdJ5TPkmbrU-cQEo6yZk=s96-c"},{"id":"2","name":"Nick Meinhold","photoUrl":"https://lh3.googleusercontent.com/a-/AOh14GjI7gPhw0micPDoMr3PWmsRzksx0kc-z47wMKCpJQ=s96-c"},{"id":"3","name":"David Micallef","photoUrl":"https://lh3.googleusercontent.com/a-/AOh14GgcLuTiYf_wdIIMAw5CPaBDQowtVTHczbRV8eZrIQ=s96-c"}],"state":"ready"}
''';
