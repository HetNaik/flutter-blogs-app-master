import 'package:blog_app/service/crud_ope.dart';
import 'package:cached_network_image/cached_network_image.dart';
 import 'package:flutter/material.dart';

import '../constants.dart';
import 'blog_create.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();
  Stream blogsStream;
  // ignore: non_constant_identifier_names
  Widget BlogsList() {
    return Container(
        child: blogsStream != null
            ? Column(
                children: [
                  StreamBuilder(
                      stream: blogsStream,
                      builder: (context, snapshot) {
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return BlogsTile(
                              authorName: snapshot
                                  .data.documents[index].data['authorName'],
                              imgUrl:
                                  snapshot.data.documents[index].data['imgUrl'],
                              title:
                                  snapshot.data.documents[index].data['title'],
                              description:
                                  snapshot.data.documents[index].data['desc'],
                            );
                          },
                          itemCount: snapshot.data.documents.length,
                        );
                      })
                ],
            )
            : Center(child: CircularProgressIndicator()));
  }

  @override
  void initState() {
    super.initState();
    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tech', style: TextStyle(color: hRd)),
            Text(
              'Blog',
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlogsList(),
      floatingActionButton: Container(
        //margin: EdgeInsets.all(10),
        // color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreateBlog()));
                  })),
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String imgUrl, title, description, authorName;
  BlogsTile(
      {@required this.authorName,
      @required this.title,
      @required this.description,
      @required this.imgUrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      margin: EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(imageUrl:imgUrl,
                  width: MediaQuery.of(context).size.width, fit: BoxFit.cover)),
          Container(
              height: 170,
              decoration: BoxDecoration(
                  color: Colors.black45.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6))),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  Text(authorName),
                ],
              ))
        ],
      ),
    );
  }
}
