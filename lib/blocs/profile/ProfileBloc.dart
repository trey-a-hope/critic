import 'package:bloc/bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/FollowerService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(null);

  UserModel _currentUser;

  List<String> _followersIDs;

  List<String> _followingsIDs;

  List<CritiqueModel> _critiques;

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        _critiques = await locator<CritiqueService>()
            .retrieveCritiquesForUser(userID: _currentUser.uid);

        _critiques.sort((a, b) =>
            b.created.millisecondsSinceEpoch -
            a.created.millisecondsSinceEpoch);

        _critiques.removeWhere((critique) => critique.safe == false);

        _followersIDs = await locator<FollowerService>()
            .getFollowersIDS(userID: _currentUser.uid);

        _followingsIDs = await locator<FollowerService>()
            .getFollowingsIDS(userID: _currentUser.uid);

        yield LoadedState(
          currentUser: _currentUser,
          followers: _followersIDs,
          followings: _followingsIDs,
          critiques: _critiques,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
