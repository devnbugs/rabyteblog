import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordpress_app/config/config.dart';

class ThemeModel {
  // LIGHT MODE
  final lightTheme = ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Manrope',
    brightness: Brightness.light,
    primaryColor: Config.appThemeColor,
    scaffoldBackgroundColor: Colors.grey[100],
    shadowColor: Colors.grey[200],
    cardColor: Colors.white,
    canvasColor: Colors.white, // bg color
    secondaryHeaderColor: Colors.grey.shade300, //loading card 
    // colorScheme: ColorScheme.light(
    //   // background: Colors.white, //bg color
    //   // surfaceContainer: Colors.white,
    //   surface: Colors.white,
    //   primary: Colors.black, //text
    //   secondary: Colors.blueGrey.shade600, //text
    //   onPrimary: Colors.white, //card -1
    //   onSecondary: Colors.grey.shade100, //card -2
    //   primaryContainer: Colors.grey.shade200, //card color -3
    //   secondaryContainer: Colors.grey.shade300, //card color -4
    //   // surface: Colors.grey.shade300, //shadow color -1
    //   // onBackground: Colors.grey.shade300, //loading card color,
    //   onSurface: Colors.grey.shade300,
    //   outline: Colors.blueGrey.shade100,  //chip outline color
    //   inversePrimary: Config.appThemeColor,
    // ),
    dividerColor: Colors.grey[300],
    iconTheme: IconThemeData(color: Colors.grey[900]),
    primaryIconTheme: IconThemeData(color: Colors.grey[900]),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        wordSpacing: 1,
        letterSpacing: -0.5,
        color: Colors.grey.shade900,
      ),
      iconTheme: IconThemeData(color: Colors.grey[900]),
      actionsIconTheme: IconThemeData(color: Colors.grey[900]),
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Config.appThemeColor,
      unselectedItemColor: Colors.blueGrey[200],
    ),
    popupMenuTheme: PopupMenuThemeData(
      textStyle: TextStyle(fontFamily: 'Manrope', color: Colors.grey[900], fontWeight: FontWeight.w500),
    ),
  );

  // DARK MODE
  final darkTheme = ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    fontFamily: 'Manrope',
    primaryColor: Config.appThemeColor,
    scaffoldBackgroundColor: const Color(0xff303030),
    shadowColor: Colors.grey[850],
    cardColor: Colors.grey.shade800,
    canvasColor: const Color(0xff303030),
    secondaryHeaderColor: Colors.grey.shade800,
    // colorScheme: ColorScheme.dark(
    //   // background: const Color(0xff303030), //bg color
    //   surfaceContainer: const Color(0xff303030),
    //   primary: Colors.white, //text
    //   secondary: Colors.blueGrey.shade200, //text
    //   onPrimary: Colors.grey.shade800, //card color -1
    //   onSecondary: Colors.grey.shade800, //card color -2
    //   primaryContainer: Colors.grey.shade800, //card color -3
    //   secondaryContainer: Colors.grey.shade800, //card color -4
    //   surface: const Color(0xff303030), //shadow color - 1
    //   // onBackground: Colors.grey.shade800, //loading card color,
    //   onSurface: Colors.grey.shade800,
    //   outline: Colors.blueGrey.shade700,  //chip outline color,
    //   inversePrimary: Colors.white,
    // ),
    dividerColor: Colors.grey.shade300,
    iconTheme: const IconThemeData(color: Colors.white),
    primaryIconTheme: const IconThemeData(
      color: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.grey[800],
      surfaceTintColor: Colors.grey[800],
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[800],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[500],
    ),
    popupMenuTheme: const PopupMenuThemeData(
      textStyle: TextStyle(fontFamily: 'Manrope', color: Colors.white, fontWeight: FontWeight.w500),
    ),
  );
}
