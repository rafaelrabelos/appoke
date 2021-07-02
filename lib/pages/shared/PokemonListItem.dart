import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poke_app/models/PokemonModel.dart';

class PokemonListItem extends StatefulWidget {
  PokemonListItem({Key key, this.pokemon, this.onTap}) : super(key: key);

  final PokemonModel pokemon;
  final void Function() onTap;

  @override
  _PokemonListItem createState() => _PokemonListItem(pokemon: pokemon, onTap: onTap);
}

class _PokemonListItem extends State<PokemonListItem> {
  _PokemonListItem({this.pokemon, this.onTap});

  @override
  void initState() {
    super.initState();
  }

  final PokemonModel pokemon;
  final void Function() onTap;
  PokemonModel selectedPokemon;

  @override
  Widget build(BuildContext context) {
    if (this.pokemon == null) {
      return _buildEmptyPokemon();
    }

    return _buildPokemon();
  }

  Widget _buildPokemon() {
    ListTile widget = ListTile(
      onTap: this.onTap,
      leading: CircleAvatar(
          backgroundColor: Colors.black12,
          radius: 26.0,
          backgroundImage: NetworkImage(
              "${pokemon.sprites.other.officialArtwork.frontDefault}")),
      title: Row(
        children: <Widget>[
          Text("${pokemon.name}"),
          SizedBox(width: 16.0),
          SizedBox(width: 16.0),
        ],
      ),
      subtitle: Row(
        children: [
          Text("id: ${pokemon.id} "),
        ],
      ),
      trailing: Icon(
        Icons.star,
        size: 14.0,
      ),
    );

    return widget;
  }

  Widget _buildEmptyPokemon() {
    return ListTile(
      title: Row(
        children: <Widget>[
          Text("Pokemon not found"),
        ],
      ),
    );
  }
}
