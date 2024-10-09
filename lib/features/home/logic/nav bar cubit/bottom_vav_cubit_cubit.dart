import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'bottom_vav_cubit_state.dart';


// Cubit لإدارة التنقل السفلي
class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  // تغيير الفهرس بناءً على النقر على أيقونة
  void changeTab(int index) => emit(index);
}

