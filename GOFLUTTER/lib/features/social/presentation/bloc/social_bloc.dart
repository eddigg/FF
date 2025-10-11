import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/post_model.dart';
import '../../data/models/trending_topic_model.dart';
import '../../data/models/moderation_item_model.dart';
import '../../data/models/user_profile_summary_model.dart';
import '../../data/repositories/social_repository.dart';

// Events
abstract class SocialEvent extends Equatable {
  const SocialEvent();

  @override
  List<Object> get props => [];
}

class LoadSocialData extends SocialEvent {}

class CreatePost extends SocialEvent {
  final String content;

  const CreatePost({required this.content});

  @override
  List<Object> get props => [content];
}

class LikePost extends SocialEvent {
  final String postId;

  const LikePost({required this.postId});

  @override
  List<Object> get props => [postId];
}

class UnlikePost extends SocialEvent {
  final String postId;

  const UnlikePost({required this.postId});

  @override
  List<Object> get props => [postId];
}

class AddComment extends SocialEvent {
  final String postId;
  final String content;

  const AddComment({required this.postId, required this.content});

  @override
  List<Object> get props => [postId, content];
}

class RepostPost extends SocialEvent {
  final String postId;

  const RepostPost({required this.postId});

  @override
  List<Object> get props => [postId];
}

class ToggleLikePost extends SocialEvent {
  final String postId;

  const ToggleLikePost({required this.postId});

  @override
  List<Object> get props => [postId];
}

class ReportPost extends SocialEvent {
  final String postId;

  const ReportPost({required this.postId});

  @override
  List<Object> get props => [postId];
}

class ModerateContent extends SocialEvent {
  final String itemId;
  final String action;

  const ModerateContent({required this.itemId, required this.action});

  @override
  List<Object> get props => [itemId, action];
}

class LoadTrendingPosts extends SocialEvent {}

// States
abstract class SocialState extends Equatable {
  const SocialState();

  @override
  List<Object> get props => [];
}

class SocialInitial extends SocialState {}

class SocialLoading extends SocialState {}

class SocialLoaded extends SocialState {
  final List<PostModel> posts;
  final List<TrendingTopicModel> trendingTopics;
  final List<ModerationItemModel> moderationQueue;
  final UserProfileSummaryModel userProfileSummary;
  final List<String> suggestedUsers;

  const SocialLoaded({
    required this.posts,
    required this.trendingTopics,
    required this.moderationQueue,
    required this.userProfileSummary,
    required this.suggestedUsers,
  });

  @override
  List<Object> get props => [
        posts,
        trendingTopics,
        moderationQueue,
        userProfileSummary,
        suggestedUsers,
      ];
}

class SocialError extends SocialState {
  final String message;

  const SocialError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class SocialBloc extends Bloc<SocialEvent, SocialState> {
  final SocialRepository socialRepository;

  SocialBloc({required this.socialRepository}) : super(SocialInitial()) {
    on<LoadSocialData>(_onLoadSocialData);
    on<CreatePost>(_onCreatePost);
    on<LikePost>(_onLikePost);
    on<UnlikePost>(_onUnlikePost);
    on<AddComment>(_onAddComment);
    on<RepostPost>(_onRepostPost);
    on<ToggleLikePost>(_onToggleLikePost);
    on<ReportPost>(_onReportPost);
    on<ModerateContent>(_onModerateContent);
    on<LoadTrendingPosts>(_onLoadTrendingPosts);
  }

  Future<void> _onLoadSocialData(
    LoadSocialData event,
    Emitter<SocialState> emit,
  ) async {
    emit(SocialLoading());
    try {
      // Load actual data from repository
      final posts = await socialRepository.getSocialFeed();
      final trendingTopics = await socialRepository.getTrendingTopics();
      final moderationQueue = await socialRepository.getModerationQueue();
      final userProfileSummary = await socialRepository.getUserProfileSummary();
      final suggestedUsers = await socialRepository.getSuggestedUsers();
      
      emit(SocialLoaded(
        posts: posts,
        trendingTopics: trendingTopics,
        moderationQueue: moderationQueue,
        userProfileSummary: userProfileSummary,
        suggestedUsers: suggestedUsers,
      ));
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onCreatePost(
    CreatePost event,
    Emitter<SocialState> emit,
  ) async {
    try {
      await socialRepository.createPost(event.content);
      // Reload data after creating a post
      add(LoadSocialData());
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onLikePost(
    LikePost event,
    Emitter<SocialState> emit,
  ) async {
    try {
      await socialRepository.likePost(event.postId);
      // Reload data after liking a post
      add(LoadSocialData());
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onUnlikePost(
    UnlikePost event,
    Emitter<SocialState> emit,
  ) async {
    try {
      await socialRepository.unlikePost(event.postId);
      // Reload data after unliking a post
      add(LoadSocialData());
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onAddComment(
    AddComment event,
    Emitter<SocialState> emit,
  ) async {
    try {
      await socialRepository.addComment(event.postId, event.content);
      // Reload data after adding a comment
      add(LoadSocialData());
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onRepostPost(
    RepostPost event,
    Emitter<SocialState> emit,
  ) async {
    try {
      await socialRepository.repostPost(event.postId);
      // Reload data after reposting
      add(LoadSocialData());
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onToggleLikePost(
    ToggleLikePost event,
    Emitter<SocialState> emit,
  ) async {
    try {
      await socialRepository.toggleLikePost(event.postId);
      add(LoadSocialData());
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onReportPost(
    ReportPost event,
    Emitter<SocialState> emit,
  ) async {
    try {
      await socialRepository.reportPost(event.postId);
      add(LoadSocialData());
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onModerateContent(
    ModerateContent event,
    Emitter<SocialState> emit,
  ) async {
    try {
      await socialRepository.moderateContent(event.itemId, event.action);
      add(LoadSocialData());
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onLoadTrendingPosts(
    LoadTrendingPosts event,
    Emitter<SocialState> emit,
  ) async {
    emit(SocialLoading());
    try {
      // Load trending posts
      final posts = await socialRepository.getTrendingPosts();

      // For now, we'll just update the posts in the existing state
      // In a real implementation, you might want a separate state for trending posts
      if (state is SocialLoaded) {
        final currentState = state as SocialLoaded;
        emit(SocialLoaded(
          posts: posts,
          trendingTopics: currentState.trendingTopics,
          moderationQueue: currentState.moderationQueue,
          userProfileSummary: currentState.userProfileSummary,
          suggestedUsers: currentState.suggestedUsers,
        ));
      } else {
        // If we don't have a loaded state, load all data
        add(LoadSocialData());
      }
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }
}
