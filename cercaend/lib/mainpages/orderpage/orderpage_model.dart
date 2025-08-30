import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:async';
import 'dart:ui';
import '/index.dart';
import 'orderpage_widget.dart' show OrderpageWidget;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class OrderpageModel extends FlutterFlowModel<OrderpageWidget> {
  ///  Local state fields for this page.

  DocumentReference? userparameter;

  DocumentReference? publicuserparameter;

  DocumentReference? qrCodevalue;

  bool qrdisplay = false;

  int rate1 = 0;

  int rate2 = 0;

  ///  State fields for stateful widgets in this page.

  // State field(s) for orderMaker widget.
  PageController? orderMakerController;

  int get orderMakerCurrentIndex => orderMakerController != null &&
          orderMakerController!.hasClients &&
          orderMakerController!.page != null
      ? orderMakerController!.page!.round()
      : 0;
  bool isDataUploading_uploadData9fw = false;
  FFUploadedFile uploadedLocalFile_uploadData9fw =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadData9fw = '';

  var orderQR = '';
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for orderTaker widget.
  PageController? orderTakerController;

  int get orderTakerCurrentIndex => orderTakerController != null &&
          orderTakerController!.hasClients &&
          orderTakerController!.page != null
      ? orderTakerController!.page!.round()
      : 0;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue;
  // State field(s) for Switch widget.
  bool? switchValue1;
  // State field(s) for Switch widget.
  bool? switchValue2;
  // State field(s) for Switch widget.
  bool? switchValue3;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
