import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wifi_web/docs.dart';

TextStyle get hintStyleAux => TextStyle(
      fontSize: 16.0,
      color: Colors.grey.withOpacity(0.8),
      fontWeight: FontWeight.bold,
      fontFamily: "regular",
    );

TextStyle get textStyleAux => const TextStyle(
      height: 1.5,
      fontSize: 16.0,
    );

TextStyle get titleStyleAux => const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      fontFamily: "regular",
    );

//helpers
ThemeInput get themeInputDefault => getThemeInputDefault();

ThemeInput getThemeInputDefault({
  double radius = 10.0,
}) {
  return ThemeInput(
    radius: radius,
    titleStyle: titleStyleAux,
    textStyle: textStyleAux,
    hintStyle: hintStyleAux,
    errorStyle: const TextStyle(fontSize: 13.0),
    marginErrors: const EdgeInsets.only(left: 10.0, top: 0.0),
    paddingTitle: const EdgeInsets.only(bottom: 8.0, left: 8.0),
    decorationInside: BoxDecoration(
      color: Colors.grey.withOpacity(0.15),
      borderRadius: BorderRadius.circular(radius),
    ),
    decoration: InputDecoration(
      disabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      errorBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: UtilTheme.primary),
        borderRadius: BorderRadius.circular(radius),
      ),
      border: const OutlineInputBorder(borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.only(
          top: 15.0, left: 15.0, bottom: 20.0, right: 20.0),
    ),
  );
}

ThemeInput get themeTransparent => themeInputDefault.copyWith(
      decorationInside: const BoxDecoration(color: Colors.transparent),
    );

ThemeInput get themeAmount => themeInputDefault.copyWith(
      textAlign: TextAlign.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      textStyle: titleStyleAux.copyWith(
        fontSize: 30.0,
      ),
      hintStyle: hintStyleAux.copyWith(
        fontSize: 30.0,
      ),
      textAlignTitle: TextAlign.center,
      paddingTitle: const EdgeInsets.only(bottom: 8.0, left: 0.0),
    );
//slect
typedef StringBuilderSelect<T> = String Function(T value);
typedef DateTimeBuilder<T> = DateTime Function();

class ThemeInput {
  final TextStyle? titleStyle;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? paddingInside;
  final EdgeInsetsGeometry? paddingTitle;
  final TextStyle? hintStyle;
  TextStyle? textStyle;
  final double? heightInside;
  final double? widthInside;
  final Decoration? decorationOutside;
  final Decoration? decorationInside;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final double radius;
  InputDecoration? decoration;
  final EdgeInsetsGeometry? marginErrors;
  final TextAlign? textAlignTitle;
  final TextStyle? errorStyle;

  ThemeInput({
    this.titleStyle,
    this.textAlign,
    this.paddingInside,
    this.paddingTitle,
    this.hintStyle,
    this.textStyle,
    this.heightInside,
    this.widthInside,
    this.decorationOutside,
    this.decorationInside,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.radius = 0.0,
    this.decoration,
    this.marginErrors,
    this.textAlignTitle,
    this.errorStyle,
  });

  ThemeInput copyWith({
    TextStyle? titleStyle,
    TextAlign? textAlign,
    EdgeInsetsGeometry? paddingInside,
    EdgeInsetsGeometry? paddingTitle,
    TextStyle? hintStyle,
    TextStyle? textStyle,
    double? heightInside,
    double? widthInside,
    Decoration? decorationOutside,
    Decoration? decorationInside,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
    double? radius,
    InputDecoration? decoration,
    EdgeInsetsGeometry? marginErrors,
    TextAlign? textAlignTitle,
    TextStyle? errorStyle,
  }) {
    return ThemeInput(
      titleStyle: titleStyle ?? this.titleStyle,
      textAlign: textAlign ?? this.textAlign,
      paddingInside: paddingInside ?? this.paddingInside,
      paddingTitle: paddingTitle ?? this.paddingTitle,
      hintStyle: hintStyle ?? this.hintStyle,
      textStyle: textStyle ?? this.textStyle,
      heightInside: heightInside ?? this.heightInside,
      widthInside: widthInside ?? this.widthInside,
      decorationOutside: decorationOutside ?? this.decorationOutside,
      decorationInside: decorationInside ?? this.decorationInside,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      radius: radius ?? this.radius,
      decoration: decoration ?? this.decoration,
      marginErrors: marginErrors ?? this.marginErrors,
      textAlignTitle: textAlignTitle ?? this.textAlignTitle,
      errorStyle: errorStyle ?? this.errorStyle,
    );
  }
}

