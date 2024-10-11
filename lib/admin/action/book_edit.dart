import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// To use kIsWeb
import 'package:flutter/material.dart';
import 'dart:io'; // Import this to use File for non-web platforms
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import '../../common/color_extenstion.dart';
import 'package:book_grocer/admin/list/book_list_view.dart';

class EditBookPage extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const EditBookPage({super.key, required this.bookData});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with book data
    _nameController.text = widget.bookData['name'] ?? '';
    _authorController.text = widget.bookData['author'] ?? '';
    _priceController.text = widget.bookData['price']?.toString() ?? '';
    _descriptionController.text = widget.bookData['description'] ?? '';
    _publisherController.text = widget.bookData['publisher'] ?? '';
    _languageController.text = widget.bookData['language'] ?? '';
    _lengthController.text = widget.bookData['length']?.toString() ?? '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      try {
        String name = _nameController.text.trim();
        int price = int.parse(_priceController.text);
        String description = _descriptionController.text.trim();
        String author = _authorController.text.trim();
        String publisher = _publisherController.text.trim();
        String language = _languageController.text.trim();
        int length = int.parse(_lengthController.text);

        // Handle image upload if a new image is selected
        String? imageUrl;
        if (_selectedImage != null) {
          final uploadTask = FirebaseStorage.instance
              .ref("images/${DateTime.now()}.png")
              .putFile(_selectedImage!);
          final taskSnapshot = await uploadTask;
          imageUrl = await taskSnapshot.ref.getDownloadURL();
        } else {
          imageUrl = widget.bookData['img']; // Keep the old image if no new one is selected
        }

        // Update book data in Firestore
        await FirebaseFirestore.instance.collection('books').doc(widget.bookData['id']).update({
          "name": name,
          "price": price,
          "description": description,
          "author": author,
          "publisher": publisher,
          "language": language,
          "length": length,
          "img": imageUrl,
          "updatedAt": FieldValue.serverTimestamp(),
        });

        // Navigate back to the book list page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BookListPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: TColor.primary),
        ),
        title: Text("Edit Book", style: TextStyle(color: TColor.primary, fontWeight: FontWeight.w600, fontSize: 22)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Book', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _buildTextFormField(controller: _nameController, labelText: 'Book Name', icon: Icons.book),
              const SizedBox(height: 10),
              _buildTextFormField(controller: _priceController, labelText: 'Price', icon: Icons.attach_money, keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              _buildTextFormField(controller: _descriptionController, labelText: 'Description', icon: Icons.description, maxLines: 3),
              const SizedBox(height: 10),
              _buildTextFormField(controller: _authorController, labelText: 'Author', icon: Icons.person),
              const SizedBox(height: 20),
              _buildTextFormField(controller: _publisherController, labelText: 'Publisher', icon: Icons.business),
              const SizedBox(height: 10),
              _buildTextFormField(controller: _languageController, labelText: 'Language', icon: Icons.language),
              const SizedBox(height: 10),
              _buildTextFormField(controller: _lengthController, labelText: 'Length (pages)', icon: Icons.calendar_today, keyboardType: TextInputType.number),
              const SizedBox(height: 10),

              const Text('Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : (widget.bookData["img"] != null
                      ? Image.network(
                    widget.bookData["img"],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey,
                      );
                    },
                  )
                      : const Icon(Icons.add_photo_alternate, color: Colors.grey, size: 60)),
                ),
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _updateBook,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: TColor.primary,
                  ),
                  child: const Text('Update', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text form fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
