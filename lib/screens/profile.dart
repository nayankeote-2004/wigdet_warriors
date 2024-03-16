import 'package:flutter/material.dart';

class CandidateProfilePage extends StatefulWidget {
  @override
  _CandidateProfilePageState createState() => _CandidateProfilePageState();
}

class _CandidateProfilePageState extends State<CandidateProfilePage> {
  bool _isEditing = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _skillsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with dummy data
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@example.com';
    _phoneController.text = '+1234567890';
    _skillsController.text = 'Java, Python, Flutter';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              buildTextField('Name', _nameController),
              SizedBox(height: 16),
              buildTextField('Email', _emailController),
              SizedBox(height: 16),
              buildTextField('Phone', _phoneController),
              SizedBox(height: 16),
              buildTextField('Skills', _skillsController),
              SizedBox(height: 32),
              _isEditing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                            });
                          },
                          child: Text('Cancel'),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Save changes
                            // Implement your save logic here
                            setState(() {
                              _isEditing = false;
                            });
                          },
                          child: Text('Save'),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      child: Text('Edit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.black), // Set text color to black
      ),
    );
  }
}
