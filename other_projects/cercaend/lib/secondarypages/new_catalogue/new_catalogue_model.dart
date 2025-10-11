import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'new_catalogue_widget.dart' show NewCatalogueWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewCatalogueModel extends FlutterFlowModel<NewCatalogueWidget> {
  ///  Local state fields for this page.

  List<DocumentReference> itemlist = [];
  void addToItemlist(DocumentReference item) => itemlist.add(item);
  void removeFromItemlist(DocumentReference item) => itemlist.remove(item);
  void removeAtIndexFromItemlist(int index) => itemlist.removeAt(index);
  void insertAtIndexInItemlist(int index, DocumentReference item) =>
      itemlist.insert(index, item);
  void updateItemlistAtIndex(int index, Function(DocumentReference) updateFn) =>
      itemlist[index] = updateFn(itemlist[index]);

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for task widget.
  FocusNode? taskFocusNode1;
  TextEditingController? taskTextController1;
  String? Function(BuildContext, String?)? taskTextController1Validator;
  // State field(s) for Checkbox widget.
  Map<SubmissionRecord, bool> checkboxValueMap = {};
  List<SubmissionRecord> get checkboxCheckedItems =>
      checkboxValueMap.entries.where((e) => e.value).map((e) => e.key).toList();

  // State field(s) for task widget.
  FocusNode? taskFocusNode2;
  TextEditingController? taskTextController2;
  String? Function(BuildContext, String?)? taskTextController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    taskFocusNode1?.dispose();
    taskTextController1?.dispose();

    taskFocusNode2?.dispose();
    taskTextController2?.dispose();
  }
}
