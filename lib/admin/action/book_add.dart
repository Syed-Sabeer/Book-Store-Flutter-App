import 'package:flutter/material.dart';
import 'dart:io'; // Import this to use File
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import '../../common/color_extenstion.dart';

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

  File? _image; // This will store the selected image

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: TColor.primary,
          ),
        ),
        title: Text(
          "Add Book",
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
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
              const Text(
                'Add New Book',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Book Name',
                icon: Icons.book,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _priceController,
                labelText: 'Price',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _descriptionController,
                labelText: 'Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _authorController,
                labelText: 'Author',
                icon: Icons.person,
              ),
              const SizedBox(height: 10),

              // Image Picker Section
              const Text(
                'Image',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _image != null
                      ? Image.file(
                    _image!,
                    width: 100, // Adjust width
                    height: 100, // Adjust height
                    fit: BoxFit.cover,
                  )
                      : Container(
                    width: 100, // Adjust width
                    height: 100, // Adjust height
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate,
                      color: Colors.grey,
                      size: 60, // Adjust icon size
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildTextFormField(
                controller: _publisherController,
                labelText: 'Publisher',
                icon: Icons.business,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _languageController,
                labelText: 'Language',
                icon: Icons.language,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _lengthController,
                labelText: 'Length (pages)',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Book Added Successfully')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: TColor.primary,
                  ),
                  child: const Text(
                    'Add Book',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
