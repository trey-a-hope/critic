import 'package:critic/extensions/hex_color.dart';

class Globals {
  Globals._();

  /// Routes
  static const String ROUTES_CREATE_CRITIQUE = '/create_critique';
  static const String ROUTES_CONTACT = '/contact';
  static const String ROUTES_EDIT_PROFILE = '/edit_profile';
  static const String ROUTES_HOME = '/home';
  static const String ROUTES_LOGIN = '/login';
  static const String ROUTES_MOVIE_DETAILS = '/movie_details';
  static const String ROUTES_PROFILE = '/profile';
  static const String ROUTES_RECOMMENDATIONS = '/recommendations';
  static const String ROUTES_SEARCH_MOVIES = '/search_movies';
  static const String ROUTES_SEARCH_USERS = '/search_users';
  static const String ROUTES_SETTINGS = '/settings';
  static const String ROUTES_TERMS_OF_SERVICE = '/terms_of_service';
  static const String ROUTES_USERS_LIST = '/users_list';
  static const String ROUTES_WATCH_LIST = '/watch_list';

  /// Stream API
  static const String STREAM_API_KEY = 'cnm888r8mdrb';
  static const String STREAM_API_SECRET =
      '43qab2ekjwqdsyjsf8dqa3jwypvcb5buc3hw9zee5mawbgmqk8qw5d8d9dcgva7b';
  static const String STREAM_API_APP_ID = '96230';

  /// OMDB API
  static const String OMDB_API_KEY = '7c304592';
  static const String OMDB_API_URL = 'www.omdbapi.com';

  /// Dummy Variables
  static const String DUMMY_POSTER_IMG_URL =
      'https://www.gamespot.com/a/uploads/original/1562/15626911/3776884-image%285%29.png';
  static const String DUMMY_PROFILE_PHOTO_URL =
      'https://firebasestorage.googleapis.com/v0/b/critic-a9e44.appspot.com/o/Images%2FProfile.jpeg?alt=media&token=f8d67c2f-9b1c-4cbe-aca5-6da014c504a0';

  /// Algolia API
  static const String ALGOLIA_APP_ID = 'GGXI4MP1WJ';
  static const String ALGOLIA_SEARCH_API_KEY =
      '01be9bb46f445fa21cdba2c7197d84bf';

  /// Google Cloud
  static const String CLOUD_FUNCTIONS_ENDPOINT =
      'https://us-central1-critic-a9e44.cloudfunctions.net/';
  static const String CLOUD_MESSAGING_SERVER_KEY =
      'AAAANziSKLs:APA91bHYQGvOjarIPvbuEjSQpxwsQo-h4SMftTD9L-3dxX7ZAjC5KeDPG1Vf7EMf3tuh6LaGBwwHtJUOs9f4Qq5MPkLMdEWt8DCXj0fjmqBiXNjEIooaS3soehfDr3xQ_Hr8cbtN_soU';

  /// Colors
  static final HexColor colorNavy = HexColor('#09487e');
  static final HexColor colorGrey = HexColor('#25272A');

  /// Assets & Images
  static const String ASSET_LOGIN_BG = 'assets/images/login_bg.jpg';
  static const String ASSET_APP_ICON = 'assets/images/app_icon.png';
  static const String ASSET_APP_ICON_LIGHT = 'assets/images/app_icon_light.png';

  /// UID of Admin
  static const String TREY_HOPE_UID = 'OkiieQJ7LhbyQwrCEFtOOP9b3Pt2';

  /// Limits
  static const int CRITIQUE_CHAR_LIMIT = 225;
  static const int MONGODB_PAGE_FETCH_LIMIT = 10;
  static const int STREAM_PAGE_FETCH_LIMIT = 5;
  static const int USERS_PAGE_FETCH_LIMIT = 20;

  /// Email
  static const String EMAIL = 'thope@imabigcritic.com';

  /// Messages
  static const String MESSAGE_EMPTY_CRITIQUES = 'No critiques at the moment.';
  static const String MESSAGE_EMPTY_WATCHLIST = 'No movies in your watchlist.';
  static const String MESSAGE_EMPTY_COMMENTS = 'No comments at the moment.';
  static const String MESSAGE_EMPTY_USERS = 'No users at the moment.';

  /// Package info
  static const String APP_VERSION = 'app_version';
  static const String APP_BUILD_NUMBER = 'build_number';
}
