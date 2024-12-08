import 'package:flutter/material.dart';
import 'pokemon_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PokeAPI App',
      home: PokemonSearchPage(),
    );
  }
}

class PokemonSearchPage extends StatefulWidget {
  const PokemonSearchPage({super.key});

  @override
  _PokemonSearchPageState createState() => _PokemonSearchPageState();
}

class _PokemonSearchPageState extends State<PokemonSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final PokemonService _pokemonService = PokemonService();
  Map<String, dynamic>? _pokemonData;
  String? _errorMessage;

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String capitalizeTypes(String types) {
    return types.split(', ').map((type) => capitalize(type)).join(', ');
  }

  void _searchPokemon() async {
    setState(() {
      _errorMessage = null;
      _pokemonData = null;
    });

    try {
      final data =
          await _pokemonService.getPokemon(_controller.text.toLowerCase());
      setState(() {
        _pokemonData = data;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Pokémon not found!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokédex Search',
          style: TextStyle(fontSize: 28),
        ),
        backgroundColor: Colors.red[800],
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      backgroundColor: Colors.red[600],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 350,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Enter the Pokémon\'s name or ID',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    fillColor: Colors.black,
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchPokemon,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 32.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.black, fontSize: 22),
              ),
            const SizedBox(height: 20),
            if (_pokemonData != null) _buildPokemonCard(_pokemonData!),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonCard(Map<String, dynamic> data) {
    final name = data['name'];
    final id = data['id'];
    final height = data['height'];
    final weight = data['weight'];
    final types = (data['types'] as List)
        .map((typeInfo) => typeInfo['type']['name'])
        .join(', ');
    final imageUrl =
        data['sprites']['other']['official-artwork']['front_default'];

    return Center(
      child: SizedBox(
        width: 300,
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child:
                      Image.network(imageUrl, height: 280, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    '${name[0].toUpperCase()}${name.substring(1)} - (#$id)',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Types: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: capitalizeTypes(types),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Height: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: '${height / 10} m'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Weight: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: '${weight / 10} kg'),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
