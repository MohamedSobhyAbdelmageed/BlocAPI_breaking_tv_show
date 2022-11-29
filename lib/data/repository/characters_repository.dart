import 'package:breaking_bloc/data/models/quote.dart';
import 'package:breaking_bloc/data/web_services/characters_web_services.dart';
import '../models/character.dart';

class CharactersRepository {
  final CharactersWebServices charactersWebServices;

  CharactersRepository(this.charactersWebServices);

  Future<List<Character>> getAllCharacters() async {
    try {
      final characters = await charactersWebServices.getAllCharacters();
      return characters
          .map((character) => Character.fromJson(character))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Quote>> getCharacterQuotes(String charName) async {
    try {
      final quotes = await charactersWebServices.getCharacterQuotes(charName);
      return quotes.map((charQuotes) => Quote.fromJson(charQuotes)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
