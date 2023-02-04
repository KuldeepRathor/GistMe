import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfApi {
  static Future<File> generateCenteredText(String text, List words) async {
    // making a pdf document to store a text and it is provided by pdf pakage
    final pdf = pw.Document();
    String completed = "";
    var pages = (words.length) / 400;
    int pageCount = pages.toInt() + 1;
    print("Starting making pages $pageCount");
    int wordCount = 0;

    try {
      for (var i = 0; i < pageCount; i++) {
        String p = "";
        // print("The p was $p");
        // for (int j = i * 300; j < i * 300 + 300; j++) {
        //   p = p + " " + words[j];
        //   print("the j values is $j");
        // }
        // for (var element in words) {
        //   p = p + " " + element;
        // }
        for (int j = 0; j < 400; j++) {
          if (words[wordCount] == "thelistisended") {
            break;
          }
          p = p + " " + words[wordCount];
          wordCount++;
        }

        // Text is added here in center
        pdf.addPage(pw.Page(
          build: (pw.Context context) =>
              pw.Text(p, style: pw.TextStyle(fontSize: 16)),
        ));
        print("Made page $i \n $p");
      }

      print("Done-------------------");
    } catch (e) {
      print("the error was in generated pages $e");
    }
    // passing the pdf and name of the docoment to make a direcotory in  the internal storage
    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  // it will make a named dircotory in the internal storage and then return to its call
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    // pdf save to the variable called bytes
    final bytes = await pdf.save();

    // here a beautiful pakage  path provider helps us and take dircotory and name of the file  and made a proper file in internal storage
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    // reterning the file to the top most method which is generate centered text.
    return file;
  }

// here we use a pakage to open the existing file that we make now.
  static Future openFile(File file) async {
    final url = file.path;

    await OpenFilex.open(url);
  }
}
