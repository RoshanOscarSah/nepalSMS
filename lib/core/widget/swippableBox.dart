import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SwippableBox extends StatefulWidget {
  // values for the toggle
  final List<String> values;
  // callback for the toggle when swipe
  final ValueChanged onToggleCallback;
  // background color
  final Color backgroundColor;
  // button color
  final Color buttonColor;
  // text color
  final Color textColor;
  // width
  final int width;
  // box shape
  final BoxShape? boxShape;

  const SwippableBox({
    Key? key,
    required this.values,
    required this.width,
    required this.onToggleCallback,
    this.boxShape,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
  }) : super(key: key);

  @override
  SwippableBoxState createState() => SwippableBoxState();
}

class SwippableBoxState extends State<SwippableBox> {
  bool initialPosition = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width * 0.2,
      height: 32,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              FirebaseCrashlytics.instance.log("SwippableBox");
              initialPosition = !initialPosition;
              var index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
              setState(() {});
            },
            child: Container(
              width: widget.width * 0.25,
              height: 32,
              decoration: ShapeDecoration(
                color: const Color(0xFFFFECAF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.values.length,
                  (index) => Container(
                    width: widget.width * 0.1,
                    height: 32,
                    alignment: Alignment.center,
                    child: Text(widget.values[index],
                        style: GoogleFonts.comfortaa(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 37, 0, 0)),
                        )),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
                initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: widget.width * 0.1,
                height: 32,
                decoration: BoxDecoration(
                    color: const Color(0xFFFFCD85),
                    shape: widget.boxShape ?? BoxShape.circle,
                    borderRadius: widget.boxShape == BoxShape.rectangle
                        ? BorderRadius.circular(20)
                        : null),
                alignment: Alignment.center,
                child:
                    Text(initialPosition ? widget.values[0] : widget.values[1],
                        style: GoogleFonts.comfortaa(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 37, 0, 0)),
                        )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
