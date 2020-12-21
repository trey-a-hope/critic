part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

//Event: User selects login.
class LoadPage extends EditProfileEvent {
  LoadPage();

  List<Object> get props => [];
}

class Save extends EditProfileEvent {
  final String username;

  Save({
    @required this.username,
  });

  List<Object> get props => [
        username,
      ];
}
