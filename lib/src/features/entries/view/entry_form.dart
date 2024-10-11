import 'package:ez_debt/src/features/entries/models/entries.dart';
import 'package:ez_debt/src/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:velocity_x/velocity_x.dart';

final purposes = {
  "recieved": ["Interest", "Collect Debt", "Borrow Money"],
  "paid": ["Interests", "Lend Out", "Pay Loan"]
};

class EntryForm extends StatefulWidget {
  final Entries? entry;
  final Function(Entries?)? onSave;
  final Function(int entryId)? onDelete;
  const EntryForm({
    super.key,
    this.entry,
    this.onSave,
    this.onDelete,
  });

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  late bool isEditingEnabled;
  late EntryType typeController;
  late TextEditingController dateController;
  late TextEditingController purposeController;
  late TextEditingController amountController;
  late TextEditingController remarksController;

  void resetState() {
    if (widget.entry == null) {
      return;
    }

    final entry = widget.entry!;

    typeController = entry.type ?? EntryType.recieved;
    dateController.text = entry.date.toString().split(" ")[0];
    amountController.text = entry.amount.toString();
    remarksController.text = entry.remark ?? "";
    // debugPrint(entry.purpose);

    purposeController.text = entry.purpose ?? "";
  }

  @override
  void initState() {
    super.initState();
    isEditingEnabled = widget.entry == null;

    typeController = EntryType.recieved;
    dateController = TextEditingController();
    purposeController = TextEditingController();
    amountController = TextEditingController();
    remarksController = TextEditingController();

    resetState();
  }

  List<DropdownMenuItem<String>> getMenuItems() {
    return [
      DropdownMenuItem(value: "", child: "Select purpose".text.make()),
      ...purposes[typeController.name]!.map(
        (pur) => DropdownMenuItem<String>(
          value: pur,
          child: Text(pur),
        ),
      )
    ];
  }

