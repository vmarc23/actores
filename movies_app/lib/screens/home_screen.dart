import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_app/api/api.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:movies_app/controllers/actor_controller.dart';
import 'package:movies_app/controllers/bottom_navigator_controller.dart';
import 'package:movies_app/controllers/movies_controller.dart';
import 'package:movies_app/controllers/search_controller.dart';
import 'package:movies_app/widgets/search_box.dart';
import 'package:movies_app/widgets/tab_builder.dart';
import 'package:movies_app/widgets/top_rated_item.dart';
import 'package:movies_app/widgets/wid_actor.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final MoviesController controller = Get.put(MoviesController());
  final ActorController controller1 = Get.put(ActorController());
  final SearchController1 searchController = Get.put(SearchController1());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 42,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Flutter - Actors and Actresses',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SearchBox(
              onSumbit: () {
                String search =
                    Get.find<SearchController1>().searchController.text;
                Get.find<SearchController1>().searchController.text = '';
                Get.find<SearchController1>().search(search);
                Get.find<BottomNavigatorController>().setIndex(1);
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(
              height: 34,
            ),
            Obx(
              (() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemCount: 5,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => const SizedBox(width: 24),
                        itemBuilder: (_, index) => TopActor(
                            actor: controller1.actors[index],
                            index: index + 1),
                      ),
                    )),
            ),
            DefaultTabController(
              length: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TabBar(
                      indicatorWeight: 4,
                      indicatorColor: Color(
                        0xFF3A3F47,
                      ),
                      tabs: [
                        Tab(text: 'Famous'),
                        Tab(text: 'Top People'),
                        Tab(text: 'Most awarded'),
                        Tab(text: 'Popular'),
                      ]),
                  SizedBox(
                    height: 400,
                    child: TabBarView(children: [
                      TabBuilder(
                        future: ApiService.getActorsExtra(6),
                      ),
                      TabBuilder(
                        future: ApiService.getActorsExtra(9),
                      ),
                      TabBuilder(
                        future: ApiService.getActorsExtra(13),
                      ),
                      TabBuilder(
                        future: ApiService.getActorsExtra(16),
                      ),
                    ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
