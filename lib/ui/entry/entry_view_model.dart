import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class EntryViewModel extends GetxController {
  EntryViewModel();

  RxInt navBarIndex = 0.obs;

  setNavBarIndex({required int index}) {
    navBarIndex.value = index;
    update();
  }
}
