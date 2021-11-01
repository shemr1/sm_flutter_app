import 'package:algolia/algolia.dart';

class AlgoliaApplication{
  static final Algolia algolia = Algolia.init(
    applicationId: 'VH9WYM6W1F', //ApplicationID
    apiKey: '7a39e5602e5a80c07f44b9ee9fd4b98a', //search-only api key in flutter code
  );
}