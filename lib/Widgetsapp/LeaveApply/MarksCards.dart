import 'package:flutter/material.dart';

import '../../models/marks_model.dart';

class MarksCard extends StatefulWidget {
  final MarksModel marksModel;
  final int index;

  MarksCard({required this.marksModel, required this.index});

  @override
  State<MarksCard> createState() => _MarksCardState();
}

class _MarksCardState extends State<MarksCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "Pupil's Name : ${widget.marksModel.pupil_name}\nPupil's Level : ${widget.marksModel.level}",
              style: const TextStyle(
                fontSize: 18,
              )),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.marksModel.markstype,
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "Marks Date - ${widget.marksModel.date}",
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 0),
            child: Text(
              "Course name : ${widget.marksModel.coursename}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 0),
            child: Text(
              "Course Code : ${widget.marksModel.coursecode}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 0),
            child: Text(
              "Obtained Marks : ${widget.marksModel.marks}/${widget.marksModel.outof}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 8),
            child: Text(
              widget.marksModel.teacher_feedback,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
