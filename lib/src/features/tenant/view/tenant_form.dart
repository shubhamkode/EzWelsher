import 'package:ez_debt/src/features/entries/view/entry_form.dart';
import 'package:ez_debt/src/features/tenant/models/tenant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

class TenantForm extends StatefulWidget {
  final Tenant? tenant;
  final Function(Tenant?)? onSave;
  final VoidCallback? onDelete;

  const TenantForm({
    super.key,
    this.tenant,
    this.onSave,
    this.onDelete,
  });

  @override
  State<TenantForm> createState() => _TenantFormState();
}

class _TenantFormState extends State<TenantForm> {
  late TextEditingController nameController;
  late TextEditingController contactController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.tenant?.name);
    contactController = TextEditingController(text: widget.tenant?.contact);
    emailController = TextEditingController(text: widget.tenant?.emailAddress);
    addressController = TextEditingController(text: widget.tenant?.homeAddress);
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Form(
          child: VStack(
            spacing: 16.h,
            [
              VStack(
                [
                  "Name".text.labelMedium(context).make(),
                  8.h.heightBox,
                  TxtField(
                    hintText: "Name",
                    controller: nameController,
                  ),
                ],
              ),
              VStack([
                "Contact".text.labelMedium(context).make(),
                8.h.heightBox,
                AmountField(
                  hintText: "Contact",
                  controller: contactController,
                ),
                // TxtField(
                //   hintText: "Contact",
                //   keyboardType: TextInputType.phone,
                //   controller: contactController,
                // ),
                16.h.heightBox,
              ]),
              VStack([
                "Email".text.labelMedium(context).make(),
                8.h.heightBox,
                TxtField(
                  hintText: "Email",
                  controller: emailController,
                ),
              ]),
              VStack(
                [
                  "Address".text.labelMedium(context).make(),
                  8.h.heightBox,
                  TxtField(
                    controller: addressController,
                    hintText: "Address",
                  ),
                ],
              ),
            ],
          ),
        ),
      ).pSymmetric(
        v: 15.h,
        h: 20.w,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 8.w,
          right: 8.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: FilledButton(
          onPressed: () {
            final tenant = Tenant()
              ..name = nameController.text
              ..emailAddress = emailController.text
              ..contact = contactController.text
              ..homeAddress = addressController.text;

            if (widget.tenant != null) {
              tenant.id = widget.tenant!.id;
            }

            if (widget.onSave != null) {
              widget.onSave!(tenant);
            }
          },
          style: FilledButton.styleFrom(
            minimumSize: Size.fromHeight(48.h),
            // shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(8.r),
            // ),
            backgroundColor: context.colors.primaryContainer,
          ),
          child: (widget.tenant != null ? "Update" : "Save")
              .text
              .labelLarge(context)
              .make(),
        ),
      ),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        widget.tenant != null
            ? IconButton(
                onPressed: () {
                  if (widget.onDelete != null) {
                    widget.onDelete!();
                  }
                },
                icon: const Icon(
                  Icons.delete_rounded,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
