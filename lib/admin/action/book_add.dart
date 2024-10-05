import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // To use kIsWeb
import 'package:flutter/material.dart';
import 'dart:io'; // Import this to use File for non-web platforms
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import '../../common/color_extenstion.dart';
import 'package:book_grocer/admin/list/book_list_view.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();

  File? _image; // For non-web platforms
  XFile? _webImage; // For web platforms

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        if (kIsWeb) {
          _webImage = pickedImage; // For web
        } else {
          _image = File(pickedImage.path); // For non-web platforms
        }
      });
    }
  }

  // Method to upload data and image
  Future<void> uploadData() async {
    if (_formKey.currentState!.validate()) {
      try {
        String name = _nameController.text.trim();
        int price = int.parse(_priceController.text);
        String description = _descriptionController.text.trim();
        String author = _authorController.text.trim();
        String publisher = _publisherController.text.trim();
        String language = _languageController.text.trim();
        int length = int.parse(_lengthController.text);
        String genre = _genreController.text.trim();
        String url;

        // Handle image upload for both web and non-web platforms
        if (kIsWeb && _webImage != null) {
          final uploadTask = FirebaseStorage.instance
              .ref("images/${DateTime.now()}.png")
              .putData(await _webImage!.readAsBytes());
          final taskSnapshot = await uploadTask;
          url = await taskSnapshot.ref.getDownloadURL();
        } else if (_image != null) {
          final uploadTask = FirebaseStorage.instance
              .ref("images/${DateTime.now()}.png")
              .putFile(_image!);
          final taskSnapshot = await uploadTask;
          url = await taskSnapshot.ref.getDownloadURL();
        } else {
          throw 'No image selected!';
        }

        // Add book data to Firestore
        await FirebaseFirestore.instance.collection('books').add({
          "name": name,
          "price": price,
          "description": description,
          "author": author,
          "publisher": publisher,
          "language": language,
          "length": length,
          "genre": genre,
          "imageurl": url,
          "createdAt": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),
        });

        // Navigate back to book list page
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
        title: Text("Add Book", style: TextStyle(color: TColor.primary, fontWeight: FontWeight.w600, fontSize: 22)),
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
              const Text('Add New Book', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
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
              _buildTextFormField(controller: _genreController, labelText: 'Genre', icon: Icons.category),
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
                  child: _image != null || _webImage != null
                      ? (kIsWeb
                      ? Image.network(_webImage!.path, fit: BoxFit.cover)
                      : Image.file(_image!, fit: BoxFit.cover))
                      : const Icon(Icons.add_photo_alternate, color: Colors.grey, size: 60),
                ),
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: uploadData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: TColor.primary,
                  ),
                  child: const Text('Add', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
