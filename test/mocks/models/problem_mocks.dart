import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/app/problem.dart';

final mockProblem = Problem(
    message: 'message',
    type: ProblemType.signOut,
    state: AppState.init(),
    trace: StackTrace.current.toString(),
    info: BuiltMap());
