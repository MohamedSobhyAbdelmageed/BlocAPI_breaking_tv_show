import 'package:breaking_bloc/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bloc/data/repository/characters_repository.dart';
import 'package:breaking_bloc/data/web_services/characters_web_services.dart';
import 'package:breaking_bloc/presentation/screens/characters_screen.dart';
import 'package:breaking_bloc/presentation/screens/character_details.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/strings.dart';
import 'data/models/character.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepository = CharactersRepository(CharactersWebServices());
    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => charactersCubit,
            child: CharacterScreen(),
          ),
        );

      case characterDetailsScreen:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (BuildContext context) =>
                      CharactersCubit(charactersRepository),
                  child: CharacterDetailsScreen(
                    character: character,
                  ),
                ));
    }
  }
}
