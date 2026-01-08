import 'package:equatable/equatable.dart';
import 'package:slack_clone_gautam_manwani/domain/entities/channel_entity.dart';

/// Base channel state
abstract class ChannelState extends Equatable {
  const ChannelState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ChannelInitial extends ChannelState {
  const ChannelInitial();
}

/// Loading state
class ChannelLoading extends ChannelState {
  const ChannelLoading();
}

/// Loaded state
class ChannelLoaded extends ChannelState {
  final List<ChannelEntity> channels;
  final String? selectedChannelId;

  const ChannelLoaded({
    required this.channels,
    this.selectedChannelId,
  });

  /// Create a copy with updated fields
  ChannelLoaded copyWith({
    List<ChannelEntity>? channels,
    String? selectedChannelId,
  }) {
    return ChannelLoaded(
      channels: channels ?? this.channels,
      selectedChannelId: selectedChannelId ?? this.selectedChannelId,
    );
  }

  @override
  List<Object?> get props => [channels, selectedChannelId];
}

/// Error state
class ChannelError extends ChannelState {
  final String message;

  const ChannelError({required this.message});

  @override
  List<Object?> get props => [message];
}
