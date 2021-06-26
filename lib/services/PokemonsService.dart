import "dart:convert" as convert;
import 'package:poke_app/services/ApiResources.dart';
import 'package:poke_app/services/Api.dart';
import 'package:poke_app/models/PokemonsListModel.dart';
import 'package:poke_app/models/PokemonModel.dart';

class PokemonService {
  final api = new Api(baseUrl: ApiResources.pokeApiBaseUrl);
  static const Map<String, String> userResources = {
    '/pokemons': '/v2/pokemon/',
    '/pokemon': '/v2/pokemon/{id}',
  };

  PokemonService();

  Future<PokemonsListModel> getPokemonsList({Map<String, String> queryParams}) async {
    var res = await api.get(resource: userResources["/pokemons"], queryParams: queryParams);
    var statusCode = res.statusCode;
    var resJson = statusCode == 200 ? convert.jsonDecode(res.body) : null;

    return statusCode == 200 ? PokemonsListModel.fromJson(resJson) : null;
  }

  Future<PokemonModel> getPokemon(int id) async {
    var res = await api
        .get(resource: userResources["/pokemon"], urlParams: {'id': '$id'});
    var statusCode = res.statusCode;
    var resJson = statusCode == 200 ? convert.jsonDecode(res.body) : null;

    return res.statusCode == 200
        ? PokemonModel.fromJson(resJson)
        : null;
  }
}
