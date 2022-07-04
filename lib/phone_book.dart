import 'package:flutter/material.dart';
import 'package:lista_telefonica_app/components/contact_list_tile.dart';
import 'package:lista_telefonica_app/models/contact.dart';
import 'package:lista_telefonica_app/resources/strings.dart';
import 'package:lista_telefonica_app/utils/contact_helper.dart'
    as contact_helper;
import 'package:lista_telefonica_app/view_models/contact_view_model.dart';

class PhoneBook extends StatefulWidget {
  const PhoneBook({
    Key? key,
    required this.onThemeModePressed,
  }) : super(key: key);

  final VoidCallback onThemeModePressed;

  @override
  _PhoneBookState createState() => _PhoneBookState();
}

class _PhoneBookState extends State<PhoneBook> {
  final contacts = List<Contact>.from(contact_helper.longContactList)
    ..sort((a, b) => a.name.compareTo(b.name));
  final favorites = <Contact>[];

  void toggleFavorite(Contact contact) {
    setState(() {
      if (contact.isFavorite) {
        favorites.remove(contact);
      } else {
        favorites.add(contact);
      }
      contact.isFavorite = !contact.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text(Strings.appName),
        actions: [
          IconButton(
            onPressed: widget.onThemeModePressed,
            icon: Icon(
              theme.brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          )
        ],
      ),
      body: contacts.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (favorites.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(Strings.favorites),
                  ),
                  Expanded(
                      child: ListView.builder(itemBuilder: (context, index) {
                    final contact = favorites[index];
                    return buildListTile(context, index, contact);
                  })),
                ],
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(Strings.contacts),
                ),
                Expanded(
                  flex: 6,
                  child: ListView.builder(
                      itemBuilder: ((context, index) {
                        final contact = contacts[index];
                        return buildListTile(context, index, contact);
                      }),
                      itemCount: contacts.length),
                ),
              ],
            )
          : const Text('Lista vazia!'),
    );
  }

  Widget buildListTile(BuildContext context, int index, Contact contact) {
    final viewModel = ContactViewModel(contact);
    return ContactListTile(
        contactViewModel: viewModel,
        onItemPressed: () => toggleFavorite(contact));
  }
}
