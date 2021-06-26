class PokemonModel {
  final int id;
  final int height;
  final int weight;
  final int baseExperience;
  final String name;
  final PokemonSprites sprites;
  final List<PokemonStatsData> stats;

  PokemonModel({this.id, this.height, this.weight, this.baseExperience, this.name, this.sprites, this.stats});

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'] ?? -1,
      height: json['height'],
      weight: json['weight'],
      baseExperience: json['base_experience'],
      name: json['name'],
      sprites: PokemonSprites.fromJson(json['sprites']),
      stats: (json['stats'] as List)
            .map( (i) => PokemonStatsData
            .fromJson(i)).toList(),
    );
  }
}

class PokemonSprites {
  final String backDefault;
  final String frontDefault;
  final PokemonSpritesOther other;

  PokemonSprites({this.backDefault, this.frontDefault, this.other});

  factory PokemonSprites.fromJson(Map<String, dynamic> json) {
    return PokemonSprites(
      backDefault: json['back_default'],
      frontDefault: json['front_default'],
      other: PokemonSpritesOther.fromJson(json['other']),
    );
  }
}

class PokemonSpritesOther {
  final PokemonSpritesOtherData dreamWorld;
  final PokemonSpritesOtherData officialArtwork;

  PokemonSpritesOther({this.dreamWorld, this.officialArtwork});

  factory PokemonSpritesOther.fromJson(Map<String, dynamic> json) {
    return PokemonSpritesOther(
      dreamWorld: PokemonSpritesOtherData.fromJson(json['dream_world']),
      officialArtwork: PokemonSpritesOtherData.fromJson(json['official-artwork']),
    );
  }
}

class PokemonSpritesOtherData {
  final String frontDefault;
  final String frontFemale;

  PokemonSpritesOtherData({this.frontDefault, this.frontFemale});

  factory PokemonSpritesOtherData.fromJson(Map<String, dynamic> json) {
    return PokemonSpritesOtherData(
      frontDefault: json['front_default'],
      frontFemale: json['front_female'],
    );
  }
}

class PokemonStatsData {
  final int baseStat;
  final PokemonStatsStat stat;

  PokemonStatsData({this.baseStat, this.stat});

  factory PokemonStatsData.fromJson(Map<String, dynamic> json) {
    return PokemonStatsData(
      baseStat: json['base_stat'],
      stat: PokemonStatsStat.fromJson(json['stat']),
    );
  }
}

class PokemonStatsStat {
  final String statName;

  PokemonStatsStat({this.statName});

  factory PokemonStatsStat.fromJson(Map<String, dynamic> json) {
    return PokemonStatsStat(
      statName: json['name'],
    );
  }
}