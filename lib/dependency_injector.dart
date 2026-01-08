import 'package:slack_clone_gautam_manwani/core/utils/app_injector.dart';
import 'package:slack_clone_gautam_manwani/core/utils/storage/app_storage.dart';
import 'package:slack_clone_gautam_manwani/core/utils/storage/app_session.dart';
import 'package:slack_clone_gautam_manwani/data/datasources/auth_datasource.dart';
import 'package:slack_clone_gautam_manwani/data/datasources/channel_datasource.dart';
import 'package:slack_clone_gautam_manwani/data/datasources/message_datasource.dart';
import 'package:slack_clone_gautam_manwani/data/repositories/auth_repository_impl.dart';
import 'package:slack_clone_gautam_manwani/data/repositories/channel_repository_impl.dart';
import 'package:slack_clone_gautam_manwani/data/repositories/message_repository_impl.dart';
import 'package:slack_clone_gautam_manwani/domain/repositories/auth_repository.dart';
import 'package:slack_clone_gautam_manwani/domain/repositories/channel_repository.dart';
import 'package:slack_clone_gautam_manwani/domain/repositories/message_repository.dart';

/// Dependency injection setup
class DependencyInjector {
  const DependencyInjector._();

  /// Initialize and register all dependencies
  static void inject() {
    // Storage
    AppInjector.singleton<AppStorage>(AppStorage());
    AppInjector.singleton<AppSession>(AppSession());

    // Data sources
    AppInjector.lazy<AuthDataSource>(() => AuthDataSource());
    AppInjector.lazy<ChannelDataSource>(() => ChannelDataSource());
    AppInjector.lazy<MessageDataSource>(() => MessageDataSource());

    // Repositories
    AppInjector.lazy<AuthRepository>(
      () => AuthRepositoryImpl(
        dataSource: AppInjector.get<AuthDataSource>(),
      ),
    );

    AppInjector.lazy<ChannelRepository>(
      () => ChannelRepositoryImpl(
        dataSource: AppInjector.get<ChannelDataSource>(),
      ),
    );

    AppInjector.lazy<MessageRepository>(
      () => MessageRepositoryImpl(
        dataSource: AppInjector.get<MessageDataSource>(),
      ),
    );
  }
}
