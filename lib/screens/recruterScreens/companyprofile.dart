import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              buildCircularTextField('Company Name', companyNameController),
              SizedBox(height: 16),
              buildCircularTextField('Company Objective', companyObjectiveController, maxLines: null),
              SizedBox(height: 16),
              buildCircularTextField('Location', locationController),
              SizedBox(height: 16),
              buildCircularTextField('Hiring Manager Name', hiringManagerNameController),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                    textStyle: GoogleFonts.openSans(fontSize: 16),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCircularTextField(String label, TextEditingController controller, {int? maxLines}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabled: _isEditing,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      readOnly: !_isEditing,
      maxLines: maxLines,
    );
  }
}
