class User {
  String? user_email, username, phoneno, type;

  User({
     this.user_email, 
     this.username, 
     this.phoneno, 
     this.type
  });

  // User.fromJson(Map<String, dynamic>json){
  //   user_email = json['user_email'];
  //   username = json['username'];
  //   phoneno = json['phoneno'];
  //   type = json['type'];
  // }

  //  Map<String, dynamic> toJson(){
  //     final Map<String, dynamic> data = <String, dynamic>{};
  //     data['user_email'] = user_email;
  //     data['username'] = username;
  //     data['phoneno'] = phoneno;
  //     data['type'] = type;
  //     return data;
  //  }
  }