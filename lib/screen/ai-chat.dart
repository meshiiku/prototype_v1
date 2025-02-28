import "package:flutter/material.dart";
import "package:prototype_v1/constants/backend-client.dart";

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  _AiChatScreenState createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  String sessionId = "";
  List<String> aiChats = [];

  @override
  void initState() {
    backendAPIClient.createChatSession().then(
      (sessionId) => setState(() {
        debugPrint(sessionId);
        this.sessionId = sessionId;
      }),
    );
    super.initState();
  }

  Widget buildMessageBar() {
    return Stack(
      children: [
        Positioned(
          right: 1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Material(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Theme.of(context).primaryColor,
              child: InkWell(
                onTap: () {},

                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    width: 50,
                    // ボタンの幅
                    height: 50,
                    // ボタンの高さ
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.send,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            top: 10,
            bottom: 10,
            right: 70,
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withAlpha(0x50),
                  blurRadius: 9,
                ),
              ],
            ),
            child: TextField(
              onSubmitted:
                  (v) async => {
                    backendAPIClient
                        .sendChat(sessionId, v)
                        .then(
                          (aiResponse) => {
                            setState(() {
                              aiChats.add(aiResponse);
                            }),
                          },
                        ),
                  },
              decoration: InputDecoration(
                filled: true,
                hintText: "送信する",
                fillColor: Theme.of(context).appBarTheme.backgroundColor,
                prefixIcon: const Icon(Icons.message),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AIの提案"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemBuilder:
                (context, index) => Padding(
                  padding: EdgeInsets.only(
                    right: 100,
                    left: 10,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(aiChats[index]),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
            itemCount: aiChats.length,
          ),
          // 入力欄
          Align(alignment: Alignment.bottomCenter, child: buildMessageBar()),
        ],
      ),
    );
  }
}
