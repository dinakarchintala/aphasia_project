// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:flutter/material.dart";

class Homedesign extends StatelessWidget {
  const Homedesign({super.key});

  @override
  Widget build(BuildContext
   context) {
    return Scaffold(
        body:Container(
          height:double.infinity,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient:LinearGradient(
              
              begin:Alignment.topCenter,
              end:Alignment.bottomCenter,
              colors: [
                Colors.indigo,
                Colors.purple,
              ])
            ),
          child: SingleChildScrollView(
            child:Column(
              children: [
                SizedBox(height:20),
                Padding(
                padding: EdgeInsets.all(15),
                child:Row(
                  children: [
                    InkWell(
                      onTap:(){},
                      child:Icon(Icons.home_filled,
                      color:Colors.white,
                      size:30,
                      )
                    )
                  ],
                ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}