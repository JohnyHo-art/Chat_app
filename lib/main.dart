import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(
    const FriendlyChatApp(),
  );
}

//The kIOSTheme ThemeData object specifies colors for iOS (light grey with orange accents).
final ThemeData kIOSTheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);
//The kDefaultTheme ThemeData object specifies colors for Android (purple with orange accents).
final ThemeData KDefaultTheme = ThemeData(
    primarySwatch: Colors.purple, accentColor: Colors.orangeAccent[400]);

String _name = 'Ho Thinh';

class FriendlyChatApp extends StatelessWidget {
  const FriendlyChatApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FriendlyChat',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : KDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {required this.text, required this.animationController, Key? key})
      : super(key: key);
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.bounceIn),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          //Place children with their start edge aligned with the start side of
          //cross axis
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                //This container is used to contain the cỉcle avatar
                margin: const EdgeInsets.only(right: 16.0),
                //Get the first character of the name letter to set the symbol
                child: CircleAvatar(child: Text(_name[0] + _name[3]))),

            //The Expanded widget allows its child widget (like Column)
            //to impose layout constraints (in this case the Column's width)
            //on a child widget. Here, it constrains the width of the Text widget,
            //which is normally determined by its contents.
            Expanded(
              child: Column(
                //This colum is used to contain 2 text field, 1 for name, another for content
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: Theme.of(context).textTheme.headline6),
                  Container(
                      child: Text(text), margin: EdgeInsets.only(top: 5.0))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChatScreen>
    with TickerProviderStateMixin {
  //Create a text controller for an ediatble textfield
  final _textController = TextEditingController();
  //add a new messages list
  final List<ChatMessage> _messages = [];
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friendly Chat'),
        //The elevation property defines the z-coordinates of the AppBar.
        //A z-coordinate value of 4.0 has a defined shadow (Android),
        //and a value of 0.0 has no shadow (iOS).
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      reverse: true,
                      //The "_" in the code below stands for "context"
                      itemBuilder: (_, int index) => _messages[index],
                      itemCount: _messages.length)),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              )
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200]!)))
              : null),
    );
  }

  //"Xây dụng trình soạn thảo văn bản" in Vietnamese
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        //Set margin for the container
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        child: Row(
          children: [
            //This force the child widget to expand to fill the space
            //? If this work will I be able to set the maxline for it
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                //if _isComposing = true than run the _handleSubmitted function
                //else set property to null
                onSubmitted: _isComposing ? _handelSubmitted : null,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
                focusNode: _focusNode,
              ),
            ),
            //? If the user types a string in the text field, then _isComposing is true,
            //? and the button's color is set to Theme.of(context).accentColor.
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text('Send'),
                        onPressed: _isComposing
                            ? () => _handelSubmitted(_textController.text)
                            : null,
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handelSubmitted(_textController.text)
                            : null)),
          ],
        ),
      ),
    );

    // ignore: dead_code
    @override
    // ignore: unused_element
    void dispose() {
      for (var message in _messages) {
        message.animationController.dispose();
      }
      super.dispose();
    }
  }

  void _handelSubmitted(String text) {
    _textController.clear();
    //set _isComposing to false when the text field is cleared
    setState(() {
      _isComposing = false;
    });
    var message = ChatMessage(
      text: text,
      //add animation here
      animationController: AnimationController(
          duration: const Duration(milliseconds: 500), vsync: this),
    );
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }
}
