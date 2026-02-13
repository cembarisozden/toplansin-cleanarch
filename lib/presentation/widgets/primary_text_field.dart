// lib/presentation/widgets/primary_text_field.dart
//
// 📌 PrimaryTextField - Uygulamanın ana text field widget'ı
//
// Özellikler:
// - Loading durumu (suffix'te spinner)
// - Error durumu (kırmızı border + hata mesajı)
// - Password visibility toggle
// - Focus state ile gölge efekti
// - Validation desteği

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';

class PrimaryTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? headerText;
  
  // ─────────────────────────────────────────────────────────────
  // 🆕 YENİ PARAMETRELER
  // ─────────────────────────────────────────────────────────────
  
  /// Loading durumunda suffix'te spinner gösterilir
  final bool isLoading;
  
  /// Error durumunda border kırmızı olur
  final bool hasError;
  
  /// Error mesajı - TextField altında gösterilir
  final String? errorMessage;
  
  /// Form validation için validator fonksiyonu
  /// TextFormField kullanılırsa çalışır
  final String? Function(String?)? validator;

  const PrimaryTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType,
    this.headerText,
    this.isLoading = false,      // Default: loading yok
    this.hasError = false,       // Default: error yok
    this.errorMessage,
    this.validator,
  });

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  late FocusNode _focusNode;
  bool _isInternalFocusNode = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _isInternalFocusNode = true;
    } else {
      _focusNode = widget.focusNode!;
    }
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (_isInternalFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField = widget.obscureText;
    
    // ─────────────────────────────────────────────────────────────
    // 🎨 DURUMLARA GÖRE RENK BELİRLE
    // ─────────────────────────────────────────────────────────────
    
    // Error varsa kırmızı, yoksa normal outline rengi
    final borderColor = widget.hasError 
        ? context.colorScheme.error 
        : context.colorScheme.outline;
    
    // Error varsa kırmızı gölge, focus varsa normal gölge
    final shadowColor = widget.hasError
        ? context.colorScheme.error.withOpacity(0.4)
        : context.colorScheme.shadow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─────────────────────────────────────────────────────────
        // 📝 HEADER TEXT
        // ─────────────────────────────────────────────────────────
        if (widget.headerText != null) ...[
          Text(
            widget.headerText!,
            style: context.textTheme.bodyMedium?.copyWith(
              color: widget.hasError 
                  ? context.colorScheme.error 
                  : context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppDimensions.spacing4.verticalSpace,
        ],
        
        // ─────────────────────────────────────────────────────────
        // 📦 TEXT FIELD CONTAINER
        // ─────────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            // Focus veya error durumunda gölge göster
            boxShadow: (_focusNode.hasFocus || widget.hasError)
                ? [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: isPasswordField ? !_isPasswordVisible : widget.obscureText,
            keyboardType: widget.keyboardType,
            // Loading sırasında input'u devre dışı bırak
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              // ─────────────────────────────────────────────────────
              // 🔲 BORDER STYLES
              // ─────────────────────────────────────────────────────
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: BorderSide(
                  color: widget.hasError ? context.colorScheme.error : borderColor,
                ),
              ),
              // Error durumunda da kırmızı border
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: BorderSide(color: context.colorScheme.error),
              ),
              hintText: widget.hintText,
              labelText: widget.labelText,
              
              // ─────────────────────────────────────────────────────
              // 🔄 SUFFIX ICON (Loading veya Password Toggle)
              // ─────────────────────────────────────────────────────
              suffixIcon: _buildSuffixIcon(isPasswordField),
            ),
          ),
        ),
        
        // ─────────────────────────────────────────────────────────
        // ⚠️ ERROR MESSAGE
        // ─────────────────────────────────────────────────────────
        if (widget.errorMessage != null && widget.hasError) ...[
          4.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Text(
              widget.errorMessage!,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Suffix icon builder
  /// Öncelik: Loading > Password Toggle > null
  Widget? _buildSuffixIcon(bool isPasswordField) {
    // 1. Loading durumunda spinner göster
    if (widget.isLoading) {
      return Padding(
        padding: EdgeInsets.all(12.r),
        child: SizedBox(
          width: 20.r,
          height: 20.r,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }
    
    // 2. Password field ise visibility toggle göster
    if (isPasswordField) {
      return IconButton(
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
        icon: Icon(
          _isPasswordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      );
    }
    
    // 3. Hiçbiri değilse null
    return null;
  }
}
