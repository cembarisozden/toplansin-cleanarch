import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toplansin_cleanarch/core/router/route_names.dart';
import 'package:toplansin_cleanarch/presentation/widgets/app_bottom_nav_bar.dart';

/// Bottom nav bar'ın gösterildiği ana kabuk. Sadece shell route'larda kullanılır.
class MainShellPage extends StatefulWidget {
  const MainShellPage({
    super.key,
    required this.child,
    required this.currentPath,
  });

  final Widget child;
  final String currentPath;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _selectedIndexFromPath(widget.currentPath);
  }

  int _selectedIndexFromPath(String path) {
    if (path.startsWith(RoutePaths.home)) return 0;
    // İleride: if (path.startsWith(RoutePaths.profile)) return 1;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(RouteNames.home);
        break;
      // İleride: case 1: context.goNamed(RouteNames.profile); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavBar(
              selectedIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                _onTap(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
