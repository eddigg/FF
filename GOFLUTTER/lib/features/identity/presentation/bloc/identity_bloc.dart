import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/models/kyc_status_model.dart';
import '../../data/models/privacy_settings_model.dart';
import '../../data/models/verification_option_model.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/reputation_data_model.dart';
import '../../data/models/activity_metrics_model.dart';
import '../../data/repositories/identity_repository.dart';

// Events
abstract class IdentityEvent extends Equatable {
  const IdentityEvent();

  @override
  List<Object> get props => [];
}

class LoadIdentityData extends IdentityEvent {}

class UpdateUserProfile extends IdentityEvent {
  final UserProfileModel profile;

  const UpdateUserProfile({required this.profile});

  @override
  List<Object> get props => [profile];
}

class UpdateSocialLinks extends IdentityEvent {
  final Map<String, String> socialLinks;

  const UpdateSocialLinks({required this.socialLinks});

  @override
  List<Object> get props => [socialLinks];
}

class SubmitKYC extends IdentityEvent {
  final String address;
  final Map<String, dynamic> kycData;

  const SubmitKYC({required this.address, required this.kycData});

  @override
  List<Object> get props => [address, kycData];
}

class CheckKYCStatus extends IdentityEvent {
  final String address;

  const CheckKYCStatus({required this.address});

  @override
  List<Object> get props => [address];
}

// States
abstract class IdentityState extends Equatable {
  const IdentityState();

  @override
  List<Object> get props => [];
}

class IdentityInitial extends IdentityState {}

class IdentityLoading extends IdentityState {}

class IdentityLoaded extends IdentityState {
  final UserProfileModel userProfile;
  final KycStatusModel kycStatus;
  final PrivacySettingsModel privacySettings;
  final List<VerificationOptionModel> verificationOptions;
  final List<ActivityModel> activityHistory;
  final ReputationDataModel reputationData;
  final ActivityMetricsModel activityMetrics;

  const IdentityLoaded({
    required this.userProfile,
    required this.kycStatus,
    required this.privacySettings,
    required this.verificationOptions,
    required this.activityHistory,
    required this.reputationData,
    required this.activityMetrics,
  });

  @override
  List<Object> get props => [
        userProfile,
        kycStatus,
        privacySettings,
        verificationOptions,
        activityHistory,
        reputationData,
        activityMetrics,
      ];
}

class IdentityError extends IdentityState {
  final String message;

  const IdentityError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class IdentityBloc extends Bloc<IdentityEvent, IdentityState> {
  final IdentityRepository identityRepository;

  IdentityBloc({required this.identityRepository}) : super(IdentityInitial()) {
    on<LoadIdentityData>(_onLoadIdentityData);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UpdateSocialLinks>(_onUpdateSocialLinks);
    on<SubmitKYC>(_onSubmitKYC);
    on<CheckKYCStatus>(_onCheckKYCStatus);
  }

  Future<void> _onLoadIdentityData(
    LoadIdentityData event,
    Emitter<IdentityState> emit,
  ) async {
    emit(IdentityLoading());
    try {
      // Load actual data from repository
      final userProfile = await identityRepository.getUserProfile();
      final kycStatus = await identityRepository.getKycStatus();
      final privacySettings = await identityRepository.getPrivacySettings();
      final verificationOptions = await identityRepository.getVerificationOptions();
      final activityHistory = await identityRepository.getActivityHistory();
      final reputationData = await identityRepository.getReputationData();
      final activityMetrics = await identityRepository.getActivityMetrics();
      
      emit(IdentityLoaded(
        userProfile: userProfile,
        kycStatus: kycStatus,
        privacySettings: privacySettings,
        verificationOptions: verificationOptions,
        activityHistory: activityHistory,
        reputationData: reputationData,
        activityMetrics: activityMetrics,
      ));
    } catch (e) {
      emit(IdentityError(e.toString()));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<IdentityState> emit,
  ) async {
    try {
      await identityRepository.updateUserProfile(event.profile);
      
      // Reload the data to show updated profile
      add(LoadIdentityData());
    } catch (e) {
      emit(IdentityError(e.toString()));
    }
  }

  Future<void> _onUpdateSocialLinks(
    UpdateSocialLinks event,
    Emitter<IdentityState> emit,
  ) async {
    try {
      await identityRepository.updateSocialLinks(event.socialLinks);
      
      // Reload the data to show updated social links
      add(LoadIdentityData());
    } catch (e) {
      emit(IdentityError(e.toString()));
    }
  }

  Future<void> _onSubmitKYC(
    SubmitKYC event,
    Emitter<IdentityState> emit,
  ) async {
    try {
      await identityRepository.submitKYC(event.address, event.kycData);
      
      // Reload the data to show updated KYC status
      add(LoadIdentityData());
    } catch (e) {
      emit(IdentityError(e.toString()));
    }
  }

  Future<void> _onCheckKYCStatus(
    CheckKYCStatus event,
    Emitter<IdentityState> emit,
  ) async {
    try {
      await identityRepository.checkKYCStatus(event.address);
      
      // Reload the data to show updated KYC status
      add(LoadIdentityData());
    } catch (e) {
      emit(IdentityError(e.toString()));
    }
  }
}