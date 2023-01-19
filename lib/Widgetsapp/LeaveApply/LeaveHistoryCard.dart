import 'package:flutter/material.dart';

import '../../models/leavemodel.dart';

class LeaveHistoryCard extends StatefulWidget {
  final LeaveModel leaveModel;
  final int index;

  LeaveHistoryCard({required this.leaveModel, required this.index});

  @override
  State<LeaveHistoryCard> createState() => _LeaveHistoryCardState();
}

class _LeaveHistoryCardState extends State<LeaveHistoryCard> {
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
              "Registration Number: ${widget.leaveModel.pupil_id}\n Names : ${widget.leaveModel.pupil_name}\nLevel :${widget.leaveModel.level}",
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
                    widget.leaveModel.leavetype,
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
                  "Apply date - ${widget.leaveModel.applyleavedate}",
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
              "${widget.leaveModel.startdate}-${widget.leaveModel.enddate}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 8),
            child: Text(
              widget.leaveModel.desc,
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
