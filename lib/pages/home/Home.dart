import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poke_app/models/PokemonModel.dart';
import 'package:poke_app/models/PokemonsListModel.dart';
import 'package:poke_app/services/PokemonsService.dart';
import 'package:poke_app/pages/shared/PokemonListItem.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    this._scrollController = ScrollController();
    this._scrollController.addListener(_scrollListener);
    this._getPokemons();

    super.initState();
  }

  ScrollController _scrollController;
  List<PokemonModel> pokemons;
  PokemonModel selectedPokemon;
  String fetchNextUrl;
  bool isFetching;

  void _scrollListener() {
    var scrollOffset = _scrollController.offset;
    var maxScrollPos = _scrollController.position.maxScrollExtent;
    var minScrollPos = _scrollController.position.minScrollExtent;
    var outOfRangePos = _scrollController.position.outOfRange;

    bool bottomReached = (scrollOffset >= maxScrollPos && !outOfRangePos);
    bool topReached = (scrollOffset <= minScrollPos && !outOfRangePos);

    if (bottomReached) {
      this._fetchMorePokemons();
    }
  }

  void _setFetchingStatus(bool status) {
    setState(() {
      this.isFetching = status;
    });
  }

  void _setPokemons(List<PokemonModel> pokemons) {
    setState(() {
      if (this.pokemons != null) {
        this.pokemons.addAll(pokemons);
      } else {
        this.pokemons = pokemons;
        this.selectedPokemon = this.pokemons.first;
      }
    });
  }

  void _setSelectedPokemon(pokemon) {
    setState(() {
      this.selectedPokemon = pokemon;
    });
  }

  void _setNextFetchUrl(String url) {
    setState(() {
      this.fetchNextUrl = url;
    });
  }

  void _fetchMorePokemons() {
    if (this.fetchNextUrl != null)
      this._getPokemons();
    else {
      final snackBar = _buildSnackBar(message: "No more pokemons to show!");
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _getPokemons() async {
    try {
      List<PokemonModel> pokemons;
      PokemonsListModel pokemonsList;
      Map<String, String> queryParams = {"offset": "0", "limit": "20"};

      this._setFetchingStatus(true);

      if (this.fetchNextUrl != null) {
        List<String> queryString = this.fetchNextUrl.split('?');
        List<String> params =
            queryString.length > 1 ? queryString[1].split('&') : null;

        if (params.length > 1) {
          params.forEach((param) {
            var pairs = param.split('=');

            queryParams[pairs[0]] = pairs[1].toString();
          });
        }
      }

      pokemonsList =
          await PokemonService().getPokemonsList(queryParams: queryParams);

      if (pokemonsList != null) {
        List<Future<PokemonModel>> futures = pokemonsList.results
            .map((item) {
              var id = item.url.split('/');
              return PokemonService().getPokemon(int.parse(id[id.length - 2]));
            })
            .cast<Future<PokemonModel>>()
            .toList();

        pokemons = await Future.wait(futures);
      }

      this._setFetchingStatus(false);
      this._setPokemons(pokemons);
      this._setNextFetchUrl(pokemonsList.next);
    } catch (e) {
      this._setPokemons(null);
      this._setFetchingStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              this._buildTopInfo(context),
              SizedBox(
                width: double.infinity,
                height: deviceHeight / 2,
                child: Center(
                  child: ListView(
                    controller: this._scrollController, shrinkWrap: true,
                    //padding: EdgeInsets.all(15.0),
                    children: <Widget>[this._buildPokemons()],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Opacity(
        opacity: this.pokemons == null ? 1 : 0.3,
        child: FloatingActionButton(
          mini: true,
          onPressed: _getPokemons,
          tooltip: 'Refresh',
          child: Icon(Icons.refresh),
          backgroundColor: Colors.lightGreen[200],
        ),
      ),
    );
  }

  Widget _buildSnackBar({String message}) {
    return SnackBar(
      content: Text(message ?? ''),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );
  }

  Widget _buildPokemons() {
    List<PokemonListItem> widgets;
    String message = this.isFetching ? "Loading..." : "No pokemons";

    if (this.pokemons != null) {
      widgets = this
          .pokemons
          .map((item) => PokemonListItem(
                pokemon: item,
                onTap: () {
                  this._setSelectedPokemon(item);
                },
              ))
          .toList();
    }

    return Column(children: widgets ?? [Text(message)]);
  }

  Widget _buildTopInfo(BuildContext context) {
    final activePokemon = this.selectedPokemon;
    final pokemonIsValid = activePokemon != null;

    final name = pokemonIsValid ? activePokemon.name : "";
    final id = pokemonIsValid ? activePokemon.id : "";
    final weight = pokemonIsValid ? activePokemon.weight : "";
    final height = pokemonIsValid ? activePokemon.height : "";
    final baseExperience = pokemonIsValid ? activePokemon.baseExperience : "";
    final frontDefault = pokemonIsValid
        ? activePokemon.sprites.other.officialArtwork.frontDefault
        : "";

    final List<PokemonStatsData> stats =
        pokemonIsValid ? activePokemon.stats : null;

    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Column(children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.black12,
          radius: 80.0,
          backgroundImage: NetworkImage("$frontDefault"),
        ),
        SizedBox(
          width: double.infinity, // match_parent
          height: 125,
          child: Card(
              shadowColor: Color(0xFF0076FF),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  SizedBox(
                    child: Column(
                      children: [
                        Text("Id: ${id}"),
                        Text("Name: ${name}"),
                        Text("weight: ${weight}"),
                        Text("height: ${height}"),
                        Text("baseExp: ${baseExperience}"),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    child: Column(
                        children: stats != null
                            ? stats
                                .map((item) => new Text(
                                    "${item.stat.statName}: ${item.baseStat}"))
                                .toList()
                            : [new Text("")]),
                  ),
                ],
              )),
        ),
      ]),
    );
  }
}
