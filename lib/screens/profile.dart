import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class USER_PROFILE extends StatefulWidget {
  const USER_PROFILE({Key? key}) : super(key: key);

  @override
  State<USER_PROFILE> createState() => _USER_PROFILEState();
}

class _USER_PROFILEState extends State<USER_PROFILE> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              header(),

            ],
          ),
        ));
  }
}

class WaveClip extends CustomClipper<Path> {
  @override
  getClip(Size size) {
// TODO: implement getClip
    var path = new Path();
    path.lineTo(0, size.height / 7);
    var firstControlPoint = new Offset(size.width / 4, size.height / 20);
    var firstEndPoint = new Offset(size.width / 2, size.height / 5);
    var secondControlPoint =
    new Offset(size.width - (size.width / 4), size.height / 3);
    var secondEndPoint = new Offset(size.width, size.height / 5);
// path.lineTo(0, size.height / 4.25);
// var firstControlPoint = new Offset(size.width / 4, size.height / 3);
// var firstEndPoint = new Offset(size.width / 2, size.height / 3 - 60);
// var secondControlPoint = new Offset(size.width - (size.width / 4), size.height / 4 - 65);
// var secondEndPoint = new Offset(size.width, size.height / 3 - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
// TODO: implement shouldReclip
    return true;
  }
}
class header extends StatelessWidget {
  const header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClip(),
              child: Container(
                color: Color(0xff93C6E7),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,15, 0, 0),
                      child: CircleAvatar(

                      backgroundColor: Colors.black, radius: 50,
                      child: Text(
                        'A',
                        style: TextStyle(
                          fontSize: 54,
                          color: Colors.white,
                        ),
                      ),
                    ),),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,40,8,8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ananya Raorane",style: TextStyle(
                              fontSize: 20
                          ),),
                          Text("ananyarane14@gmail.com"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,100,8,0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0x73000000),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Search History',style: TextStyle(color: Colors.white,fontSize: 20),),
                          Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ), Padding(
                  padding: const EdgeInsets.fromLTRB(8,8,8,0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0x73000000),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Notifications',style: TextStyle(color: Colors.white,fontSize: 20),),
                          Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ) ,Padding(
                  padding: const EdgeInsets.fromLTRB(8,8,8,0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0x73000000),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Report',style: TextStyle(color: Colors.white,fontSize: 20),),
                          Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ), Padding(
                  padding: const EdgeInsets.fromLTRB(8,8,8,0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0x73000000),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Logout',style: TextStyle(color: Colors.white,fontSize: 20),),
                          Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,8,8,0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0x73000000),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Logout',style: TextStyle(color: Colors.white,fontSize: 20),),
                          Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,8,8,0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0x73000000),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Logout',style: TextStyle(color: Colors.white,fontSize: 20),),
                          Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                        ],
                      ),
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,8,8,0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0x73000000),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Logout',style: TextStyle(color: Colors.white,fontSize: 20),),
                          Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            )

          ],
        ),
      ),);
  }
}



