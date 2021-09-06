library emoji_keyboard;

import 'package:radauon/emojis/emoji_data.dart';
import 'package:radauon/emojis/emoji_model.dart';
import 'package:flutter/material.dart';

class EmojiKeyboard extends StatefulWidget {
  EmojiKeyboard({
    Key key,
    this.emojiFont,
    this.onEmojiPressed,
    this.height = 250,
  }) : super(key: key);

  /// The font for emoji keyboard to use, if not supplied default emojis are used
  final String emojiFont;

  /// The callback which is called when emoji is pressed
  final Function(Emoji) onEmojiPressed;

  /// Height of the keyboard (default is 250)
  final double height;

  @override
  _EmojiKeyboardState createState() => _EmojiKeyboardState();
}

class _EmojiKeyboardState extends State<EmojiKeyboard> {
  List<bool> _isTabSelected;
  List<List<Emoji>> _allEmojis;

  List<bool> _getInitialTabSelection() {
    return _allEmojis.asMap().entries.map((entry) {
      return entry.key == 0;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _allEmojis = [
      Emoji.emojiListFromJson(smileysAndPeople),
      Emoji.emojiListFromJson(animalsAndNature),
      Emoji.emojiListFromJson(foodAndDrinks),
      Emoji.emojiListFromJson(travelAndPlaces),
      Emoji.emojiListFromJson(activity),
      Emoji.emojiListFromJson(symbols),
      Emoji.emojiListFromJson(flags),
      Emoji.emojiListFromJson(objects),
    ];
    _isTabSelected = _getInitialTabSelection();
  }

  @override
  Widget build(BuildContext context) {
    final emojiGrids = _allEmojis
        .map(
          (e) => EmojiGrid(
            emojis: e,
            emojiFont: widget.emojiFont,
            onEmojiTap: widget.onEmojiPressed,
          ),
        )
        .toList();
    return Container(
      height: widget.height,
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.grey[100],
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ToggleButtons(
                  children: _allEmojis
                      .map(
                        (e) => Text(
                          e.first.emoji,
                          style: TextStyle(
                            fontFamily: widget.emojiFont,
                          ),
                        ),
                      )
                      .toList(),
                  renderBorder: false,
                  onPressed: (int index) {
                    final _isTabSelectedCopy = [..._isTabSelected];
                    for (int i = 0; i < _isTabSelectedCopy.length; i++) {
                      if (i == index) {
                        _isTabSelectedCopy[i] = true;
                      } else if (_isTabSelectedCopy[i]) {
                        _isTabSelectedCopy[i] = false;
                      }
                    }
                    setState(
                      () {
                        _isTabSelected = _isTabSelectedCopy;
                      },
                    );
                  },
                  isSelected: _isTabSelected,
                ),
              ],
            ),
          ),
          Expanded(
            child: emojiGrids[_isTabSelected.indexWhere((element) => element)],
          ),
        ],
      ),
    );
  }
}

class EmojiGrid extends StatelessWidget {
  const EmojiGrid(
      {Key key,
      @required this.emojis,
      this.emojiFont,
      @required this.onEmojiTap})
      : super(key: key);

  final List<Emoji> emojis;
  final String emojiFont;
  final Function(Emoji) onEmojiTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: emojis.length,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) => EmojiButton(
        emoji: emojis[index].emoji,
        emojiFont: emojiFont,
        onTap: () {
          onEmojiTap(emojis[index]);
        },
      ),
    );
  }
}

class EmojiButton extends StatelessWidget {
  const EmojiButton(
      {Key key, @required this.emoji, this.emojiFont, @required this.onTap})
      : super(key: key);

  final String emoji;
  final Function onTap;
  final String emojiFont;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.all(5),
      child: FlatButton(
        shape: CircleBorder(),
        padding: EdgeInsets.all(5),
        onPressed: onTap,
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: 25,
            fontFamily: emojiFont,
          ),
        ),
      ),
    );
  }
}
