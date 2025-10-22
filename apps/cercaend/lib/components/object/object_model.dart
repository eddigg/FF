import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_audio_player.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_media_display.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'object_widget.dart' show ObjectWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ObjectModel extends FlutterFlowModel<ObjectWidget> {
  ///  Local state fields for this component.

  bool iteminfo = false;

  DocumentReference? vote;

  SubmissionRecord? pin;

  DocumentReference? user;

  bool up = true;

  bool down = true;

  ///  State fields for stateful widgets in this component.

  // State field(s) for OImages widget.
  PageController? oImagesController;

  int get oImagesCurrentIndex => oImagesController != null &&
          oImagesController!.hasClients &&
          oImagesController!.page != null
      ? oImagesController!.page!.round()
      : 0;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  /// Query cache managers for this widget.

  final _objectinformationManager = StreamRequestManager<List<UsersRecord>>();
  Stream<List<UsersRecord>> objectinformation({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<UsersRecord>> Function() requestFn,
  }) =>
      _objectinformationManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearObjectinformationCache() => _objectinformationManager.clear();
  void clearObjectinformationCacheKey(String? uniqueKey) =>
      _objectinformationManager.clearRequest(uniqueKey);

  final _objectdataManager = StreamRequestManager<SubmissionRecord>();
  Stream<SubmissionRecord> objectdata({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<SubmissionRecord> Function() requestFn,
  }) =>
      _objectdataManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearObjectdataCache() => _objectdataManager.clear();
  void clearObjectdataCacheKey(String? uniqueKey) =>
      _objectdataManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    /// Dispose query cache managers for this widget.

    clearObjectinformationCache();

    clearObjectdataCache();
  }
}
