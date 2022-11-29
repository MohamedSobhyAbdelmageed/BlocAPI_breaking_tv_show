import 'dart:math';
import 'package:breaking_bloc/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bloc/constants/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/character.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({required this.character});

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        // centerTitle: true,
        title: Text(
          character.nickName,
          style: TextStyle(
            color: MyColors.myWhite,
            fontSize: 16,
          ),
          // textAlign: TextAlign.start,
        ),
        background: Hero(
          tag: character.charId,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      text: TextSpan(children: [
        TextSpan(
          text: title,
          style: TextStyle(
            color: MyColors.myWhite,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: value,
          style: TextStyle(
            fontSize: 16,
            color: MyColors.myWhite,
          ),
        ),
      ]),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      color: MyColors.myYellow,
      height: 30,
      endIndent: endIndent,
      thickness: 2,
    );
  }

  Widget checkIfQuotesLoaded(CharactersState state) {
    if (state is CharacterQuotesLoaded) {
      return displayRandomQuoteOrEmpty(state);
    } else {
      return showProgressIndicator();
    }
  }

  Widget showProgressIndicator() {
    // ignore: prefer_const_constructors
    return Center(
      // ignore: prefer_const_constructors
      child: CircularProgressIndicator(color: MyColors.myYellow),
    );
  }

  Widget displayRandomQuoteOrEmpty(state) {
    var quotes = (state).quotes;
    if (quotes.length != 0) {
      int randomInt = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
          style: const TextStyle(
            color: MyColors.myWhite,
            fontSize: 25.0,
            fontFamily: 'Bobbers',
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(quotes[randomInt].quote),
            ],
            onTap: () {
              print("Quote tapped");
            },
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildSliverList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                characterInfo('Job :', character.jobs.join(' / ')),
                buildDivider(315),
                characterInfo('Appeared IN :', character.categoryForTwoSeries),
                buildDivider(235),
                characterInfo(
                    'Seasons :', character.appearanceOfSeasons.join(' / ')),
                buildDivider(270),
                character.betterCallSaulAppearance.isEmpty
                    ? Container()
                    : characterInfo('Better CallSaul :',
                        character.betterCallSaulAppearance.join(' / ')),
                character.betterCallSaulAppearance.isEmpty
                    ? Container()
                    : buildDivider(212),
                characterInfo('Actor/Actress :', character.actorName),
                buildDivider(222),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<CharactersCubit, CharactersState>(
                  builder: (context, state) {
                    return checkIfQuotesLoaded(state);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 450,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getCharacterQuote(character.name);
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          buildSliverList(),
        ],
      ),
    );
  }
}
