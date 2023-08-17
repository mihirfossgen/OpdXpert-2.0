import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/time_calculation_utils.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../../models/getAllApointments.dart';
import '../../../models/getallEmplyesList.dart';
import '../../../network/api/appointment_api.dart';
import '../../../shared_prefrences_page/shared_prefrence_page.dart';
import '../models/doctor_detail_model.dart';

class DoctorDetailController extends GetxController {
  Rx<DoctorDetailModel> doctorDetailModelObj = DoctorDetailModel().obs;
  DateTime selectedDate = DateTime.now();
  String? finalDate;
  RxString finalTime = "".obs;
  bool value = false;

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();

  TextEditingController dob = TextEditingController();
  TextEditingController gender = TextEditingController();
  Rx<TextEditingController> from = TextEditingController().obs;
  Rx<TextEditingController> to = TextEditingController().obs;
  Rx<TextEditingController> consultingDoctor = TextEditingController().obs;
  int? examinerId;

  RxString fromTime = ''.obs;
  RxString toTime = ''.obs;
  RxBool showDateAndTime = false.obs;
  TextEditingController treatment = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController address = TextEditingController();
  RxBool isLoading = false.obs;
  RxList<AppointmentContent> getAppointmentDetailsByDate =
      <AppointmentContent>[].obs;
  RxString selectedStartTime = ''.obs;
  int? index;
  final formKey = GlobalKey<FormState>();
  Rx<DateTime> dateTime = DateTime.now().obs;
  RxBool pleasefillAllFields = false.obs;
  List<DoctorList>? list;
  int? deptId;

  List<String>? times;

  getdeptId(int id) {
    deptId = list?.firstWhere((element) => element.id == id).departmentId;
    print(deptId);
    return deptId;
  }

  getDate(List<DateTime?> value) {
    selectedDate = value[0]!;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    finalDate = formatter.format(selectedDate);
  }

  getTimes() {
    String startTime = "11:45";
    String closeTime = "17:45";
    String space = "00:15";
    Duration spaceDuration = Duration(
        minutes: int.parse(space.split(':')[1]),
        hours: int.parse(space.split(':')[0]));
    TimeOfDay start = TimeOfDay(
        hour: int.parse(startTime.split(':')[0]),
        minute: int.parse(startTime.split(':')[1]));
    TimeOfDay close = TimeOfDay(
        hour: int.parse(closeTime.split(':')[0]),
        minute: int.parse(closeTime.split(':')[1]));
    List<String> timeSlots = [];
    while (start.hour < close.hour ||
        (start.hour == close.hour && start.minute <= close.minute)) {
      final time =
          DateTime(0, 0, 0, start.hour, start.minute).add(spaceDuration);
      String date2 = DateFormat("hh:mm a").format(time);
      timeSlots.add(date2);

      start = TimeOfDay(hour: time.hour, minute: time.minute);
    }

    times = timeSlots;
  }

  bool trySubmit() {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (isValid) {
      formKey.currentState!.save();
      pleasefillAllFields.value = false;
      return true;
    }
    pleasefillAllFields.value = true;
    return false;
  }

