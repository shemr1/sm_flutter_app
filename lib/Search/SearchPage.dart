
import 'package:algolia/algolia.dart';


import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key,} ) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
   static TextEditingController _searchText;
  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;



  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Search",
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(children: <Widget>[
                  TextField(
                    controller: _searchText,
                    style: new TextStyle(color: Colors.black, fontSize: 20),
                    decoration: new InputDecoration(
                        suffix: IconButton(
                          icon: Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                          onPressed: _search,
                        ),
                        border: InputBorder.none,
                        hintText: 'Search ...',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                  ),
                  Expanded(
                    child: _searching == true
                        ? Center(
                            child: Text("Searching, please wait..."),
                          )
                        : _results.length == 0
                            ? Center(
                                child: Text("No results found."),
                              )
                            : Column(
                              children: [
                                Text("Results found for " + _searchText.text.trim() + ". " + _results.length.toString() + "results"),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: _results.length,
                                      itemBuilder: (BuildContext ctx, int index) {
                                        AlgoliaObjectSnapshot snap = _results[index];

                                        return ListTile(
                                          leading: CircleAvatar(
                                            child: Text(
                                              (index + 1).toString(),
                                            ),
                                          ),
                                          title: Text(snap.data["title"]),
                                          subtitle: Text(snap.data["description"]),
                                        );
                                      },
                                    ),
                                ),
                              ],
                            ),
                  ),
                ]),
              ),
            )));
  }

  _search() async {
    setState(() {
      _searching = true;
    });

    Algolia algolia = Algolia.init(
      applicationId: 'VH9WYM6W1F',
      apiKey: '7a39e5602e5a80c07f44b9ee9fd4b98a',
    );

    AlgoliaQuery query = algolia.instance.index('Services_dev');
    query = query.query(_searchText.text);

    _results = (await query.getObjects()).hits;

    setState(() {
      _searching = false;

    });

  }
}


