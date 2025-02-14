import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ywsos2021_app/models/scan.dart';

import '../utils/variables.dart';
import '../widgets/carousel_scanned_item.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/dot_indicator.dart';
import '../providers/scans.dart';
import 'splash_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentAction = 0;
  CarouselController _carouselActionController = CarouselController();

  TextEditingController _searchEditingController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Future futureScans;

  @override
  void dispose() {
    _searchEditingController.dispose();
    super.dispose();
  }

  bool loading = true;

  @override
  void initState() {
    futureScans = Provider.of<Scans>(context, listen: false).getUserScans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scans = Provider.of<Scans>(context).userScans;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF97AC94),
            Color(0xFF5C745C),
            // Color(0xFFA2C08B),
            // Color(0xFF82C1D6),
            Color(0xFF64919F),
          ],
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: InkWell(
              onTap: () {
                if (_scaffoldKey.currentState!.isDrawerOpen) {
                  _scaffoldKey.currentState!.openEndDrawer();
                } else {
                  _scaffoldKey.currentState!.openDrawer();
                }
              },
              child: Image.asset('./assets/images/drawer_icon.png')),
          elevation: 0,
          centerTitle: true,
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'TATA',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      color: Colors.black),
                ),
                Text(
                  'Personal profile',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 9.0,
                    color: Colors.white.withOpacity(0.77),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 15,
            ),
            Image.asset(
              './assets/images/profile_pic.png',
              width: 55,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(22.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'GeoRepair',
                      style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFFFFF)),
                    ),
                    SizedBox(
                      width: 18.52,
                    ),
                    Image.asset(
                      './assets/hammer.png',
                      width: 45.96,
                      height: 44.35,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 19.77,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                CarouselSlider(
                  items: carouselItems,
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentAction = index;
                      });
                    },
                  ),
                  carouselController: _carouselActionController,
                ),
                DotIndicator(
                  carouselItems: carouselItems,
                  controller: _carouselActionController,
                  current: _currentAction,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Recently Scanned Items',
                  style: TextStyle(
                    fontSize: 19.77,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: futureScans,
                    builder: (context, snapshot) {
                      return Container(
                          height: 210,
                          // TODO: Don't show image if image is null
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                            ),
                            itemCount: scans.length,
                            itemBuilder: (context, index, realIndex) {
                              return scans.length <= 0
                                  ? Center(
                                      child: Text(
                                        'Why don\'t you add some scans to share?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black87),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CarouselScannedItem(
                                        title: scans[index].title,
                                        image: scans[index].fileContents,
                                        subTitle: scans[index].des != null
                                            ? scans[index].des.toString()
                                            : '',
                                        daysAgo: scans[index].date.toString(),
                                      ));
                            },
                          ));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
