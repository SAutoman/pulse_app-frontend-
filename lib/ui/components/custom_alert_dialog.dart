import 'package:flutter/material.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.color,
    required this.content,
    required this.iconData,
    required this.acceptAction,
    required this.acceptText,
    this.cancelAvailable = true,
  });

  final String title;
  final Color color;
  final String content;
  final IconData iconData;
  final Function acceptAction;
  final String acceptText;
  final bool cancelAvailable;

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      iconPadding: EdgeInsets.zero,
      icon: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 25,
            decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
          ),
          Positioned(
            top: -35,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.color, width: 5),
                  color: kWhiteColor,
                ),
                child: Icon(
                  widget.iconData,
                  fill: 1,
                  color: widget.color,
                  size: 50,
                ),
              ),
            ),
          )
        ],
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          decoration: const BoxDecoration(
              color: kWhiteColor,
              border: Border(bottom: BorderSide(color: kGreyColor))),
          child: Text(widget.title)),
      titleTextStyle: heading6SemiBold.copyWith(color: widget.color),
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        color: kWhiteColor,
        child: Text(widget.content, textAlign: TextAlign.center),
      ),
      contentTextStyle: baseRegular.copyWith(color: kBlackColor),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actionsPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      actions: [
        _isLoading
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : Row(
                children: [
                  widget.cancelAvailable
                      ? Expanded(
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: kGreyColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                  )),
                              child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Cancel',
                                    style: baseRegular.copyWith(
                                        color: kGreyDarkColor),
                                  ))))
                      : const SizedBox(),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.only(
                            bottomRight: const Radius.circular(20),
                            bottomLeft: Radius.circular(
                                widget.cancelAvailable ? 0 : 20),
                          )),
                      child: TextButton(
                        onPressed: () {
                          setState(() => _isLoading = true);
                          widget.acceptAction();
                        },
                        child: Text(
                          widget.acceptText,
                          style: baseSemiBold.copyWith(color: kWhiteColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
