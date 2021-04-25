import 'package:critic/Constants.dart';
import 'package:critic/models/movie_model.dart';
import 'package:critic/models/recommendation_model.dart';
import 'package:critic/models/user_Model.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/movie_service.dart';
import 'package:critic/services/recommendations_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:critic/widgets/recommendation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/foundation.dart';

part 'recommendations_event.dart';
part 'recommendations_state.dart';
part 'recommendations_page.dart';

abstract class RecommendationsBlocDelegate {
  void showMessage({@required String message});
}

class RecommendationsBloc
    extends Bloc<RecommendationsEvent, RecommendationsState> {
  RecommendationsBloc() : super(null);
  RecommendationsBlocDelegate _recommendationsBlocDelegate;
  UserModel currentUser;

  DocumentSnapshot startAfterDocument;

  void setDelegate({@required RecommendationsBlocDelegate delegate}) {
    this._recommendationsBlocDelegate = delegate;
  }

  @override
  Stream<RecommendationsState> mapEventToState(
      RecommendationsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        currentUser = await locator<AuthService>().getCurrentUser();

        Stream<QuerySnapshot> recommendationsStream =
            await locator<RecommendationsService>()
                .streamRecommendations(uid: currentUser.uid);

        recommendationsStream.listen(
          (QuerySnapshot event) {
            List<RecommendationModel> recommendations = event.docs
                .map((doc) => RecommendationModel.fromDoc(ds: doc))
                .toList();

            add(
              RecommendationsUpdatedEvent(recommendations: recommendations),
            );
          },
        );
      } catch (error) {
        _recommendationsBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }

    if (event is RecommendationsUpdatedEvent) {
      final List<RecommendationModel> recommendations = event.recommendations;

      for (int i = 0; i < recommendations.length; i++) {
        RecommendationModel recommendation = recommendations[i];

        recommendation.movie = await locator<MovieService>()
            .getMovieByID(id: recommendation.imdbID);

        recommendation.sender = await locator<UserService>()
            .retrieveUser(uid: recommendation.senderUID);
      }

      if (recommendations.isEmpty) {
        yield EmptyRecommendationsState();
      } else {
        recommendations.sort(
          (a, b) => b.created.compareTo(a.created),
        );
        yield LoadedState(recommendations: recommendations);
      }
    }

    if (event is DeleteRecommendationEvent) {
      final String recommendationID = event.recommendationID;
      await locator<RecommendationsService>().deleteRecommendation(
          sendeeUID: currentUser.uid, recommendationID: recommendationID);
    }
  }
}
