import 'package:flutter/material.dart';

class CompanyProfile {
  String companyName;
  String companyObjective;
  String location;
  String hiringManagerName;

  CompanyProfile({
    required this.companyName,
    required this.companyObjective,
    required this.location,
    required this.hiringManagerName,
  });
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController companyNameController;
  late TextEditingController companyObjectiveController;
  late TextEditingController locationController;
  late TextEditingController hiringManagerNameController;

  bool _isEditing = false;
  late CompanyProfile _companyProfile;
  late CompanyProfile _initialCompanyProfile;

  @override
  void initState() {
    _companyProfile = CompanyProfile(
      companyName: 'Example Corp',
      companyObjective: 'To provide innovative solutions for our clients.',
      location: 'New York, USA',
      hiringManagerName: 'John Doe',
    );

    // Store the initial values for comparison
    _initialCompanyProfile = _companyProfile;

    // Initialize controllers with initial values
    companyNameController = TextEditingController(text: _companyProfile.companyName);
    companyObjectiveController = TextEditingController(text: _companyProfile.companyObjective);
    locationController = TextEditingController(text: _companyProfile.location);
    hiringManagerNameController = TextEditingController(text: _companyProfile.hiringManagerName);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  // Save changes to company profile
                  _companyProfile = CompanyProfile(
                    companyName: companyNameController.text,
                    companyObjective: companyObjectiveController.text,
                    location: locationController.text,
                    hiringManagerName: hiringManagerNameController.text,
                  );

                  // Update initial values
                  _initialCompanyProfile = _companyProfile;
                }

                // Toggle editing mode
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField('Company Name', companyNameController),
            buildTextField('Company Objective', companyObjectiveController, maxLines: null),
            buildTextField('Location', locationController),
            buildTextField('Hiring Manager Name', hiringManagerNameController),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {int? maxLines}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabled: _isEditing,
      ),
      readOnly: !_isEditing,
      maxLines: maxLines,
    );
  }
}
