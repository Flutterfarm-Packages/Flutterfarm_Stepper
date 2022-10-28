import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

const double _KDefaultButtonSize = 30;
const double _KDefaultSpace = 10;
const double _KDefaultTextFontSize = 15;
class VerticalUnoStepper extends StatefulWidget {
  final num defaultValue;
  final int min;
  final int max;
  final double inputBoxWidth;
  final int step;
  final bool disableInput;
  final BoxDecoration? ButtonBoxDecoration;
  final ValueChanged<int>? onChange;
  final Color?
      inputTextColor,
      ButtonColor,
      IconColor;

  const VerticalUnoStepper({
    Key? key,
    this.defaultValue = 0,
    this.min = 0,
    required this.max,
    this.step = 1,
    this.inputBoxWidth = 50,
    this.disableInput = false,
    this.onChange,

    this.inputTextColor,
    this.ButtonColor,
    this.IconColor, this.ButtonBoxDecoration,
  })  : assert(max >= min),
        assert(step >= 1),
        super(key: key);

  @override
  VerticalUnoStepperState createState() => VerticalUnoStepperState();
}

class VerticalUnoStepperState extends State<VerticalUnoStepper> {
  TextEditingController? controller;

  num recordNumber = 0;
  late bool enableMin;
  late bool enableMax;

  @override
  void initState() {
    super.initState();
    recordNumber =
        math.min(widget.max, math.max(widget.defaultValue, widget.min));
    controller = TextEditingController(text: '$recordNumber');
    controller!.addListener(valueChange);

    valueChange();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [

    ];

    children.add(Center(
      child: InkWell(
        onTap: enableMin ? onRemove : null,
        child: Container(

          decoration: widget.ButtonBoxDecoration==null ?

          BoxDecoration(
            color:   Colors.blue,
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: const Offset(
                  1.0,
                  3.0,
                ),
                blurRadius:10.0,
              ),         ],

          ):widget.ButtonBoxDecoration,
          height: _KDefaultButtonSize,
          width: _KDefaultButtonSize,

          child: Icon(
              Icons.remove,
              color: widget.IconColor == null ? Colors.white : widget.IconColor
          ),

        ),
      ),
    ));

    children.add(const SizedBox(height: _KDefaultSpace));

    children.add(Center(
      child: Container(
        height: 35,
        width: widget.inputBoxWidth,
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(3),
        ),
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          enabled: !widget.disableInput,
          style: TextStyle(
              fontSize: _KDefaultTextFontSize, color: widget.inputTextColor,fontWeight:FontWeight.w700),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[-0-9]")),
            LengthLimitingTextInputFormatter(3),
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
                vertical: 13.8 , horizontal: 0),
          ),
          onEditingComplete: inputComplete,
        ),
      ),
    ));

    children.add(const SizedBox(height: _KDefaultSpace));
    children.add(Center(
      child: InkWell(
        onTap: enableMin ? onAdd : null,
        child: Container(
          decoration: widget.ButtonBoxDecoration==null ?

          BoxDecoration(
            color:   Colors.blue,
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: const Offset(
                  1.0,
                  3.0,
                ),
                blurRadius:10.0,
              ),         ],

          ):widget.ButtonBoxDecoration,
          height: _KDefaultButtonSize,
          width: _KDefaultButtonSize,

          child: Icon(
              Icons.add,
              color: widget.IconColor == null ? Colors.white : widget.IconColor
          ),

        ),
      ),

    ));

    return Column(
      children: children,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  void unFocus() {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  void onRemove() {
    unFocus();
    int number = getNumber();
    number = math.max(
      widget.min,
      number - widget.step,
    );
    if (number != recordNumber) {
      updateControllerValue(number);
    }
  }

  void onAdd() {
    unFocus();
    int number = getNumber();
    number = math.min(
      widget.max,
      number + widget.step,
    );
    if (number != recordNumber) {
      updateControllerValue(number);
    }
  }

  int getNumber() {
    final String temp = controller!.text;
    if (temp.isEmpty) {
      return widget.min;
    } else {
      return math.min(widget.max, num.parse(temp) as int);
    }
  }

  void updateControllerValue(num number) {
    controller!.text = '$number';
    recordNumber = number;
    setState(() {});
  }

  void valueChange() {
    final num number = getNumber();
    enableMin = number != widget.min;
    enableMax = number != widget.max;
    if (number != recordNumber) {
      if (enableMax || enableMin) {
        recordNumber = number;
        setState(() {});
        callBackNumber();
      }
    }
  }

  void inputComplete() {
    unFocus();
    final int temp = getNumber();
    controller!.text = '$temp';
    recordNumber = temp;
  }

  void callBackNumber() {
    if (widget.onChange != null) {
      final int temp = getNumber();
      widget.onChange!(temp);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

