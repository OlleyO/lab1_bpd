import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pointycastle/api.dart' as crypto;
import "package:pointycastle/export.dart" as pointy_export;
import 'package:rsa_encrypt/rsa_encrypt.dart';

import '../constants/app_styles.dart';

class Lab4Screen extends StatefulWidget {
  static const path = "lab4";

  const Lab4Screen({Key? key}) : super(key: key);

  @override
  State<Lab4Screen> createState() => _Lab4ScreenState();
}

class _Lab4ScreenState extends State<Lab4Screen> {
  static const String _keysFolderPath = 'keys';
  static const String _publicKeyFileName = 'public.txt';
  static const String _privateKeyFileName = 'private.txt';

//Future to hold our KeyPair
  Future<crypto.AsymmetricKeyPair>? _futureKeyPair;

//to store the KeyPair once we get data from our future
  crypto.AsymmetricKeyPair? _keyPair;

  Duration _generationTime = Duration.zero;

  bool _isLoading = false;

  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = <Message>[];

  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      getKeyPair() {
    var helper = RsaKeyHelper();
    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _generateKeys() async {
    // _futureKeyPair =  getKeyPair();

    setState(() {
      _isLoading = true;
    });

    final before = DateTime.now();
    final keyPair = await getKeyPair();
    final after = DateTime.now();

    setState(() {
      _isLoading = false;
      _generationTime = after.difference(before);
      _keyPair = keyPair;
    });

    final publicKey = getPublicKeyString(keyPair);
    final privateKey = getPrivateKeyString(keyPair);

    log(publicKey);
    log(privateKey);

    storeKeysInFiles(privateKey: privateKey, publicKey: publicKey);
  }

  Future<void> storeKeysInFiles({
    required String privateKey,
    required String publicKey,
  }) async {
    final path = '${Directory.current.path}\\data';

    final newDirectory = Directory('$path\\$_keysFolderPath');

    await newDirectory.create(recursive: true);

    final privateKeyFile =
        File('$path\\$_keysFolderPath\\$_privateKeyFileName');
    final publicKeyFile = File('$path\\$_keysFolderPath\\$_publicKeyFileName');

    privateKeyFile.writeAsString(privateKey, mode: FileMode.write);
    publicKeyFile.writeAsString(publicKey);
  }

  @override
  Widget build(BuildContext context) {
    final keyPair = _keyPair;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _generateKeys();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.greenAccent,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Keys have been generated",
                    style: AppStyles.titleText,
                  ),
                  Text('Time elapsed: ${_generationTime.inMilliseconds} msec'),
                ],
              ),
            ),
          );
        },
        tooltip: 'Generate keys',
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.https),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      appBar: AppBar(
        title: const Text("Лабораторна 4"),
        leading: IconButton(
          onPressed: () async {
            if (_messages.length == 0) {
              return;
            }

            final path = '${Directory.current.path}\\data\\messages';
            final dir = Directory(path);

            await dir.create(recursive: true);

            final file = File('$path\\messages.txt');

            file.writeAsString("");

            final separator = '---------------------------------------------\n';
            for (final message in _messages) {
              file.writeAsStringSync(separator, mode: FileMode.append);
              file.writeAsStringSync('Message:\n', mode: FileMode.append);
              file.writeAsStringSync('${message.message}\n',
                  mode: FileMode.append);
              file.writeAsStringSync('Encoded:\n', mode: FileMode.append);
              file.writeAsStringSync('${message.encryptedMessage}',
                  mode: FileMode.append);
              file.writeAsStringSync(separator, mode: FileMode.append);
            }
          },
          icon: Icon(Icons.download_rounded),
        ),
      ),
      bottomNavigationBar: keyPair == null
          ? null
          : Container(
              color: Colors.blueAccent,
              child: Focus(
                focusNode: _focusNode,
                child: TextField(
                  onSubmitted: (_) {
                    setState(() {
                      _messages
                          .add(Message(keyPair, message: _textController.text));
                    });

                    _textController.clear();

                    // _focusNode.requestFocus();
                  },

                  // maxLines: null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(0).copyWith(left: 5),
                    suffix: TextButton(
                      onPressed: () {
                        setState(() {
                          _messages.add(
                              Message(keyPair, message: _textController.text));
                        });

                        _textController.clear();
                      },
                      child: const Text(
                        'Send',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  controller: _textController,
                ),
              ),
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView.separated(
            reverse: true,
            itemBuilder: (_, index) {
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                tileColor:
                    index.isOdd ? Colors.lightBlueAccent : Colors.indigoAccent,
                trailing: IconButton(
                  splashRadius: 24,
                  icon: _messages[index].crypted
                      ? const Icon(Icons.lock_open)
                      : const Icon(Icons.lock),
                  onPressed: () {
                    setState(() {
                      _messages[index].crypted = !_messages[index].crypted;
                    });
                  },
                ),
                title: Text(_messages[index].showMessage() ?? ''),
              );
            },
            separatorBuilder: (_, __) => SizedBox(
              height: 10,
            ),
            itemCount: _messages.length,
          ),
        ),
      ),
    );
  }

  String getPublicKeyString(crypto.AsymmetricKeyPair keyPair) {
    return RsaKeyHelper().encodePublicKeyToPemPKCS1(
        keyPair.publicKey as pointy_export.RSAPublicKey);
  }

  String getPrivateKeyString(crypto.AsymmetricKeyPair keyPair) {
    return RsaKeyHelper().encodePrivateKeyToPemPKCS1(
        keyPair.privateKey as pointy_export.RSAPrivateKey);
  }
}

class Message {
  String message;
  String? encryptedMessage;

  bool crypted;

  crypto.AsymmetricKeyPair? _asymmetricKeyPair;

  Message(
    this._asymmetricKeyPair, {
    required this.message,
    this.crypted = false,
  });

  String? encryptMessage() {
    final publicKey = _asymmetricKeyPair?.publicKey;

    if (publicKey != null) {
      encryptedMessage =
          encrypt(message, publicKey as pointy_export.RSAPublicKey);
    }

    return encryptedMessage;
  }

  String? decryptMessage() {
    final privateKey = _asymmetricKeyPair?.privateKey;

    final encMessage = encryptedMessage;

    if (encMessage != null && privateKey != null) {
      message = decrypt(encMessage, privateKey as pointy_export.RSAPrivateKey);
    }

    return message;
  }

  String? showMessage() => crypted ? encryptMessage() : decryptMessage();
}
