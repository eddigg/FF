import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/catalogue/catalogue_widget.dart';
import '/components/settings/settings_widget.dart';
import '/components/user_object/user_object_widget.dart';
import '/flutter_flow/flutter_flow_audio_player.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_media_display.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'userpage_widget.dart' show UserpageWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class UserpageModel extends FlutterFlowModel<UserpageWidget> {
  ///  Local state fields for this page.

  List<DocumentReference> totalAvgRef = [];
  void addToTotalAvgRef(DocumentReference item) => totalAvgRef.add(item);
  void removeFromTotalAvgRef(DocumentReference item) =>
      totalAvgRef.remove(item);
  void removeAtIndexFromTotalAvgRef(int index) => totalAvgRef.removeAt(index);
  void insertAtIndexInTotalAvgRef(int index, DocumentReference item) =>
      totalAvgRef.insert(index, item);
  void updateTotalAvgRefAtIndex(
          int index, Function(DocumentReference) updateFn) =>
      totalAvgRef[index] = updateFn(totalAvgRef[index]);

  bool trsIsSent = true;

  List<int> ratingsList = [];
  void addToRatingsList(int item) => ratingsList.add(item);
  void removeFromRatingsList(int item) => ratingsList.remove(item);
  void removeAtIndexFromRatingsList(int index) => ratingsList.removeAt(index);
  void insertAtIndexInRatingsList(int index, int item) =>
      ratingsList.insert(index, item);
  void updateRatingsListAtIndex(int index, Function(int) updateFn) =>
      ratingsList[index] = updateFn(ratingsList[index]);

  bool webViewOpen = true;
  
  // Wallet related state
  bool walletConnected = false;
  String recipientAddress = '';
  String transactionAmount = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController1;
  String? get choiceChipsValue1 =>
      choiceChipsValueController1?.value?.firstOrNull;
  set choiceChipsValue1(String? val) =>
      choiceChipsValueController1?.value = val != null ? [val] : [];
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for ChoiceChipsOrders widget.
  FormFieldController<List<String>>? choiceChipsOrdersValueController;
  String? get choiceChipsOrdersValue =>
      choiceChipsOrdersValueController?.value?.firstOrNull;
  set choiceChipsOrdersValue(String? val) =>
      choiceChipsOrdersValueController?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChipsAnaytics widget.
  FormFieldController<List<String>>? choiceChipsAnayticsValueController;
  String? get choiceChipsAnayticsValue =>
      choiceChipsAnayticsValueController?.value?.firstOrNull;
  set choiceChipsAnayticsValue(String? val) =>
      choiceChipsAnayticsValueController?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController2;
  String? get choiceChipsValue2 =>
      choiceChipsValueController2?.value?.firstOrNull;
  set choiceChipsValue2(String? val) =>
      choiceChipsValueController2?.value = val != null ? [val] : [];
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
  // State field(s) for ChoiceChipsWallet widget.
  FormFieldController<List<String>>? choiceChipsWalletValueController;
  String? get choiceChipsWalletValue =>
      choiceChipsWalletValueController?.value?.firstOrNull;
  set choiceChipsWalletValue(String? val) =>
      choiceChipsWalletValueController?.value = val != null ? [val] : [];

  /// Query cache managers for this widget.

  final _itemPostsManager = FutureRequestManager<int>();
  Future<int> itemPosts({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<int> Function() requestFn,
  }) =>
      _itemPostsManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearItemPostsCache() => _itemPostsManager.clear();
  void clearItemPostsCacheKey(String? uniqueKey) =>
      _itemPostsManager.clearRequest(uniqueKey);

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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    staggeredViewStreamSubscriptions1.forEach((s) => s?.cancel());
    staggeredViewPagingController1?.dispose();

    /// Dispose query cache managers for this widget.

    clearItemPostsCache();

    clearItemsCountCache();
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