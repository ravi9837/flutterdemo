import 'dart:convert';

List<FlowMain> questionsMainFromJson(str) => List<FlowMain>.from(
    (str).map((x) => FlowMain.fromJson(x.data())));

List<FlowMain> flowFromJson(String str) => List<FlowMain>.from(json.decode(str).map((x) => FlowMain.fromJson(x)));

//String flowToJson(List<Flow> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FlowMain {
  List<Elements>? elements;
  int? priority;
  String? flowId;
  String? flowName;

  FlowMain({
    this.elements,
    this.priority,
    this.flowId,
    this.flowName,
  });

  factory FlowMain.fromJson(Map<String, dynamic> json) => FlowMain(
    elements: json["elements"] != null ? List<Elements>.from(json["elements"].map((x) => Elements.fromJson(x))) : [],
    priority: json["priority"] ?? 0,
    flowId: json["flowId"] ?? "",
    flowName: json["flowName"] ?? "" ,
  );

// Map<String, dynamic> toJson() => {
// "elements": List<dynamic>.from(elements.map((x) => x.toJson())),
// "priority": priority,
// "flowId": flowId,
// "flowName": flowName,
// };
}

class Elements {
  List<Next> next;
  List<AgeGroup> ageGroupList;
  List genderGroupList;
  String navigationId;
  int kind;
  String id;
  String text;
  String? endId;
  String? startId;


  ///
  String? answer;
  String? previousId;
  String? prevSubFlowQuestion;

  Elements({
    required this.next,
    required this.ageGroupList,
    required this.genderGroupList,
    required this.navigationId,
    required this.kind,
    required this.id,
    required this.text,
    this.endId,
    this.startId,

    ///
    this.answer,
    this.previousId,
    this.prevSubFlowQuestion,


  });

  factory Elements.fromJson(Map<String, dynamic> json) => Elements(
    next: json["next"] !=null ? List<Next>.from(json["next"].map((x) => Next.fromJson(x))) :[],
    ageGroupList: json["ageGroupList"] !=null ? List<AgeGroup>.from(json["ageGroupList"].map((x) => AgeGroup.fromJson(x))) :[],
    genderGroupList: json["genderGroupList"] !=null ? List<dynamic>.from(json["genderGroupList"]):[],
    navigationId: json["navigationId"] ?? "",
    kind: json["kind"] ?? 0,
    id: json["id"] ?? "",
    text: json["text"] ?? "",
    endId: json["endId"] ?? "",
    startId: json["startId"] ?? "",
  );

// Map<String, dynamic> toJson() => {
// "next": List<dynamic>.from(next.map((x) => x.toJson())),
// "navigationId": navigationId,
// "kind": kind,
// "id": id,
// "text": text,
// "endId": endId,
// "startId": startId,
// };
}

class Next {
  String destElementId;

  Next({
    required this.destElementId,
  });

  factory Next.fromJson(Map<String, dynamic> json) => Next(
    destElementId: json["destElementId"],
  );

// Map<String, dynamic> toJson() => {
// "destElementId": destElementId,
// };
}


class AgeGroup {
  int start;
  int end;

  AgeGroup({
    required this.start, required this.end
  });

  factory AgeGroup.fromJson(Map<String, dynamic> json) => AgeGroup(
    start : json["start"], end: json["end"],
  );

// Map<String, dynamic> toJson() => {
// "destElementId": destElementId,
// };
}
