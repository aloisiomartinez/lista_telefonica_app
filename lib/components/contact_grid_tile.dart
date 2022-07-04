import 'package:flutter/material.dart';
import 'package:lista_telefonica_app/view_models/contact_view_model.dart';

class ContactGridTile extends StatelessWidget {
  const ContactGridTile({
    Key? key,
    required this.contactViewModel,
    required this.onItemPressed,
  }) : super(key: key);

  final ContactViewModel contactViewModel;
  final VoidCallback onItemPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: GridTile(
        child: Stack(
          children: [
            Container(
              color: contactViewModel.backgroundColor,
              alignment: Alignment.center,
              child: Text(
                contactViewModel.identifier,
                style: TextStyle(
                  color: contactViewModel.foregroundColor,
                  fontSize: 24.0,
                ),
              ),
            ),
            if (contactViewModel.hasImage)
              Positioned.fill(
                child: Image(
                  image: contactViewModel.image!,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          title: Text(contactViewModel.name),
          subtitle: Text(contactViewModel.number),
          trailing: IconButton(
            onPressed: onItemPressed,
            icon: Icon(
              contactViewModel.favoriteIcon,
              color: contactViewModel.favoriteIconColor,
            ),
          ),
        ),
      ),
    );
  }
}