// ignore_for_file: unused_import, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart' as a;
import 'package:google_speech/google_speech.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';

import '../helpers/pdf_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initRecorder();
    player.onPlayerStateChanged.listen((event) {
      setState(() {
        playingAudio = event == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  final recorder = a.FlutterSoundRecorder();
  bool completedRecording = false;
  bool playingAudio = false;
  AudioPlayer player = AudioPlayer();
  File? selectedFile;

  var selectedFilePdf;
  String textofPDF = "Nothing";
  bool loading = false;
  // List? words;
  Future<String> sendToGPT({required List words}) async {
    var pages = (words.length) / 400;
    int requests = pages.toInt() + 1;
    String ans = "";
    int wordCount = 0;
    print("inside sendGPT request: $requests");
    for (var i = 0; i < requests; i++) {
      String textToSend = "";
      print("running gpt 3 $i");
      for (var j = 0; j < 400; j++) {
        if (words[wordCount] == null) {
          break;
        }
        textToSend = textToSend + " " + words[wordCount];
        wordCount++;
      }
      print("the text is $textToSend");
      var summaryResult = await summarizeInBulletPoints(textToSend);
      if (summaryResult != "Something Went Wrong") {
        ans = ans + "\n" + summaryResult;
      }
    }
    return ans;
  }

  Future<void> selectPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowCompression: false,
    );
    if (result != null) {
      print("started");
      setState(() {
        loading = true;
      });
      PDFDoc doc = await PDFDoc.fromPath(result.paths.first!);
      String text = await doc.text;
      textofPDF = text;

      setState(() {
        loading = false;
      });
      print("done");
    }
    // setState(() {
    //   loading = true;
    // });
    // String text =
    //     "Jupiter is the fifth planet from the Sun and the largest in the Solar System. It is a gas giant with a mass one-thousandth that of the Sun, but two-and-a-half times that of all the other planets in the Solar System combined. Jupiter is one of the brightest objects visible to the naked eye in the night sky, and has been known to ancient civilizations since before recorded history. It is named after the Roman god Jupiter.When viewed from Earth, Jupiter can be bright enough for its reflected light to cast visible shadows, and is on average the third-brightest natural object in the night sky after the Moon and Venus.\n";
    // var result = await summarizeInBulletPoints();
    // //  if(result == "Something Went Wrong"){

    // //  }
    // textofPDF = result;
    // setState(() {
    //   loading = false;
    // });
  }

  List<String?> calculateWords({required String text}) {
    List<String?> words = text.split(" ");
    return words;
  }

  Future<void> createPDF() async {
    //  Make an API Call to OpenAI

    List<String?> words = [];
    words = calculateWords(text: textofPDF);
    // // List<String?>? sendWord = [];
    // // sendWord = words;
    words.add("thelistisended");

    final pdfFile = await PdfApi.generateCenteredText(textofPDF, words);
    PdfApi.openFile(pdfFile);
  }

  generateSummary() async {
    setState(() {
      loading = true;
    });
    List words = calculateWords(text: textofPDF);
    List<String?> dummyWords = [];
    for (var i = 0; i < 2000; i++) {
      dummyWords.add(words[i]);
    }
    dummyWords.add(null);
    var summaryResult = await sendToGPT(words: dummyWords);

    setState(() {
      textofPDF = summaryResult;
      loading = false;
    });
  }

  Future<String> summarizeInBulletPoints(String text) async {
    final apiKey = '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';
    final model = 'text-curie-001';
    final prompt = 'Summarize this in bullet points:\n$text\n';
    final temperature = 0.7;
    final maxTokens = 256;
    final topP = 1;
    final frequencyPenalty = 0;
    final presencePenalty = 0;

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'prompt': prompt,
          'temperature': temperature,
          'max_tokens': maxTokens,
          'top_p': topP,
          'frequency_penalty': frequencyPenalty,
          'presence_penalty': presencePenalty,
        }),
      );

      if (response.statusCode != 200) {
        print('Request failed with status code: ${response.reasonPhrase}');
        return "Something Went Wrong";
      } else {
        final responseJson = jsonDecode(response.body);
        print("The data returned from OpenAI is:\n ${responseJson}");
        return responseJson["choices"][0]["text"];
      }
    } catch (e) {
      print("The Error was in generate summary: $e");
      return "Something Went Wrong";
    }
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future record() async {
    await recorder.startRecorder(
      toFile: "audio",
    );
  }

  Future stop() async {
    final filePath = await recorder.stopRecorder();
    final file = File(filePath!);
    selectedFile = file;
    print('Recorded file path: ${filePath.toString()}');
    setState(() {});
  }

  void transcribe() async {
    setState(() {
      loading = true;
    });
    try {
      print("inside trancribe function");
      final serviceAccount = ServiceAccount.fromString(
          '${(await rootBundle.loadString('assets/healthy-keyword-376417-a1e667eafb2a.json'))}');
      final speechToText = SpeechToText.viaServiceAccount(serviceAccount);

      final config = RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 16000,
        audioChannelCount: 1,
        useEnhanced: true,
        languageCode: 'en-US',
      );

      //         Codec codec = Codec.defaultCodec,
      // String? toFile,
      // StreamSink<Food>? toStream,
      // int sampleRate = 16000,
      // int numChannels = 1,
      // int bitRate = 16000,
      // AudioSource audioSource = AudioSource.defaultSource,

      final audio = await _getAudioContent('test.wav');
      // await speechToText.recognize(config, audio).then((value) {
      //   print("generated transcription is $value");
      //   setState(() {
      //     textofPDF = value.results
      //         .map((e) => e.alternatives.first.transcript)
      //         .join('\n');
      //   });
      // }).whenComplete(() {
      //   print("everthing was fine");
      //   setState(() {
      //     loading = false;
      //   });
      // });

      final value = await speechToText.recognize(config, audio);
      setState(() {
        textofPDF = value.results
            .map((e) => e.alternatives.first.transcript)
            .join('\n');
        loading = false;
      });
      print("the text of PDF is $textofPDF");
    } catch (e) {
      print("the error was in transcription $e");
      setState(() {
        loading = false;
      });
    }
  }

  Future<List<int>> _getAudioContent(String name) async {
    //final directory = await getApplicationDocumentsDirectory();
    //final path = directory.path + '/$name';
    // final path = '/sdcard/Download/temp.wav';
    print("sending get Audio Content");
    return File(selectedFile!.path).readAsBytesSync().toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: AvatarGlow(
      //   animate: recorder.isRecording,
      //   glowColor: Colors.purple.shade100,
      //   endRadius: 75.0,
      //   duration: const Duration(milliseconds: 2000),
      //   repeatPauseDuration: const Duration(milliseconds: 100),
      //   repeat: true,
      //   child: FloatingActionButton(
      //     onPressed: () async {
      //       if (recorder.isRecording) {
      //         await stop();

      //         setState(() {
      //           completedRecording = true;
      //         });
      //       } else {
      //         await record();
      //         setState(() {});
      //       }
      //     },
      //     child: Icon(recorder.isRecording ? Icons.mic : Icons.mic_none),
      //   ),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // StreamBuilder<a.RecordingDisposition>(
            //   builder: (context, snapshot) {
            //     final duration = snapshot.hasData
            //         ? snapshot.data!.duration
            //         : Duration.zero;

            //     String twoDigits(int n) => n.toString().padLeft(2, '0');

            //     final twoDigitMinutes =
            //         twoDigits(duration.inMinutes.remainder(60));
            //     final twoDigitSeconds =
            //         twoDigits(duration.inSeconds.remainder(60));

            //     return Text(
            //       '$twoDigitMinutes:$twoDigitSeconds',
            //       style: const TextStyle(
            //           fontSize: 20,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white),
            //     );
            //   },
            //   stream: recorder.onProgress,
            // ),
            SizedBox(
              height: size.height * 0.05,
            ),
            completedRecording || selectedFile != null
                ? InkWell(
                    onTap: () async {
                      setState(() {
                        playingAudio = !playingAudio;
                      });
                      if (playingAudio) {
                        // player.play(ap.AudioPlayer().);
                        // player.play(selectedFile!.path);
                        await player.play(
                          DeviceFileSource(selectedFile!.path),
                        );
                      } else {
                        await player.pause();
                      }
                    },
                    child: Icon(
                      playingAudio ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 60,
                    ),
                  )
                : Container(),
            // TextButton(
            //   onPressed: () async {
            //     FilePickerResult? result =
            //         await FilePicker.platform.pickFiles(
            //       type: FileType.custom,
            //       allowedExtensions: ['m4a'],
            //       allowCompression: false,
            //     );
            //     if (result != null) {
            //       print("done");
            //       setState(() {
            //         selectedFile = File(result.paths[0]!);
            //       });
            //     }
            //   },
            //   child: Text(
            //     'Select file',
            //   ),
            // ),
            Expanded(
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableText(
                            // selectedFile == null
                            //     ? "null"
                            //     : selectedFile!.paths.toString(),
                            textofPDF,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${textofPDF.length / 5} ${calculateWords(text: textofPDF).length}",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Container(),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.purple.shade100),
                    onPressed: selectPDF,
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Icon(Icons.picture_as_pdf_outlined),
                        Text(
                          "Select PDF",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.purple.shade100),
                    onPressed: createPDF,
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf),
                        Text(
                          "Create PDF",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.purple.shade100),
                    onPressed: generateSummary,
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf_sharp),
                        Text(
                          "Generate Summary",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // TextButton(
            //     onPressed: transcribe, child: Text("Generate Transcript")),
            // SizedBox(
          ],
        ),
      ),
    );
  }
}
