import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _screenStage = "loaded";


  @override
  void initState() {
    super.initState();
    _screenStage = "loaded";
  }
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        minimumSize: const Size(200, 40));
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: BasePalette.accent,
        body: Center(
          child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: Form(
                  key:_formKey,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/music.png",
                        height: 100.0,
                        width: 200.0,
                      ),
                      const SizedBox(height: 10),
                      Text("Media Player", style: TextStyle(fontFamily: 'NeoSansBold', fontSize: 20, color: BasePalette.primary)),
                      const SizedBox(height: 5),
                      Text("for itunes", style: TextStyle(fontFamily: 'NeoSansBold', fontSize: 14, color: BasePalette.primary)),
                      const SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: BasePalette.primary,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 20,
                              offset: Offset(0, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 0.3 * height),
                            _screenStage == "loaded" ? ElevatedButton(
                              style: style,
                              onPressed: _login,
                              child: const Text('Login'),
                            ) : const CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ],
                  )
              )
          ),
        )
    );
  }

  //Login to Home Page
  _login () async {
    try{
      setState(() {
        _screenStage = "loading";
      });
      Fluttertoast.showToast(msg: "LOGIN SUCCESSFUL", toastLength: Toast.LENGTH_SHORT);
      setState(() {
        _screenStage = "loaded";
      });
      Navigator.pushNamed(context, "/musicplayer");
    } catch(e) { // to handle error function
      setState(() {
        _screenStage = "loaded";
      });
      Fluttertoast.showToast(msg: "LOGIN FAILED", toastLength: Toast.LENGTH_SHORT);
    }
  }

}
