import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/catalogue/catalogue_widget.dart';
import '/components/object/object_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_audio_player.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_media_display.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'package:badges/badges.dart' as badges;
import 'publicpage_widget.dart' show PublicpageWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class PublicpageModel extends FlutterFlowModel<PublicpageWidget> {
  ///  Local state fields for this page.

  bool itemadding = false;

  List<DocumentReference> bagitems = [];
  void addToBagitems(DocumentReference item) => bagitems.add(item);
  void removeFromBagitems(DocumentReference item) => bagitems.remove(item);
  void removeAtIndexFromBagitems(int index) => bagitems.removeAt(index);
  void insertAtIndexInBagitems(int index, DocumentReference item) =>
      bagitems.insert(index, item);
  void updateBagitemsAtIndex(int index, Function(DocumentReference) updateFn) =>
      bagitems[index] = updateFn(bagitems[index]);

  bool? userpinned;

  bool isPinned = true;

  List<double> refvaluesinbagitems = [];
  void addToRefvaluesinbagitems(double item) => refvaluesinbagitems.add(item);
  void removeFromRefvaluesinbagitems(double item) =>
      refvaluesinbagitems.remove(item);
  void removeAtIndexFromRefvaluesinbagitems(int index) =>
      refvaluesinbagitems.removeAt(index);
  void insertAtIndexInRefvaluesinbagitems(int index, double item) =>
      refvaluesinbagitems.insert(index, item);
  void updateRefvaluesinbagitemsAtIndex(int index, Function(double) updateFn) =>
      refvaluesinbagitems[index] = updateFn(refvaluesinbagitems[index]);

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController1;
  String? get choiceChipsValue1 =>
      choiceChipsValueController1?.value?.firstOrNull;
  set choiceChipsValue1(String? val) =>
      choiceChipsValueController1?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController2;
  String? get choiceChipsValue2 =>
      choiceChipsValueController2?.value?.firstOrNull;
  set choiceChipsValue2(String? val) =>
      choiceChipsValueController2?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController3;
  String? get choiceChipsValue3 =>
      choiceChipsValueController3?.value?.firstOrNull;
  set choiceChipsValue3(String? val) =>
      choiceChipsValueController3?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChipsPosts widget.
  FormFieldController<List<String>>? choiceChipsPostsValueController;
  List<String>? get choiceChipsPostsValues =>
      choiceChipsPostsValueController?.value;
  set choiceChipsPostsValues(List<String>? val) =>
      choiceChipsPostsValueController?.value = val;
  // State field(s) for StaggeredView widget.

  PagingController<DocumentSnapshot?, SubmissionRecord>?
      staggeredViewPagingController1;
  Query? staggeredViewPagingQuery1;
  List<StreamSubscription?> staggeredViewStreamSubscriptions1 = [];

  // State field(s) for ChoiceChipsItems widget.
  FormFieldController<List<String>>? choiceChipsItemsValueController;
  String? get choiceChipsItemsValue =>
      choiceChipsItemsValueController?.value?.firstOrNull;
  set choiceChipsItemsValue(String? val) =>
      choiceChipsItemsValueController?.value = val != null ? [val] : [];
  // State field(s) for BagPageView widget.
  PageController? bagPageViewController;

  int get bagPageViewCurrentIndex => bagPageViewController != null &&
          bagPageViewController!.hasClients &&
          bagPageViewController!.page != null
      ? bagPageViewController!.page!.round()
      : 0;
  // State field(s) for ChoiceChipsORDERMETHODS widget.
  FormFieldController<List<String>>? choiceChipsORDERMETHODSValueController;
  String? get choiceChipsORDERMETHODSValue =>
      choiceChipsORDERMETHODSValueController?.value?.firstOrNull;
  set choiceChipsORDERMETHODSValue(String? val) =>
      choiceChipsORDERMETHODSValueController?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChipsWALLETMETHODS widget.
  FormFieldController<List<String>>? choiceChipsWALLETMETHODSValueController;
  String? get choiceChipsWALLETMETHODSValue =>
      choiceChipsWALLETMETHODSValueController?.value?.firstOrNull;
  set choiceChipsWALLETMETHODSValue(String? val) =>
      choiceChipsWALLETMETHODSValueController?.value = val != null ? [val] : [];

  /// Query cache managers for this widget.

  final _itemsCountManager = FutureRequestManager<int>();
  Future<int> itemsCount({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<int> Function() requestFn,
  }) =>
      _itemsCountManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearItemsCountCache() => _itemsCountManager.clear();
  void clearItemsCountCacheKey(String? uniqueKey) =>
      _itemsCountManager.clearRequest(uniqueKey);

  final _postsCountManager = FutureRequestManager<int>();
  Future<int> postsCount({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<int> Function() requestFn,
  }) =>
      _postsCountManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearPostsCountCache() => _postsCountManager.clear();
  void clearPostsCountCacheKey(String? uniqueKey) =>
      _postsCountManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    staggeredViewStreamSubscriptions1.forEach((s) => s?.cancel());
    staggeredViewPagingController1?.dispose();

    /// Dispose query cache managers for this widget.

    clearItemsCountCache();

    clearPostsCountCache();
  }

  /// Additional helper methods.
  PagingController<DocumentSnapshot?, SubmissionRecord>
      setStaggeredViewController1(
    Query query, {
    DocumentReference<Object?>? parent,
  }) {
    staggeredViewPagingController1 ??=
        _createStaggeredViewController1(query, parent);
    if (staggeredViewPagingQuery1 != query) {
      staggeredViewPagingQuery1 = query;
      staggeredViewPagingController1?.refresh();
    }
    return staggeredViewPagingController1!;
  }

  PagingController<DocumentSnapshot?, SubmissionRecord>
      _createStaggeredViewController1(
    Query query,
    DocumentReference<Object?>? parent,
  ) {
    final controller = PagingController<DocumentSnapshot?, SubmissionRecord>(
        firstPageKey: null);
    return controller
      ..addPageRequestListener(
        (nextPageMarker) => querySubmissionRecordPage(
          queryBuilder: (_) => staggeredViewPagingQuery1 ??= query,
          nextPageMarker: nextPageMarker,
          streamSubscriptions: staggeredViewStreamSubscriptions1,
          controller: controller,
          pageSize: 25,
          isStream: true,
        ),
      );
  }
}
