import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFormField extends StatefulWidget {
  final TextEditingController controller ;
  final String hintText ;
  final String? Function(String?)? validator;
  final String fieldLabel;
  const  CustomFormField({super.key, required this.controller, required this.hintText,this.validator, required this.fieldLabel});

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _isObscure =false;
  @override
  void initState() {
    if(widget.hintText == 'Password'){
      _isObscure = true;
    }else{
      _isObscure = false;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Text(widget.fieldLabel),
        SizedBox(height: 15.h),
        TextFormField(
                  controller: widget.controller,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border:const OutlineInputBorder(),
                    suffixIcon: widget.hintText == 'Password'
                        ? IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          )
                        : null,
                  ),
                  validator: widget.validator,
                ),
      ],
    );
  }
}