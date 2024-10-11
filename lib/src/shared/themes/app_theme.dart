import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

ThemeData getLightTheme(BuildContext context) {
  return ThemeData.light().copyWith(
    textTheme: context.textTheme
        .copyWith(
            titleMedium: context.textTheme.titleMedium?.copyWith(
              color: context.colors.onSurface,
            ),
            labelLarge: context.textTheme.labelLarge?.copyWith(
              color: context.colors.onSurface,
            ),
            labelMedium: context.textTheme.labelMedium?.copyWith(
              color: context.colors.onSurface,
            ),
            bodySmall: context.textTheme.bodySmall?.copyWith(
              color: context.colors.onSurface,
            ))
        .apply(
          fontSizeFactor: 1.sp,
        ),
  );
}

ThemeData getDarkTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    textTheme: context.textTheme
        .copyWith(
            titleMedium: context.textTheme.titleMedium?.copyWith(
              color: context.colors.onPrimary,
            ),
            labelLarge: context.textTheme.labelLarge?.copyWith(
              color: context.colors.onPrimary,
            ),
            labelMedium: context.textTheme.labelMedium?.copyWith(
              color: context.colors.onPrimary,
            ),
            bodySmall: context.textTheme.bodySmall?.copyWith(
              color: context.colors.onPrimary,
            ))
        .apply(
          fontSizeFactor: 1.sp,
        ),
  );
}
