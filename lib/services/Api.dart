import 'package:poke_app/services/ApiResources.dart';
import 'package:http/http.dart' as http;

class Api extends ApiResources {
  final baseUrl;
  static const Map<String, String> headers = {
    'Authorization':
        'Basic cmFmYWVsZGVyYWJlbG9AZ21haWwuY29tOklNR2FzeDIxMjIqOTk1NkFTVw=='
  };

  Api({this.baseUrl});

  Future get(
      {String resource,
      Map<String, String> urlParams,
      Map<String, String> queryParams}) {
    var url = this.baseUrl + resource;

    if (queryParams != null) url = urlQueryParamsBuilder(url, queryParams);

    if (urlParams != null) url = urlParamsBuilder(url, urlParams);

    return http.get(url, headers: headers);
  }

  Future post(
      {String resource,
      Map<String, String> bodyParams,
      Map<String, String> urlParams}) {
    var url = this.baseUrl + resource;

    if (urlParams != null) url = urlParamsBuilder(url, urlParams);

    return http.post(url, headers: headers, body: bodyParams);
  }

  // TODO create method
  // IncludeHeanders(){}
  urlQueryParamsBuilder(String url, Map<String, String> queryParams) {
    return url + '?' + Uri(queryParameters: queryParams).query;
  }

  urlParamsBuilder(String url, Map<String, String> urlParams) {
    var newUrl = url;
    urlParams.forEach(
        (k, v) => newUrl = newUrl.replaceAll(k, v).replaceAll('{$v}', v));
    return newUrl;
  }
}
