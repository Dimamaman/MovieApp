import 'package:feature_movie/feature_movie.dart';
import 'package:feature_tv_show/feature_tv_show.dart';
import 'package:flutter/material.dart';
import 'package:moviecatalogue/ui/home/discover_screen.dart';
import 'package:moviecatalogue/ui/menu/menu.dart';
import 'package:shared/shared.dart';

class DashBoardScreen extends StatefulWidget {
  static const routeName = '/';
  final String? title;

  const DashBoardScreen({super.key, this.title});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late PageController _pageController;
  int _page = 0;

  void _navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void _onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: <Widget>[
          MovieScreen(),
          TvShowScreen(
            actions: [
              PopupMenuButton<Menu>(
                icon: Icon(Icons.more_vert),
                onSelected: (Menu menu) {
                  Navigation.intent(context, menu.route);
                },
                itemBuilder: (BuildContext context) {
                  return menus.map((Menu menu) {
                    return PopupMenuItem<Menu>(
                      value: menu,
                      child: Text(menu.title),
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigation.intent(context, DiscoverScreen.routeName),
        child: Icon(
          Icons.location_searching,
          color: ColorPalettes.white,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: Sizes.dp8(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              color:
                  _page == 0 ? ColorPalettes.darkAccent : ColorPalettes.grey,
              icon: Icon(Icons.movie_creation),
              onPressed: () => _navigationTapped(0),
            ),
            IconButton(
              color:
                  _page == 1 ? ColorPalettes.darkAccent : ColorPalettes.grey,
              icon: Icon(Icons.live_tv),
              onPressed: () => _navigationTapped(1),
            ),
          ],
        ),
      ),
    );
  }
}
