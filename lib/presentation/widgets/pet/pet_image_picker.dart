import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PetImagePicker extends StatefulWidget {
  final String? currentImageUrl;
  final Uint8List? selectedImageBytes;
  final ValueChanged<Uint8List?> onImageSelected;

  const PetImagePicker({
    super.key,
    this.currentImageUrl,
    this.selectedImageBytes,
    required this.onImageSelected,
  });

  @override
  State<PetImagePicker> createState() => _PetImagePickerState();
}

class _PetImagePickerState extends State<PetImagePicker> {
  Uint8List? _previewBytes;

  @override
  void initState() {
    super.initState();
    _previewBytes = widget.selectedImageBytes;
  }

  @override
  void didUpdateWidget(PetImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedImageBytes != oldWidget.selectedImageBytes) {
      _previewBytes = widget.selectedImageBytes;
    }
  }

  Uint8List? _decodeDataUrl(String dataUrl) {
    try {
      final base64String = dataUrl.split(',').last;
      return base64Decode(base64String);
    } catch (e) {
      return null;
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            if (_previewBytes != null || widget.currentImageUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove photo',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _previewBytes = null);
                  widget.onImageSelected(null);
                },
              ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _previewBytes = bytes);
      widget.onImageSelected(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (_previewBytes != null) {
      imageProvider = MemoryImage(_previewBytes!);
    } else if (widget.currentImageUrl != null) {
      if (widget.currentImageUrl!.startsWith('data:')) {
        final bytes = _decodeDataUrl(widget.currentImageUrl!);
        if (bytes != null) {
          imageProvider = MemoryImage(bytes);
        }
      } else if (widget.currentImageUrl!.startsWith('http')) {
        imageProvider = NetworkImage(widget.currentImageUrl!);
      }
    }

    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? Icon(Icons.pets, size: 48, color: Colors.grey[400])
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            imageProvider == null ? 'Add Photo' : 'Change Photo',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
