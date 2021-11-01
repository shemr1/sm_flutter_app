
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.lightBlueAccent,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.blueAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        'Schedule Me',
        style: GoogleFonts.kaushanScript(
          textStyle: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.watch_rounded,
                color: Colors.lightBlueAccent,
              ),
              onPressed: () => Navigator.pushNamed(context, '/appointMe'),
            ),
            Positioned(
                child: Stack(
                  children: [
                    Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.white,
                    ),
                    // Positioned(
                    // top: 3.0,
                    //   bottom: 4.0,
                        // child: Consumer<AppointItemCounter>(
                        //   builder:(
                        //       (context, counter, _){
                        //         return Text(
                        //           // counter.count.toString(),
                        //           style: TextStyle(
                        //             color: Colors.blue,
                        //             fontSize: 10.0,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         );
                        //       }
                        //   )
                        // ),
                    //)
                  ],
                )
            )
          ],
        )
      ],
    );
  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
