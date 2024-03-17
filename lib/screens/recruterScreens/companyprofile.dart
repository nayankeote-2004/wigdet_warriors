import 'package:flutter/material.dart';
import 'package:interview_app/screens/recruterScreens/recruternavbar.dart';

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

  bool _isEditing = true;
  late CompanyProfile _companyProfile;
  late CompanyProfile _initialCompanyProfile;

  @override
  void initState() {
    _companyProfile = CompanyProfile(
      companyName: '',
      companyObjective: '',
      location: '',
      hiringManagerName: '',
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
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>RecruterNavBar()));
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
                  child: Text(_isEditing ? 'Save' : 'Edit'),
                ),
              ],
            ),
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