  @override
  void dispose() {
    dateController.dispose();
    purposeController.dispose();
    amountController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          widget.entry != null
              ? IconButton(
                  onPressed: () {
                    isEditingEnabled = isEditingEnabled.toggle();
                    setState(() {});
                    if (isEditingEnabled == false) {
                      resetState();
                    }
                  },
                  icon: Icon(!isEditingEnabled ? Icons.edit : Icons.edit_off),
                )
              : const SizedBox.shrink(),
          widget.entry != null
              ? (IconButton(
                  onPressed: () {
                    if (widget.onDelete != null) {
                      showDialog(
                        context: context,
                        builder: (ctx) => getAlertDialog(
                            title: Text(
                              'Delete entry?',
                              style: context.textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              "Selected entry would be deleted and won't be recoverable.",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant
                                    .withOpacity(0.8),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  ctx.pop();
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  ctx.pop();
                                  widget.onDelete!(widget.entry!.id);
                                },
                                child: const Text("Sure"),
                              )
                            ]),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.delete_rounded,
                    color: context.colors.error,
                  ),
                ))
              : const SizedBox(),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          child: VStack(
            spacing: 16.h,
            [
              VStack([
                "Type".text.labelMedium(context).make(),
                8.h.heightBox,
                ToggleSwitch(
                  labels: EntryType.values
                      .map((e) => e.name.firstLetterUpperCase())
                      .toList(),
                  totalSwitches: 2,
                  animate: true,
                  animationDuration: 40,
                  inactiveFgColor: Colors.white,
                  inactiveBgColor: context.colors.surfaceContainer,
                  activeBgColors: const [
                    [Vx.emerald500],
                    [Vx.rose500]
                  ],
                  minHeight: 40.h,
                  customTextStyles: [
                    context.textTheme.labelMedium?.copyWith(
                      color: typeController.index == 0
                          ? Vx.white
                          : context.colors.onSurface,
                    ),
                    context.textTheme.labelMedium?.copyWith(
                      color: typeController.index == 1
                          ? Vx.white
                          : context.colors.onSurface,
                    ),
                  ],
                  customWidths: const [double.infinity, double.infinity],
                  initialLabelIndex: typeController.entryValue,
                  cancelToggle: (index) async => !isEditingEnabled,
                  // onToggle: null,
                  onToggle: (index) {
                    typeController =
                        index == 0 ? EntryType.recieved : EntryType.paid;

                    if (typeController == widget.entry?.type) {
                      purposeController.text = widget.entry!.purpose.toString();
                    } else {
                      purposeController.text = "";
                    }
                    setState(() {});
                  },
                ),
              ]),
              VStack([
                "Date".text.labelMedium(context).make(),
                8.h.heightBox,
                TxtField(
                  controller: dateController,
                  suffixIcon: Icons.event_outlined,
                  readOnly: true,
                  enabled: isEditingEnabled,
                  hintText: "Select Date",
                  onTap: isEditingEnabled
                      ? () {
                          _selectDate(context);
                        }
                      : null,
                ),
              ]),
              VStack(
                [
                  "Purpose".text.labelMedium(context).make(),
                  8.h.heightBox,
                  DropdownButtonFormField<String>(
                    iconDisabledColor: context.colors.surface,
                    value: isEditingEnabled ? purposeController.text : "",
                    style: context.textTheme.labelMedium,
                    dropdownColor: context.colors.surfaceContainer,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    disabledHint: Text(
                      purposeController.text,
                      style: TextStyle(
                        color: context.colors.onSurface,
                      ),
                    ),
                    items: isEditingEnabled ? getMenuItems() : null,
                    onChanged: (value) {
                      if (!value.isEmptyOrNull) {
                        purposeController.text = value!;
                      }
                    },
                  ),
                ],
              ),
              VStack([
                "Amount".text.labelMedium(context).make(),
                8.h.heightBox,
                AmountField(
                  readOnly: !isEditingEnabled,
                  controller: amountController,
                  hintText: "INR",
                ),
              ]),
              VStack([
                "Remarks".text.labelMedium(context).make(),
                8.h.heightBox,
                TxtField(
                  controller: remarksController,
                  hintText: "Write remarks here...",
                  maxLines: 5,
                  enabled: isEditingEnabled,
                ),
              ]),
              4.h.heightBox,
            ],
          ).pSymmetric(
            v: 15.h,
            h: 20.w,
          ),
        ),
      ).pOnly(bottom: 20.h),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 8.w,
          right: 8.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: FilledButton(
          onPressed: isEditingEnabled
              ? () {
                  final Entries entry = widget.entry != null
                      ? (Entries()
                        ..id = widget.entry!.id
                        ..amount = double.tryParse(amountController.text)
                        ..date = DateTime.tryParse(dateController.text)
                        ..purpose = purposeController.text
                        ..remark = remarksController.text
                        ..type = typeController)
                      : (Entries()
                        ..amount = double.tryParse(amountController.text)
                        ..date = DateTime.tryParse(dateController.text)
                        ..purpose = purposeController.text
                        ..remark = remarksController.text
                        ..type = typeController);
                  if (widget.onSave != null) {
                    widget.onSave!(
                      entry,
                    );
                  }
                }
              : null,
          style: FilledButton.styleFrom(
            minimumSize: Size.fromHeight(48.h),
            backgroundColor: context.colors.primaryContainer,
          ),
          child: (widget.entry != null ? "Update" : "Save")
              .text
              .labelLarge(context)
              .make(),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: widget.entry?.date ?? DateTime.now(),
      lastDate: DateTime.now(),
      firstDate: DateTime(2000),
    );
    if (selectedDate != null) {
      dateController.text = selectedDate.toString().split(" ")[0];
    }
  }
}

class TxtField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final VoidCallback? onTap;
  final IconData? suffixIcon;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;

  final TextInputType? keyboardType;

  const TxtField({
    super.key,
    this.controller,
    this.hintText,
    this.onTap,
    this.suffixIcon,
    this.keyboardType,
    this.enabled = true,
    this.maxLines,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: enabled,
      enabled: enabled,
      onTap: onTap,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        hintText: hintText,
        suffixIcon: Icon(suffixIcon),
      ),
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      style: context.textTheme.labelMedium,
    );
  }
}

class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool readOnly;

  const AmountField({
    super.key,
    required this.controller,
    this.hintText,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: !readOnly,
      enabled: !readOnly,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12.w,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        hintText: hintText,
      ),
      readOnly: readOnly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: context.textTheme.titleMedium?.copyWith(
        color: context.colors.onSurface,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
