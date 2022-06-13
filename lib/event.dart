class Event {
  String? evid,
      evtitle,
      evdate,
      evtime,
      evvenue,
      evdescription,
      evparticipate,
      imgStatus;

  Event(
      {this.evid,
      this.evtitle,
      this.evdate,
      this.evtime,
      this.evvenue,
      this.evdescription,
      this.evparticipate,
      this.imgStatus});

//  Event.fromJson(Map<String, dynamic>json){
//     evid= json['evid'];
//       evtitle= json['evid'];
//       evdate= json['evdate'];
//       evtime= json['evtime'];
//       evvenue= json['evvenue'];
//       evdescription= json['evdescription'];
//       evparticipate= json['evparticipate'];
//       imgStatus= json[' imgStatus'];

//   }

//   Map<String, dynamic> toJson(){
//       final Map<String, dynamic> data = <String, dynamic>{};
//       data['evid'] = evid;
//       data['evtitle'] = evtitle;
//       data['evdate'] = evdate;
//       data['evtime'] = evtime;
//       data['evvenue'] = evvenue;
//       data['evdescription'] =  evdescription;
//       data['evparticipate'] =  evparticipate;
//         data['imgStatus'] =  imgStatus;
//       return data;
//    }


}