class InputField<T> extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? title;
  final Widget? childRightTitle;

  //validate only field
  final GlobalKey<FormFieldState>? keyForm;
  final bool autoValidate;

  final ThemeInput? theme;

  final int maxLines;
  final int? maxLength;
  final bool obscureText;
  final bool visible;
  final FormFieldValidator<T?>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Function? onTap;
  final bool enabled;
  final bool autofocus;
  final bool isClear;
  final ValueChanged<T>? onChanged;
  final TextCapitalization textCapitalization;
  final Widget? child;
  final Widget? childRightInside;
  final Widget? childLeftInside;
  final Widget? childLeftOutSide;
  final Widget? childRightOutSide;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final List<TextInputFormatter>? inputFormatters;

//select
  final List<T>? listSelect;
  final StringBuilderSelect<T>? builderSelect;
  final T? valueSelect;

  final bool enableInteractiveSelection;
  final FocusNode? focusNode;
  final ValueChanged<FocusNode>? onChangeFocus;
  final bool isFormatMoney;

//dateTime
  final DateTimeBuilder? firstDate;
  final DateTimeBuilder? lastDate;
  final StringBuilderSelect<T>? formatDate;

  //expanded
  final int flex;

  const InputField({
    super.key,
    this.controller,
    this.title,
    this.childRightTitle,
    this.theme,
    this.hintText,
    this.labelText,
    this.keyForm,
    this.autoValidate = false,
    this.maxLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.visible = true,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.autofocus = false,
    this.isClear = false,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.childRightInside,
    this.inputFormatters,
    this.child,
    this.childLeftOutSide,
    this.childRightOutSide,
    this.childLeftInside,
    this.suffixIcon,
    this.prefixIcon,
    this.listSelect,
    this.valueSelect,
    this.builderSelect,
    this.enableInteractiveSelection = true,
    this.focusNode,
    this.onChangeFocus,
    this.isFormatMoney = false,
    //datetime
    this.firstDate,
    this.lastDate,
    this.formatDate,
    //
    this.flex = 1,
  });

  @override
  State<InputField> createState() => _InputFieldState<T>();
}

class _InputFieldState<T> extends State<InputField<T>> {
  TextEditingController controller = TextEditingController();
  GlobalKey<FormFieldState> keyForm = GlobalKey<FormFieldState>();
  bool obscureText = true;
  FocusNode focusNode = FocusNode();
  T? _value;
  ThemeInput theme = themeInputDefault;

  String formatMoney(String? money) {
    if ((money ?? "").trim().isEmpty) return "";
    var value = money ?? "";
    value = value.replaceAll(",", "");
    return value;
  }

  String formatDate(DateTime? date) {
    if (date == null) return "";
    var dateStr = DateFormat('dd-MM-yyyy').format(date);
    return dateStr.replaceAll("-", "/");
  }

  @override
  void initState() {
    if (!widget.visible) return;
    if (widget.focusNode != null) focusNode = widget.focusNode!;
    if (widget.onChangeFocus != null ||
        (widget.isFormatMoney && widget.controller != null)) {
      focusNode.addListener(() {
        if (widget.isFormatMoney) {
          widget.controller?.text = formatMoney(widget.controller?.text);
        }
        if (widget.onChangeFocus != null) widget.onChangeFocus!(focusNode);
      });
    }
    super.initState();
  }

//DateTime
  bool isDateTime = false;

  bool getStateDateTime(T? value) {
    bool valueR = false;
    if (widget.firstDate != null || widget.lastDate != null) {
      if (value != null) {
        String dateStr = formatDate(value as DateTime);
        if (widget.formatDate != null) dateStr = widget.formatDate!(value);
        controller.text = dateStr;
      } else {
        controller.text = "";
      }
      valueR = true;
    }
    return valueR;
  }

