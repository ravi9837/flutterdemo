import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<FlowMain> questionsMainFromJson(str) =>
    List<FlowMain>.from((str).map((x) => FlowMain.fromJson(x.data())));

List<FlowMain> flowFromJson(String str) =>
    List<FlowMain>.from(json.decode(str).map((x) => FlowMain.fromJson(x)));

//String flowToJson(List<Flow> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FlowMain {
  List<Elements>? elements;
  var priority;
  var flowchartId;
  var flowchartName;
  // var flowId;
  // var flowName;

  FlowMain({
    this.elements,
    this.priority,
    this.flowchartId,
    this.flowchartName,
    // this.flowId,
    // this.flowName,
  });

  factory FlowMain.fromJson(Map<String, dynamic> json) => FlowMain(
        elements: json["elements"] != null
            ? List<Elements>.from(
                json["elements"].map((x) => Elements.fromJson(x)))
            : [],
        priority: json["priority"] ??0,
        flowchartId: json["flowchartId"] ?? "",
        flowchartName: json["flowchartName"] ?? "",
        // flowId: json["flowId"] ?? "",
        // flowName: json["flowName"] ?? "",
      );

// Map<String, dynamic> toJson() => {
// "elements": List<dynamic>.from(elements.map((x) => x.toJson())),
// "priority": priority,
// "flowId": flowId,
// "flowName": flowName,
// };
}

class Elements {
  List<Next>? next;
  List<AgeGroup> ageGroup;
  List genderGroup;
  var navigationId;
  var kind;
  var id;
  var text;
  var endId;
  var startId;
  var backgroundColor;
  var borderColor;
  var borderThickness;
  var elevation;
  var groupIndex;
  var handlerSize;
  var options;
  var positionDx;
  var positionDy;
  var selectedGroup;
  List<Range> range;
  var selectedMode;

  //var (size.height);
  //var (size.width);
  var textColor;
  var textIsBold;
  var textSize;
  List<dynamic>? handlers;
  List? attachments;
  var multiOptions;
  var isMandatory;
  var isFollowUp;
  var isPregnancy;

  ///
  var answer;
  var previousId;
  var prevSubFlowQuestion;

  Elements({
    required this.next,
    required this.ageGroup,
    required this.genderGroup,
    required this.navigationId,
    required this.kind,
    required this.id,
    required this.text,
    this.endId,
    this.startId,
    this.backgroundColor,
    this.borderColor,
    this.borderThickness,
    this.elevation,
    this.groupIndex,
    this.handlerSize,
    this.options,
    this.positionDx,
    this.positionDy,
    this.selectedGroup,
    required this.range,
    this.selectedMode,
    //this.(size.height),
    //this.(size.width),
    this.textColor,
    this.textIsBold,
    this.textSize,
    this.handlers,
    this.attachments,
    this.multiOptions,
    this.isMandatory,
    this.isFollowUp,
    this.isPregnancy,

    ///
    this.answer,
    this.previousId,
    this.prevSubFlowQuestion,
  });

  factory Elements.fromJson(Map<String, dynamic> json) => Elements(
        next: json["next"] != null ? nextFromJson(json['next']) : null,
        ageGroup: json["ageGroup"] != null ? List<AgeGroup>.from(json["ageGroup"].map((x) => AgeGroup.fromJson(x))) : [],
        range: json["range"] != null ? List<Range>.from(json["range"].map((x) => Range.fromJson(x))) : [],
        genderGroup: json["genderGroup"] != null ? List<dynamic>.from(json["genderGroup"]) : [],
        navigationId: json["navigationId"] ?? "",
        kind: json["kind"] ?? 0,
        id: json["id"] ?? "",
        text: json["text"] ?? "",
        endId: json["endId"] ?? "",
        startId: json["startId"] ?? "",
        backgroundColor: json["backgroundColor"],
        borderColor: json["borderColor"],
        borderThickness: json["borderThickness"],
        elevation: json["elevation"],
        groupIndex: json["groupIndex"],
        handlerSize: json["handlerSize"],
        options: json["options"],
        positionDx: json["positionDx"],
        positionDy: json["positionDy"],
        selectedGroup: json["selectedGroup"],
        selectedMode: json["selectedMode"],
        textColor: json["textColor"],
        textIsBold: json["textIsBold"],
        textSize: json["textSize"],
        handlers: json["handlers"] != null ? List<dynamic>.from(json["handlers"]) : null,
        multiOptions: json["multiOptions"],
        isMandatory: json["isMandatory"],
        isFollowUp: json["isFollowUp"],
        isPregnancy: json["isPregnancy"],
      );

