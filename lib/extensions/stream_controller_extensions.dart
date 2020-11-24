import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/problems/apple_sign_in_problem.dart';
import 'package:crowdleague/models/problems/connect_to_messages_problem.dart';
import 'package:crowdleague/models/problems/create_conversation_problem.dart';
import 'package:crowdleague/models/problems/delete_profile_pic_problem.dart';
import 'package:crowdleague/models/problems/disregard_conversations_problem.dart';
import 'package:crowdleague/models/problems/disregard_messages_problem.dart';
import 'package:crowdleague/models/problems/disregard_profile_pics_problem.dart';
import 'package:crowdleague/models/problems/disregard_profile_problem.dart';
import 'package:crowdleague/models/problems/email_sign_in_problem.dart';
import 'package:crowdleague/models/problems/general_problem.dart';
import 'package:crowdleague/models/problems/google_sign_in_problem.dart';
import 'package:crowdleague/models/problems/observe_conversations_problem.dart';
import 'package:crowdleague/models/problems/observe_messages_problem.dart';
import 'package:crowdleague/models/problems/observe_processing_failures_problem.dart';
import 'package:crowdleague/models/problems/observe_profile_pics_problem.dart';
import 'package:crowdleague/models/problems/observe_profile_problem.dart';
import 'package:crowdleague/models/problems/plum_database_stream_problem.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/models/problems/processing_failure_problem.dart';
import 'package:crowdleague/models/problems/save_message_problem.dart';
import 'package:crowdleague/models/problems/sign_out_problem.dart';
import 'package:crowdleague/models/problems/update_leaguer_problem.dart';
import 'package:crowdleague/models/problems/update_new_conversation_page_problem.dart';
import 'package:crowdleague/models/problems/upload_task_failure_problem.dart';

extension StreamControllerExt on StreamController<ReduxAction> {
  static final Map<Type,
          ProblemBase Function(dynamic, StackTrace, MapBuilder<String, Object>)>
      _problemMap = {
    AppleSignInProblem: (dynamic error, trace, info) => AppleSignInProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    ConnectToMessagesProblem: (dynamic error, trace, info) =>
        ConnectToMessagesProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    CreateConversationProblem: (dynamic error, trace, info) =>
        CreateConversationProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    DeleteProfilePicProblem: (dynamic error, trace, info) =>
        DeleteProfilePicProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    DisregardConversationsProblem: (dynamic error, trace, info) =>
        DisregardConversationsProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    DisregardMessagesProblem: (dynamic error, trace, info) =>
        DisregardMessagesProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    DisregardProfilePicsProblem: (dynamic error, trace, info) =>
        DisregardProfilePicsProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    DisregardProfileProblem: (dynamic error, trace, info) =>
        DisregardProfileProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    EmailSignInProblem: (dynamic error, trace, info) => EmailSignInProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    GeneralProblem: (dynamic error, trace, info) => GeneralProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    GoogleSignInProblem: (dynamic error, trace, info) => GoogleSignInProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    ObserveConversationsProblem: (dynamic error, trace, info) =>
        ObserveConversationsProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    ObserveMessagesProblem: (dynamic error, trace, info) =>
        ObserveMessagesProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    ObserveProcessingFailuresProblem: (dynamic error, trace, info) =>
        ObserveProcessingFailuresProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    ObserveProfilePicsProblem: (dynamic error, trace, info) =>
        ObserveProfilePicsProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    ObserveProfileProblem: (dynamic error, trace, info) =>
        ObserveProfileProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    PlumDatabaseStreamProblem: (dynamic error, trace, info) =>
        PlumDatabaseStreamProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    ProcessingFailureProblem: (dynamic error, trace, info) =>
        ProcessingFailureProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    SaveMessageProblem: (dynamic error, trace, info) => SaveMessageProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    SignOutProblem: (dynamic error, trace, info) => SignOutProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    UpdateLeaguerProblem: (dynamic error, trace, info) =>
        UpdateLeaguerProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    UpdateNewConversationPageProblem: (dynamic error, trace, info) =>
        UpdateNewConversationPageProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
    UploadTaskFailureProblem: (dynamic error, trace, info) =>
        UploadTaskFailureProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString()
            ..info = info,
        ),
  };

  void addProblem(Type type, dynamic error, StackTrace trace,
          [MapBuilder<String, Object> info]) =>
      add(AddProblem(problem: _problemMap[type](error, trace, info)));
}
