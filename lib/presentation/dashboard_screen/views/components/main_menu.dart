part of dashboard;

class MainMenu extends StatelessWidget {
  const MainMenu({
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final Function(int index, SelectionButtonData value) onSelected;

  @override
  Widget build(BuildContext context) {
    if (SharedPrefUtils.readPrefStr("role") == 'PATIENT') {
      return menuForPatient();
    } else if (SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST') {
      return menuForReceptionist();
    } else {
      return menuForStaff();
    }
  }

  SelectionButton menuForReceptionist() {
    return SelectionButton(
      data: [
        SelectionButtonData(
          activeIcon: EvaIcons.home,
          icon: EvaIcons.homeOutline,
          label: "Home",
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.bell,
          icon: EvaIcons.bellOutline,
          label: "Appointments",
          //totalNotif: 100,
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.personAdd,
          icon: EvaIcons.personAdd,
          label: "Patients",
          //totalNotif: 20,
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.phoneCall,
          icon: EvaIcons.phoneCall,
          label: "Emergency",
          //totalNotif: 20,
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.settings,
          icon: EvaIcons.settingsOutline,
          label: "Settings",
        ),
      ],
      onSelected: onSelected,
    );
  }

  SelectionButton menuForPatient() {
    return SelectionButton(
      data: [
        SelectionButtonData(
          activeIcon: EvaIcons.home,
          icon: EvaIcons.homeOutline,
          label: "Home",
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.person,
          icon: EvaIcons.bellOutline,
          label: "Appointments",
          //totalNotif: 100,
        ),
        // SelectionButtonData(
        //   activeIcon: EvaIcons.phoneCall,
        //   icon: EvaIcons.phoneCall,
        //   label: "Emergency",
        //   //totalNotif: 20,
        // ),
        SelectionButtonData(
          activeIcon: EvaIcons.settings,
          icon: EvaIcons.settingsOutline,
          label: "Settings",
        ),
      ],
      onSelected: onSelected,
    );
  }

  SelectionButton menuForStaff() {
    return SelectionButton(
      data: [
        SelectionButtonData(
          activeIcon: EvaIcons.home,
          icon: EvaIcons.homeOutline,
          label: "Home",
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.bell,
          icon: EvaIcons.bellOutline,
          label: "Appointments",
          //totalNotif: 100,
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.people,
          icon: EvaIcons.people,
          label: "Patients",
          //totalNotif: 20,
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.people,
          icon: EvaIcons.people,
          label: "Staff",
          //totalNotif: 20,
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.phoneCall,
          icon: EvaIcons.phoneCall,
          label: "Emergency",
          //totalNotif: 20,
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.settings,
          icon: EvaIcons.settingsOutline,
          label: "Settings",
        ),
      ],
      onSelected: onSelected,
    );
  }
}
