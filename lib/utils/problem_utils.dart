import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
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

final Map<Type, ProblemBase Function(dynamic, StackTrace, Map<String, Object>)>
    map = {
  AppleSignInProblem: (dynamic error, trace, info) => AppleSignInProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  ConnectToMessagesProblem: (dynamic error, trace, info) =>
      ConnectToMessagesProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  CreateConversationProblem: (dynamic error, trace, info) =>
      CreateConversationProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  DeleteProfilePicProblem: (dynamic error, trace, info) =>
      DeleteProfilePicProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  DisregardConversationsProblem: (dynamic error, trace, info) =>
      DisregardConversationsProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  DisregardMessagesProblem: (dynamic error, trace, info) =>
      DisregardMessagesProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  DisregardProfilePicsProblem: (dynamic error, trace, info) =>
      DisregardProfilePicsProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  DisregardProfileProblem: (dynamic error, trace, info) =>
      DisregardProfileProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  EmailSignInProblem: (dynamic error, trace, info) => EmailSignInProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  GeneralProblem: (dynamic error, trace, info) => GeneralProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  GoogleSignInProblem: (dynamic error, trace, info) => GoogleSignInProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  ObserveConversationsProblem: (dynamic error, trace, info) =>
      ObserveConversationsProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  ObserveMessagesProblem: (dynamic error, trace, info) =>
      ObserveMessagesProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  ObserveProcessingFailuresProblem: (dynamic error, trace, info) =>
      ObserveProcessingFailuresProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  ObserveProfilePicsProblem: (dynamic error, trace, info) =>
      ObserveProfilePicsProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  ObserveProfileProblem: (dynamic error, trace, info) => ObserveProfileProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  PlumDatabaseStreamProblem: (dynamic error, trace, info) =>
      PlumDatabaseStreamProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  ProcessingFailureProblem: (dynamic error, trace, info) =>
      ProcessingFailureProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  SaveMessageProblem: (dynamic error, trace, info) => SaveMessageProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  SignOutProblem: (dynamic error, trace, info) => SignOutProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  UpdateLeaguerProblem: (dynamic error, trace, info) => UpdateLeaguerProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  UpdateNewConversationPageProblem: (dynamic error, trace, info) =>
      UpdateNewConversationPageProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
  UploadTaskFailureProblem: (dynamic error, trace, info) =>
      UploadTaskFailureProblem(
        message: '$error',
        trace: '$trace',
        info: info == null ? null : BuiltMap(info),
      ),
};

AddProblem createAddProblem(Type type, dynamic error, StackTrace trace,
    [Map<String, Object> info]) {
  return AddProblem(problem: map[type](error, trace, info));
}

ProblemBase createProblem(Type type, dynamic error, StackTrace trace,
    [Map<String, Object> info]) {
  return map[type](error, trace, info);
}
