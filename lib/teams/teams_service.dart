import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../players/models/player.dart';
import '../utils/globals.dart';
import 'models/team.dart';
import 'models/team_invite.dart';

class TeamsService {
  TeamsService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseFunctions cloudFunctions,
  })  : _firestore = firestore,
        _auth = auth,
        _cloudFunctions = cloudFunctions;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _cloudFunctions;

  /// Create a new team with the current user as captain
  Future<String> createTeam(String name) async {
    final result = await _cloudFunctions.httpsCallable('createTeam').call({
      'teamName': name,
      'dbName': kDatabaseName,
    });
    return result.data['teamId'];
  }

  /// Get a team by ID
  Future<Team?> getTeam(String teamId) async {
    final doc = await _firestore.collection('teams').doc(teamId).get();
    if (!doc.exists || doc.data() == null) return null;
    return Team.fromJsonWithId(doc.id, doc.data()!);
  }

  /// Stream team updates for real-time UI
  Stream<Team?> teamStream(String teamId) {
    return _firestore.collection('teams').doc(teamId).snapshots().map(
        (doc) => doc.exists ? Team.fromJsonWithId(doc.id, doc.data()!) : null);
  }

  /// Get all teams the current user belongs to
  Future<List<Team>> getUserTeams() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await _firestore
        .collection('teams')
        .where('memberIds', arrayContains: userId)
        .get();

    return snapshot.docs
        .map((doc) => Team.fromJsonWithId(doc.id, doc.data()))
        .toList();
  }

  /// Get the members of a team as Player objects
  Future<List<Player>> getTeamMembers(String teamId) async {
    final team = await getTeam(teamId);
    if (team == null) return [];

    final players = <Player>[];
    for (final memberId in team.memberIds) {
      final doc = await _firestore.collection('profiles').doc(memberId).get();
      if (doc.exists && doc.data() != null) {
        players.add(Player.fromJsonWithId(memberId, doc.data()!));
      }
    }
    return players;
  }

  /// Invite a player to a team (captain only)
  Future<void> inviteToTeam(String teamId, String playerId) async {
    await _cloudFunctions.httpsCallable('inviteToTeam').call({
      'teamId': teamId,
      'inviteeId': playerId,
      'dbName': kDatabaseName,
    });
  }

  /// Accept a team invite
  Future<void> acceptInvite(String inviteId) async {
    await _cloudFunctions.httpsCallable('acceptTeamInvite').call({
      'inviteId': inviteId,
      'dbName': kDatabaseName,
    });
  }

  /// Decline a team invite
  Future<void> declineInvite(String inviteId) async {
    await _cloudFunctions.httpsCallable('declineTeamInvite').call({
      'inviteId': inviteId,
      'dbName': kDatabaseName,
    });
  }

  /// Leave a team (non-captain members only)
  Future<void> leaveTeam(String teamId) async {
    await _cloudFunctions.httpsCallable('leaveTeam').call({
      'teamId': teamId,
      'dbName': kDatabaseName,
    });
  }

  /// Remove a member from a team (captain only)
  Future<void> removeMember(String teamId, String playerId) async {
    await _cloudFunctions.httpsCallable('removeFromTeam').call({
      'teamId': teamId,
      'playerId': playerId,
      'dbName': kDatabaseName,
    });
  }

  /// Transfer captaincy to another member
  Future<void> transferCaptaincy(String teamId, String newCaptainId) async {
    await _cloudFunctions.httpsCallable('transferCaptaincy').call({
      'teamId': teamId,
      'newCaptainId': newCaptainId,
      'dbName': kDatabaseName,
    });
  }

  /// Delete a team (captain only)
  Future<void> deleteTeam(String teamId) async {
    await _cloudFunctions.httpsCallable('deleteTeam').call({
      'teamId': teamId,
      'dbName': kDatabaseName,
    });
  }

  /// Check if the current user is the captain of a team
  bool isCaptain(Team team) {
    return team.captainId == _auth.currentUser?.uid;
  }

  /// Check if the current user is a member of a team
  bool isMember(Team team) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;
    return team.memberIds.contains(userId);
  }

  /// Get pending team invites for the current user
  Future<List<TeamInvite>> getPendingInvites() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await _firestore
        .collection('teamInvites')
        .where('inviteeId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TeamInvite.fromJsonWithId(doc.id, doc.data()))
        .toList();
  }

  /// Get pending invites sent by the current user for a specific team
  Future<List<TeamInvite>> getTeamPendingInvites(String teamId) async {
    final snapshot = await _firestore
        .collection('teamInvites')
        .where('teamId', isEqualTo: teamId)
        .where('status', isEqualTo: 'pending')
        .get();

    return snapshot.docs
        .map((doc) => TeamInvite.fromJsonWithId(doc.id, doc.data()))
        .toList();
  }

  /// Update team details (captain only) - name for now
  Future<void> updateTeam(String teamId, {String? name}) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (updates.isNotEmpty) {
      await _firestore.collection('teams').doc(teamId).update(updates);
    }
  }
}