  Map<String, dynamic> toJson() => {
        "next": List<dynamic>.from(next!.map((x) => x.toJson())),
        "navigationId": navigationId,
        "kind": kind,
        "id": id,
        "text": text,
        "endId": endId,
        "startId": startId,
      };
}

List<Next> nextFromJson(str) =>
    List<Next>.from((str).map((x) => Next.fromJson(x)));

class Next {
  DocumentReference<Object?>? reference;

  Next({
    this.arrowParams,
    required this.destElementId,
  });

  ArrowParams? arrowParams;
  String? destElementId;

  factory Next.fromJson(Map<String, dynamic> json) => Next(
        arrowParams: json["arrowParams"] != null ? ArrowParams.fromJson(json["arrowParams"]) : null,
        destElementId: json["destElementId"],
      );

  Next.fromMap(json, {this.reference}) {
    arrowParams = json["arrowParams"];
    destElementId = json["destElementId"];
  }

  Map<String, dynamic> toJson() => {
        "arrowParams": arrowParams,
        "destElementId": destElementId,
      };

  Next.fromSnapshot(QueryDocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class ArrowParams {
  DocumentReference<Object?>? reference;

  ArrowParams({
    this.color,
    this.endArrowPositionX,
    this.endArrowPositionY,
    this.startArrowPositionX,
    this.startArrowPositionY,
    this.thickness,
  });

  var color;
  var endArrowPositionX;
  var endArrowPositionY;
  var startArrowPositionX;
  var startArrowPositionY;
  var thickness;

  factory ArrowParams.fromJson(Map<String, dynamic> json) => ArrowParams(
        color: json["color"],
        endArrowPositionX: json["endArrowPositionX"],
        endArrowPositionY: json["endArrowPositionY"],
        startArrowPositionX: json["startArrowPositionX"],
        startArrowPositionY: json["startArrowPositionY"],
        thickness: json["thickness"],
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "endArrowPositionX": endArrowPositionX,
        "endArrowPositionY": endArrowPositionY,
        "startArrowPositionX": startArrowPositionX,
        "startArrowPositionY": startArrowPositionY,
        "thickness": thickness,
      };

  ArrowParams.fromMap(json, {this.reference}) {
    color = json["color"];
    endArrowPositionX = json["endArrowPositionX"];
    endArrowPositionY = json["endArrowPositionY"];
    startArrowPositionX = json["startArrowPositionX"];
    startArrowPositionY = json["startArrowPositionY"];
    thickness = json["thickness"];
  }

  ArrowParams.fromSnapshot(QueryDocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class Range {
  var min;
  var max;
  var length;
  var pattern;

  Range({this.min, this.max, this.length, this.pattern});

  factory Range.fromJson(Map<String, dynamic> json) => Range(
      min: json["min"],
      max: json["max"],
      length: json["length"],
      pattern: json["pattern"]);

  Map<String, dynamic> toJson() {
    return {'min': min, 'max': max, 'length': length, "pattern": pattern};
  }
}

class AgeGroup {
  var start;
  var end;
  var groupName;
  var priority;
  var endRange;
  var startRange;
  var isMandatory;

  AgeGroup(
      {required this.start, required this.end, this.groupName, this.priority,this.isMandatory,this.endRange,this.startRange});

  factory AgeGroup.fromJson(Map<String, dynamic> json) => AgeGroup(
      start: json["start"],
      end: json["end"],
      groupName: json["groupName"],
      priority: json["priority"],
      endRange: json["endRange"],
      startRange: json["startRange"],
      isMandatory: json["isMandatory"]);

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'groupName': groupName,
      'priority': priority,
      'endRange': endRange,
      'startRange': startRange,
      'isMandatory': isMandatory,

    };
  }
}

/// MODEL FOR START AND END TO GET THE SUB FLOW START AND END INDEX VALUE

List<StartEndIndex> questionErrorsFromJson(str) => List<StartEndIndex>.from(
    (str).map((x) => StartEndIndex.fromJson(x.data())));

String questionErrorsToJson(List<StartEndIndex> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StartEndIndex {
  var start;
  var end;
  var skipped;

  StartEndIndex({
    required this.start,
    required this.end,
    this.skipped,
  });

  factory StartEndIndex.fromJson(Map<String, dynamic> json) => StartEndIndex(
        start: json["start"],
        end: json["end"],
        skipped: json["skipped"]
      );

  Map<String, dynamic> toJson() {
    return {'start': start, 'end': end, 'skipped': skipped};
  }
}
