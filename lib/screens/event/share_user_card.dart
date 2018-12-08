import 'package:flutter/material.dart';

import 'package:youroccasions/models/user.dart';

class ShareUserCard extends StatelessWidget {
  final User user;
  final VoidCallback onSend;

  ShareUserCard({this.user, this.onSend}) 
    : assert(user != null);


  Widget _buildSendButton() {
    return FlatButton(
      color: Colors.grey[200],
      textColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      onPressed: onSend,
      child: SizedBox(
        child: Text(onSend == null ? "SENT" : "SEND")
      ),
    );
  }

  Widget _buildCard() {
    return ListTile(
      // onTap: _onTap,
      leading: CircleAvatar(
        backgroundImage: user.picture == null 
        ? AssetImage("assets/images/no-image.jpg")
        : NetworkImage(user.picture)
      ),
      title: Text(user.name),
      trailing: _buildSendButton(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

}