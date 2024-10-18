// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart'; // Import Flutter's core material library for UI components.

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  
  @override
  _LoginScreenState createState() => _LoginScreenState(); // Create the state for Screen.
}

class _LoginScreenState extends State<LoginScreen> {
  

 

  @override
  Widget build(BuildContext context) {
    // Build the UI for the Login.
    return Scaffold(
      body: Center(
        // Center the content of the screen.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center the children.
          crossAxisAlignment: CrossAxisAlignment.center, // Align cross axis with children 
          children: [
            //Email and Password containers 
            Text(//Login Text 
              'Login',
              style: TextStyle(
                fontSize : 35,
                color: Colors.green
              )
           ),
         

         // Form to enter an email 

         Padding(
           padding: const EdgeInsets.symmetric(vertical: 30,),
           child: Form(
            child: 
            Column(
              children:[
           
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter Email' , 
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
           
              ),
              onChanged: (String value){
           
              },
              //Changes on screen text as the user types
              validator: (value){
                return value!.isEmpty ? 'Enter an email' : null;
              },
              //Checks if data is entered 
            ),
           ],
           ),
           ),
         ),


        



        //Form to enter a password 

           Padding(
             padding: const EdgeInsets.symmetric(vertical: 30),
             child: Form(
                       child: 
                       Column(
              children:[
             
                       TextFormField(
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter Password' , 
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
             
              ),
              onChanged: (String value){
              //Changes on screen text as the user types 
              },
              validator: (value){
                return value!.isEmpty ? 'Enter a password' : null;
              },
              //Checks if data is entered 
                       
                  ),
                ],
              ),
            ),
           ),

           MaterialButton(onPressed: () {},
           child: Text('LOGIN'),
           color: Colors.green,
           textColor: Colors.white,
           
           
           ),




  
          ],
        ),
      ),
      
    );
  }
}