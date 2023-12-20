import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int index) onItemTapped;

  CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final itemsLabels = ['Home', 'Katalog', 'Forum', 'Profile'];

  List<Widget> _buildNavBarItems() {
    return List.generate(itemsLabels.length, (index) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            index == 0 ? Icons.home_rounded :
            index == 1 ? Icons.menu_book_rounded :
            index == 2 ? Icons.forum :
            Icons.person,
            size: 30,
            color: widget.currentIndex == index ? Colors.black : Colors.grey,
          ),
          if (widget.currentIndex != index) 
            Text(
              itemsLabels[index],
              style: TextStyle(
                color: widget.currentIndex == index ? Colors.yellow : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold
              ),
            ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: widget.currentIndex,
      height: 60.0,
      items: _buildNavBarItems(),
      color: Colors.white,
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.yellow,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: widget.onItemTapped,
    );
  }
}
