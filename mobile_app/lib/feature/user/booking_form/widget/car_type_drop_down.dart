import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarTypeDropDown extends StatefulWidget {
  final String selectedCarType;
  final List<String> carTypes;
  final ValueChanged<String>? onChanged;

  const CarTypeDropDown({
    super.key,
    required this.selectedCarType,
    required this.carTypes,
    this.onChanged,
  });

  @override
  State<CarTypeDropDown> createState() => _CarTypeDropDownState();
}

class _CarTypeDropDownState extends State<CarTypeDropDown> {
  late String _selectedCarType;

  @override
  void initState() {
    super.initState();
    _selectedCarType = widget.selectedCarType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: const Color(0xFFE9E9E9)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Center(
        child: DropdownButton<String>(
          value: _selectedCarType,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4D4D4D)),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
            color: const Color(0xFF919EAB),
            fontSize: 16.sp,
            fontFamily: 'Public Sans',
            fontWeight: FontWeight.w400,
          ),
          underline: const SizedBox(),
          isExpanded: true,
          onChanged: (String? newValue) {
            if (newValue == null) return;
            setState(() {
              _selectedCarType = newValue;
            });
            widget.onChanged?.call(_selectedCarType);
          },
          items: widget.carTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  color: const Color(0xFF4D4D4D),
                  fontSize: 12.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
