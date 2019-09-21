import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import '../Chat/ChatBox.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ChatBox> messagesList = [];
  TextEditingController sendTextController = TextEditingController();

  Future<void> getMessageFromAPI(String message) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: 'assets/credential.json').build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(message);
    setState(() {
      messagesList.insert(
        0,
        ChatBox(
          message: aiResponse.getMessage(),
          type: false,
          context: context,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2c3e50),
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'DialogFlow Bot',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned.fill(
          child: Image(
            image: Image.asset('assets/images/light_blur_image.jpg').image,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messagesList.length,
                  itemBuilder: (context, i) {
                    return messagesList[i];
                  },
                ),
              ),
              buildTextArea(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextArea(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          CupertinoButton(
            onPressed: () {
              // Optional Button
            },
            pressedOpacity: 0.4,
            child: Icon(Icons.add, color: Colors.black),
          ),
          Expanded(
            child: TextField(
              controller: sendTextController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                contentPadding: const EdgeInsets.all(0),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          CupertinoButton(
            onPressed: () {
              if (sendTextController.text.trim().isNotEmpty) {
                setState(() {
                  messagesList.insert(
                    0,
                    ChatBox(
                      message: sendTextController.text,
                      type: true,
                      context: context,
                    ),
                  );
                });
                getMessageFromAPI(sendTextController.text);
                sendTextController.text = '';
              }
            },
            pressedOpacity: 0.4,
            child: Icon(Icons.send, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
