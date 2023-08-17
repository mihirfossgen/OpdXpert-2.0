import 'package:appointmentxpert/models/emergency_patient_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/image_constant.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/responsive.dart';

class ListEmergencyPatientData {
  final String patientName;
  final String mobileNumber;
  final String emailId;
  final String date;
  final String patientType;

  ListEmergencyPatientData(
    this.patientName,
    this.mobileNumber,
    this.emailId,
    this.date,
    this.patientType,
  );
}

class ListEmergencyPatients extends StatelessWidget {
  const ListEmergencyPatients({
    required this.data,
    required this.onPressed,
    // required this.onPressedAssign,
    // required this.onPressedMember,
    Key? key,
  }) : super(key: key);

  final EmergencyContent data;
  final Function() onPressed;
  // final Function()? onPressedAssign;
  // final Function()? onPressedMember;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GFListTile(
        color: Colors.white,
        padding: const EdgeInsets.all(10.0),
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Email: ',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                data.emailId.toString(),
                style: const TextStyle(fontSize: 13, color: Colors.black),
              ),
            ]),
            const SizedBox(
              height: 5,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Mobile no.: ',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${data.mobileNumber}',
                style: const TextStyle(fontSize: 13, color: Colors.black),
              ),
            ]),
            const SizedBox(
              height: 5,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Date: ',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                dateFormatter(data.date.toString()),
                style: const TextStyle(fontSize: 13, color: Colors.black),
              ),
            ]),
            const SizedBox(
              height: 5,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Patient Type: ',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${data.patientType}',
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ],
        ),
        enabled: true,
        //focusColor: ,
        focusNode: FocusNode(),
        //hoverColor: Colors.blue,
        //icon: ,
        listItemTextColor: GFColors.DARK,
        //margin: getMarginOrPadding(all: 8.0),
        //onFirstButtonTap: ,
        //onLongPress: ,
        //onSecondButtonTap: ,
        onTap: () {},
        //padding: ,
        radius: 8,
        //secondButtonTextStyle: ,
        //secondButtonTitle: 'Delete',
        selected: false,
        //shadow: BoxShadow,
        //subTitleText: 'Address: ${data.address}',
        title: _buildTitle(),
        //titleText: '${data.firstName} ' + '${data.lastName}',
      ),
    );

    // ListTile(
    //   onTap: onPressed,
    //   hoverColor: Colors.transparent,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(kBorderRadius),
    //   ),
    //   leading: _buildIcon(),
    //   title: _buildTitle(),
    //   subtitle: _buildSubtitle(),
    //   trailing: _buildAssign(),
    // );
  }

  Widget loadListTile() {
    return ListTile(
      //isThreeLine: true,
      onTap: onPressed,
      hoverColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      leading: CustomImageView(
        imagePath: !Responsive.isDesktop(Get.context!)
            ? 'assets' '/images/default_profile.png'
            : '/images/default_profile.png',
      ),
      //_buildIcon(),
      title: Text(
        '${data.patientName}',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      //_buildTitle(),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            'Email: ${data.emailId.toString()}',
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Mobile No.: ${data.mobileNumber}',
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Date: ${data.date}',
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Patient Type: ${data.patientType}',
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
        ],
      ),
      //_buildSubtitle(),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.calendar_month,
            size: 30,
            color: Colors.blue.shade600,
          ),
          const SizedBox(
            height: 5,
          ),
          // Text(
          //   data.dob ?? '',
          //   style: TextStyle(fontSize: 8, color: Colors.grey.shade600),
          // ),
          // Container(
          //   padding: EdgeInsets.all(15),
          //   decoration: AppDecoration.txtStyle.copyWith(
          //     borderRadius: BorderRadiusStyle.txtRoundedBorder8,
          //   ),
          //   child: Text(
          //     "lbl_reschedule".tr,
          //     overflow: TextOverflow.ellipsis,
          //     textAlign: TextAlign.center,
          //     style: AppStyle.txtRalewayRomanSemiBold14,
          //   ),
          // ),
        ],
      ),
      //_buildAssign(),
    );
  }

  String dateFormatter(String txt) {
    if (txt != '') {
      DateTime a = DateTime.parse(txt);
      final DateFormat formatter = DateFormat('dd/MMM/yyyy');
      return formatter.format(DateTime.parse(a.toString()));
    } else {
      return '';
    }
  }

  Widget _buildIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey.withOpacity(.1),
      ),
      child: CustomImageView(
        svgPath: ImageConstant.imageNotFound,
      ),
      //child: data.icon,
    );
  }

  Widget _buildTitle() {
    return Text(
      '${data.patientName}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