  void getDateTime() async {
    var now = DateTime.now();
    if (widget.valueSelect != null) now = widget.valueSelect as DateTime;
    var firstDate = DateTime(now.year - 1, now.month, now.day);
    var lastDate = DateTime(now.year + 1, now.month, now.day);
    if (widget.firstDate != null) firstDate = widget.firstDate!();
    if (widget.lastDate != null) lastDate = widget.lastDate!();
    if (!context.mounted) return;
    DateTime? dateSelect = await showDatePicker(
      context: context,
      firstDate: firstDate,
      initialDate: now,
      lastDate: lastDate,
    );
    if (dateSelect != null) {
      T val = dateSelect as T;
      _value = val;
      getStateDateTime(_value);
      onChangeData(val);
    }
  }

  onChangeData(T val) {
    //value
    if (widget.onChanged != null) widget.onChanged!(val);
    //auto validate
    autoValidateFormField();
    setState(() {});
  }

  void autoValidateFormField() {
    if (widget.autoValidate) {
      keyForm.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return Container();
    controller = widget.controller ?? controller;
    keyForm = widget.keyForm ?? keyForm;
    theme = widget.theme ?? themeInputDefault;
    isDateTime = getStateDateTime(widget.valueSelect);
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          FocusScope.of(context).requestFocus(FocusNode());
          widget.onTap!();
        } else if (isDateTime) {
          getDateTime();
        }
      },
      child: Container(
        constraints: getMaxWidth,
        child: Column(
          crossAxisAlignment:
              theme.crossAxisAlignment ?? CrossAxisAlignment.start,
          mainAxisAlignment: theme.mainAxisAlignment ?? MainAxisAlignment.start,
          children: [
            if ((widget.title ?? "").trim().isNotEmpty) ...[
              Container(
                margin: theme.paddingTitle,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title!,
                        textAlign: theme.textAlignTitle,
                        style: theme.titleStyle,
                      ),
                    ),
                    widget.childRightTitle ?? Container(),
                  ],
                ),
              ),
            ],
            Container(
              decoration: theme.decorationOutside,
              child: Row(
                children: [
                  widget.childLeftOutSide ?? Container(),
                  Expanded(flex: widget.flex, child: contentInside()),
                  widget.childRightOutSide ?? Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentInside() {
    return Column(
      children: [
        Container(
          decoration: theme.decorationInside,
          padding: theme.paddingInside,
          width: theme.widthInside,
          height: theme.heightInside,
          alignment: Alignment.topCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(theme.radius),
            clipBehavior: Clip.none,
            child: Row(
              children: <Widget>[
                widget.childLeftInside ?? Container(),
                if (widget.child != null) ...[
                  widget.child!,
                ] else if (widget.listSelect != null &&
                    widget.builderSelect != null) ...[
                  Expanded(flex: widget.flex, child: inputSelect()),
                ] else ...[
                  Expanded(flex: widget.flex, child: inputText()),
                ],
                widget.childRightInside ?? Container(),
              ],
            ),
          ),
        ),
        if (widget.validator != null) ...[
          Transform.translate(
            offset: const Offset(0, -3),
            child: Container(
              margin: theme.marginErrors,
              alignment: Alignment.bottomCenter,
              child: TextFormField(
                key: keyForm,
                controller: controller,
                validator: (_) {
                  if (widget.controller != null && widget.valueSelect == null) {
                    _value = widget.controller?.text as T;
                  }
                  return widget.validator!(_value);
                },
                style: const TextStyle(
                  color: Colors.transparent,
                  fontSize: 0.0,
                  height: 0.0,
                ),
                decoration: const InputDecoration.collapsed(
                  hintText: "",
                ).copyWith(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  errorStyle: theme.decoration?.errorStyle ?? theme.errorStyle,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget inputText() {
    return TextField(
      controller: controller,
      textAlign: theme.textAlign ?? TextAlign.start,
      focusNode: focusNode,
      enabled: isDateTime ? false : widget.enabled,
      style: theme.textStyle,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      obscureText: widget.obscureText ? obscureText : false,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      autofocus: widget.autofocus,
      onChanged: (val) {
        T t = val as T;
        _value = t;
        onChangeData(t);
      },
      enableInteractiveSelection: widget.enableInteractiveSelection,
      textCapitalization: widget.textCapitalization,
      decoration: (theme.decoration ?? const InputDecoration()).copyWith(
          suffixIcon: widget.obscureText
              ? passwordView()
              : isDateTime && widget.suffixIcon == null
                  ? calendarView()
                  : widget.isClear && widget.suffixIcon == null
                      ? clearView()
                      : widget.suffixIcon,
          prefixIcon: widget.isClear && widget.prefixIcon == null
              ? iconSearch()
              : widget.prefixIcon,
          hintText: widget.hintText,
          hintStyle: theme.hintStyle,
          labelText: widget.labelText,
          errorStyle: theme.decoration?.errorStyle ?? theme.errorStyle),
    );
  }

  Widget inputSelect() {
    return InputSelect<T>(
      listSelect: widget.listSelect ?? [],
      builderSelect: widget.builderSelect!,
      valueSelect: widget.valueSelect,
      hintText: widget.hintText ?? "",
      hintStyle: theme.hintStyle,
      labelText: widget.labelText,
      textStyle: theme.textStyle,
      isUnderLine: false,
      enabled: widget.enabled,
      onChanged: (T val) {
        _value = val;
        onChangeData(val);
      },
    );
  }

  Widget passwordView() {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 10.0),
        width: 20.0,
        child: Icon(
          Icons.remove_red_eye_outlined,
          color: obscureText ? Colors.grey : Theme.of(context).primaryColor,
          size: obscureText ? 18.0 : 20.0,
        ),
      ),
      onTap: () => setState(() => obscureText = !obscureText),
    );
  }

  Widget calendarView() {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 10.0),
      width: 20.0,
      child: const Icon(
        Icons.calendar_month_sharp,
      ),
    );
  }

  Widget? clearView() {
    bool isClean = controller.text.trim().isNotEmpty;
    if (!isClean) return null;
    return GestureDetector(
      child: Icon(
        Icons.clear,
        color: Theme.of(context).primaryColor,
        size: 25.0,
      ),
      onTap: () {
        if (isClean) {
          controller.clear();
          setState(() {});
          onChangeData("" as T);
        }
      },
    );
  }

  Widget iconSearch() {
    return const Icon(
      Icons.search,
      size: 20.0,
      color: Colors.grey,
    );
  }
}

// ignore: must_be_immutable
// ignore: must_be_immutable
class InputSelect<T> extends StatelessWidget {
  final List<T> listSelect;
  final StringBuilderSelect<T> builderSelect;
  final T? valueSelect;
  final String? labelText;
  final String? hintText;
  final ValueChanged<T>? onChanged;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final FormFieldValidator<T>? validator;
  final bool isUnderLine;
  final bool enabled;

  InputSelect({
    super.key,
    required this.listSelect,
    required this.builderSelect,
    this.valueSelect,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.hintStyle,
    this.textStyle,
    this.validator,
    this.isUnderLine = false,
    this.enabled = true,
  });

  TextEditingController edit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (labelText != null) ...[
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Text(
              labelText ?? "",
            ),
          ),
        ],
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<T>(
            value: valueSelect,
            icon: Container(
              padding: const EdgeInsets.all(10.0).copyWith(left: 2.0),
              child: const Icon(Icons.keyboard_arrow_down),
            ),
            hint: Text(
              hintText ?? "",
              style: hintStyle,
            ),
            isExpanded: true,
            underline: Container(
              width: double.infinity,
              height: 0.8,
              color: !isUnderLine ? Colors.transparent : Colors.grey,
            ),
            onChanged: (T? value) {
              FocusScope.of(context).requestFocus(FocusNode());
              if (onChanged != null && value != null) {
                onChanged!(value);
              }
            },
            items: List.generate(listSelect.length, (index) {
              T value = listSelect[index];
              return DropdownMenuItem<T>(
                value: value,
                enabled: enabled,
                child: Container(
                  padding: const EdgeInsets.only(
                    bottom: 5.0,
                    left: 0.0,
                    right: 0.0,
                    top: 5.0,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    builderSelect(value),
                    style: textStyle,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

BoxConstraints get getMaxWidth => const BoxConstraints(maxWidth: 500.0);

class ModelCombo {
  String? text;
  dynamic model;

  ModelCombo(this.text, this.model);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelCombo &&
          runtimeType == other.runtimeType &&
          text == other.text;

  @override
  int get hashCode => text.hashCode;
}
