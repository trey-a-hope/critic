import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class EntryController extends GetxController {
  RxInt navBarIndex = 0.obs;

  setCount({required int index}) => navBarIndex.value = index;
}
