import 'package:first_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:first_flutter_app/features/explore/presentation/pages/explore_page.dart';
import 'package:first_flutter_app/features/feed/presentation/pages/home_feed_page.dart';
import 'package:first_flutter_app/features/home/presentation/widgets/lacuna_nav_bar.dart';
import 'package:first_flutter_app/features/post/presentation/pages/post_capture_page.dart';
import 'package:first_flutter_app/features/profile/presentation/pages/profile_page.dart';
import 'package:first_flutter_app/features/search/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';

class AppShellPage extends StatefulWidget {
  const AppShellPage({required this.user, super.key});

  final AppUser user;

  @override
  State<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends State<AppShellPage> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeFeedPage(user: widget.user),
      const ExplorePage(),
      const PostCapturePage(),
      const SearchPage(),
      ProfilePage(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _pages),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LacunaNavBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
            ),
          ),
        ],
      ),
    );
  }
}
