import 'package:get/get.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:movies_app/models/actor.dart';

class ActorController extends GetxController {
  var isLoading = false.obs;
  var actors = <Actor>[].obs;
  var listaactores = <Actor>[].obs;
  @override
  void onInit() async {
    isLoading.value = true;
    actors.value = (await ApiService.getActors())!;
    isLoading.value = false;
    super.onInit();
  }

    bool isInWatchList(Actor actor) {
    return listaactores.any((m) => m.id == actor.id);
  }

  void addToWatchList(Actor actor) {
    if (listaactores.any((m) => m.id == actor.id)) {
      listaactores.remove(actor);
      Get.snackbar('Success', 'removed from watch list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    } else {
      listaactores.add(actor);
      Get.snackbar('Success', 'added to watch list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    }
  }

}
