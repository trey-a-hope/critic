import 'package:critic/extensions/hex_color.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'models/ui/genre_model.dart';

const String DUMMY_POSTER_IMG_URL =
    'https://payload.cargocollective.com/1/23/758880/13104445/NO-MOVIE-POSTERS-02-03-03_2000_c.png';
const String DUMMY_PROFILE_PHOTO_URL =
    'https://firebasestorage.googleapis.com/v0/b/critic-a9e44.appspot.com/o/Images%2FProfile.jpeg?alt=media&token=f8d67c2f-9b1c-4cbe-aca5-6da014c504a0';

//These are set in main().
String? version;
String? buildNumber;
double? screenWidth;
double? screenHeight;

const String ALGOLIA_APP_ID = 'GGXI4MP1WJ';
const String ALGOLIA_SEARCH_API_KEY = '01be9bb46f445fa21cdba2c7197d84bf';

const String CLOUD_FUNCTIONS_ENDPOINT =
    'https://us-central1-critic-a9e44.cloudfunctions.net/';

final HexColor colorNavy = HexColor('#09487e');
final HexColor colorGrey = HexColor('#25272A');

const String ASSET_LOGIN_BG = 'assets/images/login_bg.jpg';
const String ASSET_APP_ICON = 'assets/images/app_icon.png';
const String ASSET_APP_ICON_LIGHT = 'assets/images/app_icon_light.png';

const String TREY_HOPE_UID = 'OkiieQJ7LhbyQwrCEFtOOP9b3Pt2';

const int CRITIQUE_CHAR_LIMIT = 225;

const int PAGE_FETCH_LIMIT = 10;

const String EMAIL = 'thope@imabigcritic.com';

const String MESSAGE_EMPTY_CRITIQUES = 'No critiques at this moment.';
const String MESSAGE_EMPTY_WATCHLIST = 'No movies in your watchlist.';
const String MESSAGE_EMPTY_COMMENTS = 'No comments at this moment.';

//Hive Boxes Names
const String HIVE_BOX_LOGIN_CREDENTIALS = 'HIVE_BOX_LOGIN_CREDENTIALS';

List<GenreModel> genres = [
  GenreModel(title: 'Action', iconData: MdiIcons.run),
  GenreModel(title: 'Adventure', iconData: MdiIcons.globeModel),
  GenreModel(title: 'Animation', iconData: MdiIcons.drawing),
  GenreModel(title: 'Biography', iconData: MdiIcons.accountDetails),
  GenreModel(title: 'Comedy', iconData: MdiIcons.emoticon),
  GenreModel(title: 'Crime', iconData: MdiIcons.pistol),
  GenreModel(title: 'Documentary', iconData: MdiIcons.televisionClassic),
  GenreModel(title: 'Drama', iconData: MdiIcons.emoticonCry),
  GenreModel(title: 'Family', iconData: MdiIcons.motherNurse),
  GenreModel(title: 'Fantasy', iconData: MdiIcons.unicorn),
  GenreModel(title: 'Film-Noir', iconData: MdiIcons.hail),
  GenreModel(title: 'History', iconData: MdiIcons.bookOpenPageVariant),
  GenreModel(title: 'Horror', iconData: MdiIcons.emoticonDevil),
  GenreModel(title: 'Music', iconData: MdiIcons.music),
  GenreModel(title: 'Musical', iconData: MdiIcons.danceBallroom),
  GenreModel(title: 'Mystery', iconData: MdiIcons.headQuestion),
  GenreModel(title: 'N/A', iconData: MdiIcons.setNone),
  GenreModel(title: 'Reality-TV', iconData: MdiIcons.televisionBox),
  GenreModel(title: 'Romance', iconData: MdiIcons.heart),
  GenreModel(title: 'Sci-Fi', iconData: MdiIcons.alien),
  GenreModel(title: 'Short', iconData: MdiIcons.sizeS),
  GenreModel(title: 'Sport', iconData: MdiIcons.basketball),
  GenreModel(title: 'Talk-Show', iconData: MdiIcons.microphone),
  GenreModel(title: 'Thriller', iconData: MdiIcons.halloween),
  GenreModel(title: 'War', iconData: MdiIcons.medal),
  GenreModel(title: 'Western', iconData: MdiIcons.accountCowboyHat)
];
