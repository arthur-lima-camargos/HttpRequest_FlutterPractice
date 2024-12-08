import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

  Future<Map<String, dynamic>> getPokemon(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl$query'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Pokémon data');
    }
  }
}
