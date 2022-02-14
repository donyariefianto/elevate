import 'dart:async';
import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:gym/constants/style_constant.dart';
import 'package:gym/screens/attendance.dart';
import 'package:gym/screens/myclass.dart';
import 'package:gym/screens/mygym.dart';
import 'package:gym/screens/promo.dart';
import 'package:gym/screens/trainer.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        // title: SvgPicture.asset('assets/svg/lgo.svg'),
        elevation: 0,
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPromo(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('No Connection'),
            );
          } else if (snapshot.hasData) {
            return PhotosList(photos: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: mBlueColor,
              ),
            );
          }
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  const PhotosList({Key? key, required this.photos}) : super(key: key);

  final List<Photo> photos;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16, right: 16),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 24),
                  child: Text(
                    'Hi, 👋 Welcome To Gym!',
                    style: mTitleStyle,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 190,
                  child: Swiper(
                    autoplay: true,
                    layout: SwiperLayout.DEFAULT,
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(left: 30, bottom: 24),
                        width: 190.0,
                        height: 190.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          // image: DecorationImage(
                          //   fit: BoxFit.fill,
                          //   image: NetworkImage(
                          //       'https://app.elevatekupang.com/assets_user/images/promo/' +
                          //           photos[index].gambar),
                          // ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: map<Widget>(
                        photos,
                        (index, image) {
                          var _current = 0;
                          return Container(
                            alignment: Alignment.centerLeft,
                            height: 6,
                            width: 6,
                            margin: EdgeInsets.only(left: 15, top: 5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? mBlueColor
                                    : mGreyColor),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 24, bottom: 12),
            child: Text(
              'Let\'s Healthy!',
              style: mTitleStyle,
            ),
          ),
          Container(
            height: 144,
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Trainer()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.only(left: 16),
                          height: 64,
                          decoration: BoxDecoration(
                            color: mFillColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: mBorderColor, width: 1),
                          ),
                          child: Row(
                            children: <Widget>[
                              // SvgPicture.asset(
                              //   'assets/svg/trainer.svg',
                              //   fit: BoxFit.contain,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Trainers',
                                      style: mServiceTitleStyle,
                                    ),
                                    Text(
                                      'Feel freedom',
                                      style: mServiceSubtitleStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Promo()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.only(left: 16),
                          height: 64,
                          decoration: BoxDecoration(
                            color: mFillColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: mBorderColor, width: 1),
                          ),
                          child: Row(
                            children: <Widget>[
                              // SvgPicture.asset(
                              //   'assets/svg/service_train_icon.svg',
                              //   fit: BoxFit.contain,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Promo',
                                      style: mServiceTitleStyle,
                                    ),
                                    Text(
                                      'Intercity',
                                      style: mServiceSubtitleStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyGym()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.only(left: 16),
                          height: 64,
                          decoration: BoxDecoration(
                            color: mFillColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: mBorderColor, width: 1),
                          ),
                          child: Row(
                            children: <Widget>[
                              // SvgPicture.asset(
                              //   'assets/svg/service_hotel_icon.svg',
                              //   fit: BoxFit.contain,
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Attendance',
                                      style: mServiceTitleStyle,
                                    ),
                                    Text(
                                      'Gym',
                                      style: mServiceSubtitleStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Myclass()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.only(left: 16),
                          height: 64,
                          decoration: BoxDecoration(
                            color: mFillColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: mBorderColor, width: 1),
                          ),
                          child: Row(
                            children: <Widget>[
                              // SvgPicture.asset(
                              //   'assets/svg/service_car_rental_icon.svg',
                              //   fit: BoxFit.contain,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Attendance',
                                      style: mServiceTitleStyle,
                                    ),
                                    Text(
                                      'Class',
                                      style: mServiceSubtitleStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<Photo>> fetchPromo(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://apidony.000webhostapp.com/api/promo'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePromo, response.body);
}

List<Photo> parsePromo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  // print(responseBody);
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final int id;
  final String gambar;

  const Photo({
    required this.id,
    required this.gambar,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as int,
      gambar: json['gambar'] as String,
    );
  }
}
