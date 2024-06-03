import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlankPage extends StatelessWidget {
  bool isVisible;
  bool? haveAppBar;
  final String? appBarText;
  final Widget? pageIcon;
  final String? text;
  final String? interactionText;
  final Function? interactionFunction;
  final Widget? interactionIcon;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;
  BlankPage({
    this.haveAppBar,
    super.key,
    this.buttonStyle,
    this.textStyle,
    this.isVisible = true,
    this.pageIcon,
    this.text,
    this.appBarText,
    this.interactionIcon,
    this.interactionFunction,
    this.interactionText,
  });

  @override
  Widget build(BuildContext context) {
    Gradient myGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 224, 139),
        Color.fromARGB(255, 200, 242, 237)
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );
    return Scaffold(
      // appBar: haveAppBar == true
      //     ? AppBar(
      //         elevation: 0,
      //         leading: IconButton(
      //           onPressed: () => Get.back(),
      //           icon: const Icon(
      //             Icons.arrow_back_ios_rounded,
      //             size: 24,
      //           ),
      //         ),
      //       )
      //     : AppBar(
      //         leading: IconButton(
      //           onPressed: () => Get.back(),
      //           icon: const Icon(
      //             Icons.arrow_back_ios_rounded,
      //             size: 24,
      //           ),
      //         ),
      //         elevation: 0,
      //       ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pageIcon ?? Icon(Icons.cancel),
              const SizedBox(
                height: 32,
              ),
              Text(
                text ?? "text goes here",
                //overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  //fontFamily: 'Manrope',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              interactionIcon == null
                  ? const SizedBox.shrink()
                  : Visibility(
                      visible: isVisible,
                      child: ElevatedButton.icon(
                        style: buttonStyle ?? ElevatedButton.styleFrom(),
                        onPressed: () => interactionFunction!(),
                        icon: interactionIcon!,
                        label: Text(
                          interactionText!,
                          style: textStyle ?? TextStyle(),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
