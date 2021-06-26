class PokemonsListModel {
  final int count;
  final String next;
  final String previous;
  final List<PokemonsResults> results;

  PokemonsListModel({this.count, this.next, this.previous, this.results});

  factory PokemonsListModel.fromJson(Map<String, dynamic> json) {
    return PokemonsListModel(
      count: json['count'] ?? -1,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map( (i) => PokemonsResults
          .fromJson(i)).toList(),
    );
  }
}

class PokemonsResults {
  final String name;
  final String url;

  PokemonsResults({this.name, this.url});

  factory PokemonsResults.fromJson(Map<String, dynamic> json) {
    return PokemonsResults(
      name: json['name'],
      url: json['url'],
    );
  }
}