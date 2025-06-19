import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final String cityName;
  final void Function(String)? onPressed;
  const Search({super.key, required this.cityName, this.onPressed});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String name = '';
  final _formGlobalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: Column(
          children: [
            Padding(padding: EdgeInsetsGeometry.all(10)),
            Text(
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              "Enter your city Name",
            ),
            Form(
              key: _formGlobalKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: widget.cityName,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "City name required";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          name = value!;
                        });
                      },
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (_formGlobalKey.currentState!.validate()) {
                        _formGlobalKey.currentState!.save();
                        if (widget.onPressed != null) {
                          widget.onPressed!(name);
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Text(
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      "Search",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
