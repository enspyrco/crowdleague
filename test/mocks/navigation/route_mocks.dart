import 'package:flutter/material.dart';

class ModalRouteStub<T> implements ModalRoute<T> {
  final RouteSettings _settings;

  ModalRouteStub({RouteSettings settings}) : _settings = settings;

  @override
  bool get willHandlePopInternally => false;

  @override
  RouteSettings get settings => _settings;

  @override
  void changedExternalState() {
    // TODO: implement changedExternalState
  }

  @override
  void changedInternalState() {
    // TODO: implement changedInternalState
  }

  @override
  // TODO: implement currentResult
  T get currentResult => throw UnimplementedError();

  @override
  void didAdd() {
    // TODO: implement didAdd
  }

  @override
  void didChangeNext(Route nextRoute) {
    // TODO: implement didChangeNext
  }

  @override
  void didChangePrevious(Route previousRoute) {
    // TODO: implement didChangePrevious
  }

  @override
  void didComplete(T result) {
    // TODO: implement didComplete
  }

  @override
  bool didPop(T result) {
    // TODO: implement didPop
    throw UnimplementedError();
  }

  @override
  void didPopNext(Route nextRoute) {
    // TODO: implement didPopNext
  }

  @override
  TickerFuture didPush() {
    // TODO: implement didPush
    throw UnimplementedError();
  }

  @override
  void didReplace(Route oldRoute) {
    // TODO: implement didReplace
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void install() {
    // TODO: implement install
  }

  @override
  // TODO: implement isActive
  bool get isActive => throw UnimplementedError();

  @override
  // TODO: implement isCurrent
  bool get isCurrent => throw UnimplementedError();

  @override
  // TODO: implement isFirst
  bool get isFirst => throw UnimplementedError();

  @override
  // TODO: implement navigator
  NavigatorState get navigator => throw UnimplementedError();

  @override
  // TODO: implement overlayEntries
  List<OverlayEntry> get overlayEntries => throw UnimplementedError();

  @override
  // TODO: implement popped
  Future<T> get popped => throw UnimplementedError();

  @override
  Future<RoutePopDisposition> willPop() {
    // TODO: implement willPop
    throw UnimplementedError();
  }

  @override
  bool offstage;

  @override
  void addLocalHistoryEntry(LocalHistoryEntry entry) {
    // TODO: implement addLocalHistoryEntry
  }

  @override
  void addScopedWillPopCallback(callback) {
    // TODO: implement addScopedWillPopCallback
  }

  @override
  // TODO: implement animation
  Animation<double> get animation => throw UnimplementedError();

  @override
  // TODO: implement barrierColor
  Color get barrierColor => throw UnimplementedError();

  @override
  // TODO: implement barrierCurve
  Curve get barrierCurve => throw UnimplementedError();

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => throw UnimplementedError();

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => throw UnimplementedError();

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    throw UnimplementedError();
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    throw UnimplementedError();
  }

  @override
  // TODO: implement canPop
  bool get canPop => throw UnimplementedError();

  @override
  bool canTransitionFrom(TransitionRoute previousRoute) {
    // TODO: implement canTransitionFrom
    throw UnimplementedError();
  }

  @override
  bool canTransitionTo(TransitionRoute nextRoute) {
    // TODO: implement canTransitionTo
    throw UnimplementedError();
  }

  @override
  // TODO: implement completed
  Future<T> get completed => throw UnimplementedError();

  @override
  // TODO: implement controller
  AnimationController get controller => throw UnimplementedError();

  @override
  Animation<double> createAnimation() {
    // TODO: implement createAnimation
    throw UnimplementedError();
  }

  @override
  AnimationController createAnimationController() {
    // TODO: implement createAnimationController
    throw UnimplementedError();
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    // TODO: implement createOverlayEntries
    throw UnimplementedError();
  }

  @override
  // TODO: implement debugLabel
  String get debugLabel => throw UnimplementedError();

  @override
  // TODO: implement finishedWhenPopped
  bool get finishedWhenPopped => throw UnimplementedError();

  @override
  // TODO: implement hasScopedWillPopCallback
  bool get hasScopedWillPopCallback => throw UnimplementedError();

  @override
  // TODO: implement maintainState
  bool get maintainState => throw UnimplementedError();

  @override
  // TODO: implement opaque
  bool get opaque => throw UnimplementedError();

  @override
  void removeLocalHistoryEntry(LocalHistoryEntry entry) {
    // TODO: implement removeLocalHistoryEntry
  }

  @override
  void removeScopedWillPopCallback(callback) {
    // TODO: implement removeScopedWillPopCallback
  }

  @override
  // TODO: implement reverseTransitionDuration
  Duration get reverseTransitionDuration => throw UnimplementedError();

  @override
  // TODO: implement secondaryAnimation
  Animation<double> get secondaryAnimation => throw UnimplementedError();

  @override
  // TODO: implement semanticsDismissible
  bool get semanticsDismissible => throw UnimplementedError();

  @override
  void setState(fn) {
    // TODO: implement setState
  }

  @override
  // TODO: implement subtreeContext
  BuildContext get subtreeContext => throw UnimplementedError();

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => throw UnimplementedError();
}
