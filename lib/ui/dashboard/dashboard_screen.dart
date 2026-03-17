import 'package:flutter/material.dart';
import 'package:moviecatalogue/ui/home/discover_screen.dart';
import 'package:moviecatalogue/ui/home/movie_screen.dart';
import 'package:moviecatalogue/ui/home/tv_show_screen.dart';
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
          TvShowScreen(),
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
