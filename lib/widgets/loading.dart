import 'package:app_cashback_soamer/app_widget/colors.dart';
import 'package:app_cashback_soamer/widgets/sized_box.dart';
import 'package:app_cashback_soamer/widgets/util.dart';
import 'package:flutter/material.dart';

Widget loading({Color? color}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40, width: 40, child: CircularProgressIndicator(color: color ?? AppColor.primaryColor)),
        appSizedBoxHeight(30),
        text("Carregando...", bold: true, color:  color ?? AppColor.primaryColor),
      ],
    ),
  );
}
