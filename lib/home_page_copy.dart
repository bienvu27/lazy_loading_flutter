import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePageCopy extends StatefulWidget {
  const HomePageCopy({Key? key}) : super(key: key);

  @override
  State<HomePageCopy> createState() => _HomePageCopyState();
}

class _HomePageCopyState extends State<HomePageCopy> {
  static int page = 0;
  final ScrollController _sc = ScrollController();
  bool isLoading = false;
  List users = [];
  final dio = Dio();

  @override
  void initState() {
    _getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels ==
          _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var url = "https://randomuser.me/api/?page=$index&results=20&seed=abc";
      print(url);
      final response = await dio.get(url);
      List tList = [];
      for (int i = 0; i < response.data['results'].length; i++) {
        tList.add(response.data['results'][i]);
      }

      setState(() {
        isLoading = false;
        users.addAll(tList);
        page++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Lazy Load Large List"),
      ),
      body: Container(
        child: _buildList(),
      ),

    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: users.length + 1, // Add one more item for progress indicator
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == users.length) {
          return _buildProgressIndicator();
        } else {
          return ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                users[index]['picture']['large'],
              ),
            ),
            title: Text((users[index]['name']['first'])),
            subtitle: Text((users[index]['email'])),
          );
        }
      },
      controller: _sc,
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}