import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:gym/constants/style_constant.dart';
import 'package:gym/models/travlog_model.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: mBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            // Travlog Section
            Padding(
              padding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
              child: Text(
                'Class Today !',
                style: mTitleStyle,
              ),
            ),
            Container(
              height: 181,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 16),
                itemCount: travlogs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 16),
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 104,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: AssetImage(travlogs[index].image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              child: SvgPicture.asset(
                                  'assets/svg/travlog_top_corner.svg'),
                              right: 0,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: SvgPicture.asset(
                                  'assets/svg/travelkuy_logo_white.svg'),
                            ),
                            Positioned(
                              bottom: 0,
                              child: SvgPicture.asset(
                                  'assets/svg/travlog_bottom_gradient.svg'),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Text(
                                'Travlog ' + travlogs[index].name,
                                style: mTravlogTitleStyle,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          travlogs[index].content,
                          maxLines: 3,
                          style: mTravlogContentStyle,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          travlogs[index].place,
                          style: mTravlogPlaceStyle,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, top: 25),
              child: Text(
                'Popular',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: mBlueColor),
              ),
            ),
            ListView.builder(
                padding: EdgeInsets.only(top: 25, right: 25, left: 25),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print('ListView Tapped');
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 19),
                      height: 81,
                      width: MediaQuery.of(context).size.width - 50,
                      color: mBackgroundColor,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 81,
                            width: 62,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: AssetImage('assets/Yellow.png'),
                                ),
                                color: mCardTitleColor),
                          ),
                          SizedBox(
                            width: 21,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'title',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: mBackgroundColor),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'author',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: mGreyColor),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '123',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: mTitleColor),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
