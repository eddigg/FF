import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/api_requests/api_manager.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  bool _isCategoriesExpanded = false;
  bool get isCategoriesExpanded => _isCategoriesExpanded;
  set isCategoriesExpanded(bool value) {
    _isCategoriesExpanded = value;
  }

  bool _isAssistantExpanded = false;
  bool get isAssistantExpanded => _isAssistantExpanded;
  set isAssistantExpanded(bool value) {
    _isAssistantExpanded = value;
  }

  String _recorded = '';
  String get recorded => _recorded;
  set recorded(String value) {
    _recorded = value;
  }

  bool _recording = false;
  bool get recording => _recording;
  set recording(bool value) {
    _recording = value;
  }

  List<String> _ImagesList = [];
  List<String> get ImagesList => _ImagesList;
  set ImagesList(List<String> value) {
    _ImagesList = value;
  }

  void addToImagesList(String value) {
    ImagesList.add(value);
  }

  void removeFromImagesList(String value) {
    ImagesList.remove(value);
  }

  void removeAtIndexFromImagesList(int index) {
    ImagesList.removeAt(index);
  }

  void updateImagesListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    ImagesList[index] = updateFn(_ImagesList[index]);
  }

  void insertAtIndexInImagesList(int index, String value) {
    ImagesList.insert(index, value);
  }

  List<String> _choicesLists = [];
  List<String> get choicesLists => _choicesLists;
  set choicesLists(List<String> value) {
    _choicesLists = value;
  }

  void addToChoicesLists(String value) {
    choicesLists.add(value);
  }

  void removeFromChoicesLists(String value) {
    choicesLists.remove(value);
  }

  void removeAtIndexFromChoicesLists(int index) {
    choicesLists.removeAt(index);
  }

  void updateChoicesListsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    choicesLists[index] = updateFn(_choicesLists[index]);
  }

  void insertAtIndexInChoicesLists(int index, String value) {
    choicesLists.insert(index, value);
  }

  bool _isUserOrdering = false;
  bool get isUserOrdering => _isUserOrdering;
  set isUserOrdering(bool value) {
    _isUserOrdering = value;
  }

  bool _isBagOpen = false;
  bool get isBagOpen => _isBagOpen;
  set isBagOpen(bool value) {
    _isBagOpen = value;
  }

  bool _isUserinPublicpage = false;
  bool get isUserinPublicpage => _isUserinPublicpage;
  set isUserinPublicpage(bool value) {
    _isUserinPublicpage = value;
  }

  List<String> _activethread = [];
  List<String> get activethread => _activethread;
  set activethread(List<String> value) {
    _activethread = value;
  }

  void addToActivethread(String value) {
    activethread.add(value);
  }

  void removeFromActivethread(String value) {
    activethread.remove(value);
  }

  void removeAtIndexFromActivethread(int index) {
    activethread.removeAt(index);
  }

  void updateActivethreadAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    activethread[index] = updateFn(_activethread[index]);
  }

  void insertAtIndexInActivethread(int index, String value) {
    activethread.insert(index, value);
  }

  bool _showfullfeed = true;
  bool get showfullfeed => _showfullfeed;
  set showfullfeed(bool value) {
    _showfullfeed = value;
  }

  bool _isWalletConnected = false;
  bool get isWalletConnected => _isWalletConnected;
  set isWalletConnected(bool value) {
    _isWalletConnected = value;
  }

  String _walletAddress = '';
  String get walletAddress => _walletAddress;
  set walletAddress(String value) {
    _walletAddress = value;
  }

  int _chainId = 0;
  int get chainId => _chainId;
  set chainId(int value) {
    _chainId = value;
  }

  String _qrCodeURI = '';
  String get qrCodeURI => _qrCodeURI;
  set qrCodeURI(String value) {
    _qrCodeURI = value;
  }

  String _connectionError = '';
  String get connectionError => _connectionError;
  set connectionError(String value) {
    _connectionError = value;
  }

  String _blockchainUrl = '';
  String get blockchainUrl => _blockchainUrl;
  set blockchainUrl(String value) {
    _blockchainUrl = value;
  }

  String _contactAdress = '';
  String get contactAdress => _contactAdress;
  set contactAdress(String value) {
    _contactAdress = value;
  }

  String _ethPrivateKey = '';
  String get ethPrivateKey => _ethPrivateKey;
  set ethPrivateKey(String value) {
    _ethPrivateKey = value;
  }

  String _className = '';
  String get className => _className;
  set className(String value) {
    _className = value;
  }

  List<String> _transactionHashes = [];
  List<String> get transactionHashes => _transactionHashes;
  set transactionHashes(List<String> value) {
    _transactionHashes = value;
  }

  void addToTransactionHashes(String value) {
    transactionHashes.add(value);
  }

  void removeFromTransactionHashes(String value) {
    transactionHashes.remove(value);
  }

  void removeAtIndexFromTransactionHashes(int index) {
    transactionHashes.removeAt(index);
  }

  void updateTransactionHashesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    transactionHashes[index] = updateFn(_transactionHashes[index]);
  }

  void insertAtIndexInTransactionHashes(int index, String value) {
    transactionHashes.insert(index, value);
  }

  DateTime? _lastUpdateTimestamp;
  DateTime? get lastUpdateTimestamp => _lastUpdateTimestamp;
  set lastUpdateTimestamp(DateTime? value) {
    _lastUpdateTimestamp = value;
  }
}
