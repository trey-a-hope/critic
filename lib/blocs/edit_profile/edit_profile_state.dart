part of 'edit_profile_bloc.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileLoaded extends EditProfileState {
  final UserModel currentUser;

  EditProfileLoaded({
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        currentUser,
      ];
}

class ErrorState extends EditProfileState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
