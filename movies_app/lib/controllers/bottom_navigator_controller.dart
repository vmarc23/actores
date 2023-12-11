import 'package:get/get.dart';
import 'package:movies_app/screens/home_screen.dart';
import 'package:movies_app/screens/search_screen.dart';
import 'package:movies_app/screens/watch_list_screen.dart';

class BottomNavigatorController extends GetxController {
  var screens = [
    HomeScreen(),
    const SearchScreen(),
  const WatchList(),
  ];
  var index = 0.obs;
  void setIndex(indx) => index.value = indx;
}
