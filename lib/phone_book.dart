import 'package:flutter/material.dart';
import 'package:lista_telefonica_app/components/contact_grid_tile.dart';
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
  bool isGrid = false;

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

  void toggleGridMode() {
    setState(() {
      isGrid = !isGrid;
    });
  }

  SliverGridDelegateWithFixedCrossAxisCount get gridDelegate =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isGrid ? 2 : 1,
        childAspectRatio: isGrid ? 1 : 5,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
        actions: [
          IconButton(
            onPressed: toggleGridMode,
            icon: Icon(
              isGrid ? Icons.list : Icons.grid_on,
            ),
          ),
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
                    flex: isGrid ? 3 : 1,
                    child: GridView.builder(
                      key: const PageStorageKey(Strings.favorites),
                      gridDelegate: gridDelegate,
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final contact = favorites[index];
                        return buildListTile(contact);
                      },
                    ),
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(Strings.contacts),
                ),
                Expanded(
                  flex: 6,
                  child: GridView.builder(
                    key: const PageStorageKey(Strings.contacts),
                    gridDelegate: gridDelegate,
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return buildListTile(contact);
                    },
                  ),
                ),
              ],
            )
          : const Text(Strings.errorMessageEmptyList),
    );
  }

  Widget buildListTile(Contact contact) {
    final viewModel = ContactViewModel(contact);
    return isGrid
        ? ContactGridTile(
            contactViewModel: viewModel,
            onItemPressed: () => toggleFavorite(contact),
          )
        : ContactListTile(
            contactViewModel: viewModel,
            onItemPressed: () => toggleFavorite(contact),
          );
  }
}
