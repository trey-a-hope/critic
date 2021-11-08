part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ProfileEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class UploadImageEvent extends ProfileEvent {
  final ImageSource imageSource;
  UploadImageEvent({required this.imageSource});

  List<Object> get props => [imageSource];
}
