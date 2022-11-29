import 'package:breaking_bloc/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bloc/constants/my_colors.dart';
import 'package:breaking_bloc/data/models/character.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/character_item.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  late List<Character> allCharacters;
  late List<Character> searchForCharacters;
  bool _isSearchOn = false;
  final _searchTextController = TextEditingController();

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: MyColors.myGrey,
      decoration: InputDecoration(
        hintText: 'Find a character',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: MyColors.myGrey,
          fontSize: 18.0,
        ),
      ),
      style: TextStyle(
        color: MyColors.myGrey,
        fontSize: 18.0,
      ),
      onChanged: (searchedCharacter) {
        addSearchedForItemsToSearch(searchedCharacter);
      },
    );
  }

  void addSearchedForItemsToSearch(String searchValue) {
    searchForCharacters = allCharacters
        .where(
            (character) => character.name.toLowerCase().startsWith(searchValue))
        .toList();
    setState(() {
      _isSearchOn = true;
    });
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearchOn) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: MyColors.myGrey,
          ),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: Icon(
            Icons.search,
            color: MyColors.myGrey,
          ),
        ),
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearchOn = true;
    });
  }

  void _stopSearching() {
    _clearSearch();
    setState(() {
      _isSearchOn = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is CharactersLoaded) {
          allCharacters = (state).characters;
          return buildLoadedListWidget();
        } else {
          return showLoadingIndicator();
        }
      },
    );
  }

  Widget _buildAppBarTitle() {
    return Text(
      'Characters',
      style: TextStyle(color: MyColors.myWhite),
    );
  }

  Widget buildLoadedListWidget() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(children: [
          buildCharacterList(),
        ]),
      ),
    );
  }

  Widget buildCharacterList() {
    return GridView.builder(
      // ignore: prefer_const_constructors
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _searchTextController.text.isEmpty
          ? allCharacters.length
          : searchForCharacters.length,
      itemBuilder: (ctx, index) {
        return CharacterItem(
          character: _searchTextController.text.isEmpty
              ? allCharacters[index]
              : searchForCharacters[index],
        );
      },
    );
  }

  Widget showLoadingIndicator() {
    // ignore: prefer_const_constructors
    return Center(
      // ignore: prefer_const_constructors
      child: CircularProgressIndicator(color: MyColors.myYellow),
    );
  }

  Widget _checkSearchListEmpty() {
    if (!_searchTextController.text.isEmpty &&
        searchForCharacters.length == 0) {
      return Center(
        child: Text(
          'No Characters found',
          style: TextStyle(
            color: MyColors.myGrey,
            fontSize: 18.0,
          ),
        ),
      );
    } else {
      return buildBlocWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: _isSearchOn ? _buildSearchField() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
        leading: _isSearchOn
            ? BackButton(
                color: MyColors.myGrey,
              )
            : Container(),
      ),
      body: _checkSearchListEmpty(),
    );
  }
}
