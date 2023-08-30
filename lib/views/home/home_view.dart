import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:whisper_frontend/models/models.dart';
import 'package:whisper_frontend/utils/utils.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeView> {
  AILanguageModelSize _aiModel = AILanguageModelSize.small;
  File? _chosenFile;
  bool _loading = false;
  String? _error;

  Future<void> _runAi() async {
    if (_loading) return;
    if (_chosenFile == null) return;

    String model;

    switch (_aiModel) {
      case AILanguageModelSize.tiny:
        model = "tiny";
        break;
      case AILanguageModelSize.base:
        model = "base";
        break;
      case AILanguageModelSize.small:
        model = "small";
        break;
      default:
        model = "base";
        break;
    }

    // String initEnv = "source venv/bin/activate";
    // String whisperCommand = "whisper \"${_chosenFile?.path}\" --language English --model $model";
    String script = "whisp.sh";

    setState(() {
      _loading = true;
    });

    ProcessResult result = await Process.run('/bin/sh', [script, _chosenFile!.path, model]);

    setState(() {
      _loading = false;
    });

    if (result.exitCode == 0) {
      debugPrint('Shell script executed successfully');
      debugPrint('Output: ${result.stdout}');

      //   result = await Process.run('/bin/sh', ['-c', whisperCommand]);

      //   if (result.exitCode == 0) {
      //     debugPrint('Shell script executed successfully');
      //     debugPrint('Output: ${result.stdout}');
      //   } else {
      //     debugPrint('Failed to execute shell script');
      //     debugPrint('Error: ${result.stderr}');
      //   }
    } else {
      debugPrint('Failed to execute shell script');
      debugPrint('Error: ${result.stderr}');
      _error = result.stderr?.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'How smart should the AI be? (Smarter = Slower)',
                ),
                DropdownButton<AILanguageModelSize>(
                  value: _aiModel,
                  items: const <DropdownMenuItem<AILanguageModelSize>>[
                    DropdownMenuItem<AILanguageModelSize>(
                      value: AILanguageModelSize.tiny,
                      child: Text('Dumb'),
                    ),
                    DropdownMenuItem<AILanguageModelSize>(
                      value: AILanguageModelSize.base,
                      child: Text('Average'),
                    ),
                    DropdownMenuItem<AILanguageModelSize>(
                      value: AILanguageModelSize.small,
                      child: Text('Smart'),
                    ),
                  ],
                  onChanged: _loading
                      ? null
                      : (AILanguageModelSize? value) {
                          if (value == null) return;

                          setState(() {
                            _aiModel = value;
                          });
                        },
                ),
              ],
            ),
            TextButton(
              onPressed: _loading
                  ? null
                  : () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        dialogTitle: "Pick a video or audio file",
                        allowMultiple: false,
                        //   does not work on linux?
                        allowedExtensions: ["mp4", "mp3", "wav", "webm", "m4a", "mkv"],
                      );

                      if (result == null) {
                        (() => showMessage(context, "Canceled picking file"))();
                        return;
                      }

                      File file = File(result.files.firstOrNull?.path ?? '');
                      if (!isFileSupported(file.path)) {
                        (() => showMessage(context, "File not supported", error: true))();
                        return;
                      }

                      setState(() {
                        _chosenFile = file;
                      });
                    },
              child: const Text("Pick File"),
            ),
            Text("Chosen file: ${_chosenFile?.path ?? "None"}"),
            TextButton(
              onPressed: _chosenFile == null || _loading ? null : _runAi,
              child: Text("Run AI"),
            ),
            if (_loading)
              Column(
                children: [
                  const CircularProgressIndicator(),
                  Text("An hour long video at smart speed will take about 2-3 hours to complete"),
                ],
              ),
            if (_error != null)
              Text(
                "ERROR: $_error",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
