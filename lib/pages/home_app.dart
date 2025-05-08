import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Image(image: AssetImage("assets/mainImage.jpg"),
                width: double.infinity,
                height: 500,
              ),
            ),
            Text("Welcome to Weather App",style: GoogleFonts.outfit(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),),
            Padding(
              padding: const EdgeInsets.all(15.0),
        
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xffb388eb),Color(0xff9d75d9),Color(0xff8762c7),Color(0xff714fa5),]
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
        
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Form(child: Column(
                        children: [
                        TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "Enter Your Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty ){
                            return "Please Enter Your Email";
                          }
                          else if(!RegExp(r"^^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)){
                            return "Please Enter a valid Email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                        TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on_rounded),
                          labelText: "Enter Your Location",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "please Enter Your Location";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(onPressed: (){

                      }, icon: Icon(Icons.keyboard_double_arrow_right_rounded, size: 30,),
                      label: Text("Start Now",style: GoogleFonts.outfit(
                        fontSize: 20,
                        color: Colors.black
                      ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffe6d600),
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        textStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      ),

                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
