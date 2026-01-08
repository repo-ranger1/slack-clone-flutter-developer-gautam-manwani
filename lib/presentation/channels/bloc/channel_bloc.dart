import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slack_clone_gautam_manwani/domain/repositories/channel_repository.dart';
import 'package:slack_clone_gautam_manwani/presentation/channels/bloc/channel_event.dart';
import 'package:slack_clone_gautam_manwani/presentation/channels/bloc/channel_state.dart';

/// Channel Bloc for managing channel list
class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final ChannelRepository _chanRepo;
  final Map<String, StreamSubscription<int>> _unreadSubs = {};

  ChannelBloc({required ChannelRepository channelRepository})
      : _chanRepo = channelRepository,
        super(const ChannelInitial()) {
    on<ChannelLoadRequested>(_onLoadRequested);
    on<ChannelSelected>(_onChannelSelected);
    on<ChannelUnreadUpdated>(_onUnreadUpdated);
    on<ChannelUnreadCountsSubscribed>(_onUnreadCountsSubscribed);
  }

  /// Handle load channels request
  Future<void> _onLoadRequested(
    ChannelLoadRequested event,
    Emitter<ChannelState> emit,
  ) async {
    emit(const ChannelLoading());

    try {
      final channels = await _chanRepo.getChannels(event.workspaceId);
      emit(ChannelLoaded(channels: channels));
    } catch (e) {
      emit(ChannelError(message: e.toString()));
    }
  }

  /// Handle channel selection
  void _onChannelSelected(
    ChannelSelected event,
    Emitter<ChannelState> emit,
  ) {
    if (state is ChannelLoaded) {
      final currentState = state as ChannelLoaded;

      // Update channels to mark the selected one as active
      final updatedChannels = currentState.channels.map((channel) {
        return channel.copyWith(
          isActive: channel.id == event.channelId,
          unreadCount: channel.id == event.channelId ? 0 : channel.unreadCount,
        );
      }).toList();

      emit(currentState.copyWith(
        channels: updatedChannels,
        selectedChannelId: event.channelId,
      ));
    }
  }

  /// Handle unread count update
  void _onUnreadUpdated(
    ChannelUnreadUpdated event,
    Emitter<ChannelState> emit,
  ) {
    if (state is ChannelLoaded) {
      final currentState = state as ChannelLoaded;

      // Update the unread count for the specific channel
      final updatedChannels = currentState.channels.map((channel) {
        if (channel.id == event.channelId) {
          return channel.copyWith(unreadCount: event.unreadCount);
        }
        return channel;
      }).toList();

      emit(currentState.copyWith(channels: updatedChannels));
    }
  }

  /// Handle subscribing to unread counts for all channels
  Future<void> _onUnreadCountsSubscribed(
    ChannelUnreadCountsSubscribed event,
    Emitter<ChannelState> emit,
  ) async {
    if (state is! ChannelLoaded) return;

    final currentState = state as ChannelLoaded;

    // Cancel existing subscriptions
    for (final subscription in _unreadSubs.values) {
      await subscription.cancel();
    }
    _unreadSubs.clear();

    // Subscribe to unread count changes for each channel
    for (final channel in currentState.channels) {
      final subscription = _chanRepo
          .getUnreadCountStream(event.workspaceId, channel.id, event.userId)
          .listen((unreadCount) {
        add(ChannelUnreadUpdated(
          channelId: channel.id,
          unreadCount: unreadCount,
        ));
      });

      _unreadSubs[channel.id] = subscription;
    }
  }

  @override
  Future<void> close() {
    // Cancel all unread count subscriptions
    for (final subscription in _unreadSubs.values) {
      subscription.cancel();
    }
    _unreadSubs.clear();
    return super.close();
  }
}
