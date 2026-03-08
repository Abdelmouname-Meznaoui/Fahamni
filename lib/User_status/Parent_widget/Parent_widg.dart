import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'child_card.dart';

class Parent_widget extends StatefulWidget {
  const Parent_widget({super.key});

  @override
  State<Parent_widget> createState() => _Parent_widgetState();
}

class _Parent_widgetState extends State<Parent_widget> {
  // Each item in this list = one child card on screen
  List<Map<String, dynamic>> children = [
    {"id": UniqueKey().toString(),"name": "", "level": null, "grade": null}];
  void addChild() {
    setState(() {
      children.add({"id": UniqueKey().toString(),"name": "", "level": null, "grade": null});
    });
  }
  void removeChild(int index) {
    setState(() {
      children.removeAt(index);});
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Text(
                "Children Information ",
                style: TextStyle(
                  letterSpacing: -0.25,
                  fontFamily: "Inter",
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1f2937),
                  height: 30 / 18,
                ),
              ),),
        ...List.generate(
          children.length,
          (index) => ChildCard(
            key: ValueKey(children[index]['id']),
            index: index,
            data: children[index],
            onRemove: children.length > 1 ? () => removeChild(index) : null,
            onChanged: (updatedData) {
              setState(() {
              children[index] = updatedData;
              });
            },
          ),
        ),

        const SizedBox(height: 12),

        // Add Another Child button
        Center(
          child: TextButton.icon(
            onPressed: addChild,
            icon: const Icon(
              size: 20,
              Icons.add_circle_outline,
              color: Color(0xFF000080),
            ),
            label: const Text(
              "Add Another Child",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000080),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}