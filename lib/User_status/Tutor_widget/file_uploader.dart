import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';


class FileUploadWidget extends StatefulWidget { //Alicia's work
  const FileUploadWidget({super.key});

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  List<String> uploadedFiles = [];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        uploadedFiles.addAll(result.files.map((f) => f.name));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24),
          child: GestureDetector(
            onTap: _pickFile,
            child: DottedBorder(
              color: const Color(0xFFE0E0E0),
              strokeWidth: 1.5,
              dashPattern: const [6, 4],
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                color: Colors.white,
                child: const Column(
                  children: [
                    Icon(
                      Icons.upload_outlined,
                      color: Color(0xFF1A1F5E),
                      size: 28,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Tap to upload",
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontFamily: "Inter",
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (uploadedFiles.isNotEmpty) ...[
          const SizedBox(height: 10),

          ...uploadedFiles.map(
            (name) => Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.insert_drive_file_outlined,
                      size: 16,
                      color: Color(0xFF000080),
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xff1f2937),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          uploadedFiles.remove(name);
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}