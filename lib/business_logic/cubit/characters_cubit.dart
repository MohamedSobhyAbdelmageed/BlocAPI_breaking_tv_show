import 'package:bloc/bloc.dart';
import 'package:breaking_bloc/data/models/character.dart';
import 'package:breaking_bloc/data/models/quote.dart';
import 'package:breaking_bloc/data/repository/characters_repository.dart';
import 'package:meta/meta.dart';
part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  List<Character> characters = [];

  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  List<Character> getAllCharacters() {
    charactersRepository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    });
    return characters;
  }

  void getCharacterQuote(String charName) {
    charactersRepository.getCharacterQuotes(charName).then((quotes) {
      emit(CharacterQuotesLoaded(quotes));
    });
  }
}
