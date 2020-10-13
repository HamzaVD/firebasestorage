import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:firebasestorage/home_screen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int currentStep = 0;

  final phoneFieldController = TextEditingController();
  final _phoneFormKey = GlobalKey<FormState>();
  final codeFieldController = TextEditingController();
  final _codeFormKey = GlobalKey<FormState>();
  final profileFieldController = TextEditingController();
  final _profileFormKey = GlobalKey<FormState>();
  // File _image;
  // final picker = ImagePicker();

  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text("Firebase Login",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 34,
                        fontWeight: FontWeight.bold)),
              ),
              OrientationBuilder(
                builder: (BuildContext context, Orientation orientation) {
                  switch (orientation) {
                    case Orientation.portrait:
                      return _buildStepper(StepperType.vertical);
                    case Orientation.landscape:
                      return _buildStepper(StepperType.horizontal);
                    default:
                      throw UnimplementedError(orientation.toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  CupertinoStepper _buildStepper(StepperType type) {
    final canCancel = currentStep > 0;
    final canContinue = currentStep < 3;
    return CupertinoStepper(
      type: type,
      currentStep: currentStep,
      // onStepTapped: (step) => setState(() => currentStep = step),
      onStepCancel: canCancel ? () => setState(() => --currentStep) : null,
      onStepContinue: currentStep == 0
          ? () {
              if (!_phoneFormKey.currentState.validate())
                return;
              else if (canContinue) {
                setState(() => ++currentStep);
              }
            }
          : currentStep == 1
              ? () {
                  if (!_codeFormKey.currentState.validate())
                    return;
                  else if (canContinue) {
                    setState(() => ++currentStep);
                  }
                }
              : currentStep == 2
                  ? () {
                      if (!_profileFormKey.currentState.validate())
                        return;
                      else if (canContinue) {
                        setState(() => ++currentStep);
                      }
                    }
                  : null,
      steps: [
        _phoneNumberStep(
            title: Text('Enter your mobile number'),
            state: currentStep == 0 ? StepState.editing : StepState.complete),
        _verificationCodeStep(
            title: Text('Verification Code'),
            state: currentStep > 1 ? StepState.complete : StepState.editing),
        _profileStep(
            title: Text('Profile'),
            state: currentStep > 2 ? StepState.complete : StepState.editing),
        Step(
            title: Text('Final Step'),
            state: StepState.editing,
            content: Row(
              children: [
                Expanded(
                  child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage()));
                      },
                      color: Colors.blue,
                      child: Text("Done")),
                ),
              ],
            ))
      ],
    );
  }

  Step _phoneNumberStep({
    @required Widget title,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
        title: title,
        state: state,
        isActive: isActive,
        content: Form(
          key: _phoneFormKey,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty)
                return 'PHone number required';
              else if (value.length < 11)
                return 'Phone number too short';
              else
                return null;
            },
            controller: phoneFieldController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: 'Phone Number'),
          ),
        ));
  }

  Step _verificationCodeStep({
    @required Widget title,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
        title: title,
        state: state,
        isActive: isActive,
        content: Form(
          key: _codeFormKey,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty)
                return 'Code required';
              else if (value.length < 6)
                return 'Code too short';
              else
                return null;
            },
            maxLength: 6,
            controller: codeFieldController,
            keyboardType: TextInputType.number,
            decoration:
                InputDecoration(counterText: '', hintText: 'Verification Code'),
          ),
        ));
  }

  Step _profileStep({
    @required Widget title,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
        title: title,
        state: state,
        isActive: isActive,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(
            //   child: _image == null
            //       ? Text('No image selected.')
            //       : Image.file(_image),
            // ),
            CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.white)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Capture an image to start labeling'),
            ),
            Form(
              key: _profileFormKey,
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty)
                    return 'Name required';
                  else
                    return null;
                },
                controller: profileFieldController,
                decoration: InputDecoration(hintText: 'Display Name'),
              ),
            ),
          ],
        ));
  }
}
