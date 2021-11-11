import 'package:flutter/material.dart';
import 'package:image_gallery/views/home/home_page.dart';
import 'package:image_gallery/views/image_store/image_store.dart';
import 'package:image_gallery/views/profile/profile_screen.dart';
import 'package:image_gallery/views/text/text.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  var _current = 0;

  List<Widget> _list;
  @override
  void initState() {
    super.initState();
    this._list = [
      HomePage(),
      TextPage(),
      ImageStore(),
      ProfileScreen(),
    ];
  }

  Widget buildBottomAppBarButton(IconData icon, int index, {badge: false}) {
    Icon ico = Icon(
      icon,
      color: _current != index ? Theme.of(context).disabledColor : null,
    );
    return IconButton(
      icon: ico,
      onPressed: () {
        setState(() {
          _current = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: this._current,
        children: this._list,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: buildBottomAppBarButton(Icons.home, 0)),
            Expanded(child: buildBottomAppBarButton(Icons.message, 1)),
            Expanded(
                child: buildBottomAppBarButton(Icons.image, 2)),
            Expanded(child: buildBottomAppBarButton(Icons.person, 3)),
          ],
        ),
      ),
    );
  }
}