  String? emailValidator(String value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  final RegExp nameRegExp = RegExp('[a-zA-Z]');
  String? firstNameValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter first name';
    } else {
      if (!nameRegExp.hasMatch(value)) {
        return 'Enter valid name';
      } else {
        return null;
      }
    }
  }

  String? lastNameValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter last name';
    } else {
      if (!nameRegExp.hasMatch(value)) {
        return 'Enter valid name';
      } else {
        return null;
      }
    }
  }

  String? userNameValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Username must be at least 4 characters long.';
    }
    return null;
  }

  String? dobValidator(String value) {
    if (value.isEmpty) {
      return 'Please select date of birth';
    }
    return null;
  }

  String? numberValidator(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? addressValidator(String? value) {
    if (value == null) {
      return 'Please enter address';
    } else if (value == "") {
      return 'Please enter address';
    }
    return null;
  }

  DateTime timeFormat(String value) {
    final now = DateTime.now();
    final dt = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(value.split(':')[0]),
        int.parse(
            value.split(':')[1].replaceAll(" AM", "").replaceAll(" PM", "")));
    return dt;
  }

  String? fromValidator(String value, String startTime, String endTime) {
    if (value.isEmpty) {
      return 'Please select time';
    } else if (timeFormat(value).isAfter(timeFormat(startTime)) ||
        timeFormat(value).isBefore(timeFormat(endTime))) {
      return null;
    } else {
      return "Please select time between 12 to 6 PM";
    }
  }

  String? toValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Please select time.';
    }
    return null;
  }

  String? consultingDoctorValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Please select doctor';
    }
    return null;
  }

  String? treatmentValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Treatment must be at least 4 characters long.';
    }
    return null;
  }

  String? notesValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return 'Notes must be at least 4 characters long.';
    }
    return null;
  }

  String? genderValidator(String value) {
    if (value.isEmpty || value == 'SELECT') {
      return 'Please select gender';
    }
    return null;
  }

  String? consultingdoctorValidator(String value) {
    if (value.isEmpty) {
      return 'Please select doctor';
    }
    return null;
  }

  Rx<List<SelectionPopupModel>> genderList = Rx([
    SelectionPopupModel(id: 1, title: "SELECT", isSelected: true),
    SelectionPopupModel(
      id: 2,
      title: "MALE",
    ),
    SelectionPopupModel(
      id: 3,
      title: "FEMALE",
    ),
  ]);
  SelectionPopupModel? selectedgender;

  onSelectedGender(dynamic value) {
    selectedgender = value as SelectionPopupModel;
    for (var element in genderList.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    genderList.refresh();
  }

  prefieldGender(String value) {
    for (var element in genderList.value) {
      element.isSelected = false;
      if (element.title == value) {
        gender.text = element.title;
      }
    }
    update();
    genderList.refresh();
  }

  Rx<List<SelectionPopupModel>> counsultingDoctor = Rx(<SelectionPopupModel>[]);

  onConsultingDoctorSelect(dynamic value) {
    for (var element in counsultingDoctor.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        examinerId = element.id;
        element.isSelected = true;
      }
    }
    counsultingDoctor.refresh();
  }

  bool valueS = false;

  Future<void> callCreateLogin(Map<String, dynamic> req) async {
    try {
      valueS = (await Get.find<AppointmentApi>().createAppointment(
        req,
        {
          'Content-type': 'application/json',
        },
      ));
    } on Map {
      //postLoginResp = e;
      rethrow;
    }
  }

  Future<List<AppointmentContent>> callGetAppointmentDetailsForDate(
      String date) async {
    try {
      isLoading.value = true;
      var response = (await Get.find<AppointmentApi>()
          .getAppointmentDetailsViaDate(
              date, SharedPrefUtils.readPrefINt('employee_Id')));
      List<dynamic> data = response.data;
      List<AppointmentContent> list =
          data.map((e) => AppointmentContent.fromJson(e)).toList();

      getAppointmentDetailsByDate.value = list;
      return list;
    } on Map {
      //postLoginResp = e;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  setFromTime(String text) {
    from.value.text = text;
    from.refresh();
  }

  setToTime(String text) {
    to.value.text = text;
    to.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    callGetAppointmentDetailsForDate(formatter.format(DateTime.now()));
    final DateFormat format = DateFormat('yyyy-MM-dd');
    dob.text = format.format(DateTime.now());
    getTimes();
  }

  @override
  void onClose() {
    super.onClose();
    firstname.clear();
    lastname.clear();
    email.clear();
    mobile.clear();
    gender.clear();
    from.value.clear();
    to.value.clear();
    consultingDoctor.value.clear();
    treatment.clear();
    notes.clear();
  }
}
