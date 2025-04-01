import 'package:flutter/cupertino.dart';
import 'package:budgetai/common/helpers/ui_helper.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: UIHelper.deviceWidth, height: UIHelper.deviceHeight),
        ],
      ),
    );
  }
}
