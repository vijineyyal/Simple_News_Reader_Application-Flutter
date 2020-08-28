import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());

}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>  {

  List data;


  @override
  void initState() {
    super.initState();
    fetch_data_from_api();


  }



  Future<String> fetch_data_from_api() async {
    var jsondata = await http.get(
    "http://newsapi.org/v2/everything?q=tech&apiKey=e9c1071c1903447ea6f5b7e9fcba5650");
    var fetchdata = jsonDecode(jsondata.body);
    setState(() {
      data = fetchdata["articles"];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "News App",
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.home,color: Color(0xFF545D68)),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'News On-The-Go',
                style: TextStyle(
                    fontFamily: 'Varela',fontSize: 20.0,color: Colors.amber),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications_none,color: Color(0xFF545D68)),
                  onPressed: (){},
                )
              ],
            ),
            body:            Padding(
              padding: EdgeInsets.only(top: 30.0),


              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                author: data[index]["author"],
                                title: data[index]["title"],
                                description: data[index]["description"],
                                urlToImage: data[index]["urlToImage"],
                                publishedAt: data[index]["publishedAt"],
                              )));
                    },
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35.0),
                              topRight: Radius.circular(35.0),
                            ),
                            child: Image.network(
                              data[index]["urlToImage"],
                              fit: BoxFit.cover,
                              height: 400.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 350.0, 0.0, 0.0),
                          child: Container(
                            height: 200.0,
                            width: 400.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(35.0),
                              elevation: 10.0,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 10.0, 20.0),
                                    child: Text(
                                      data[index]["title"],
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                ],

                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: data == null ? 0 : data.length,
                autoplay: true,
                viewportFraction: 0.8,
                scale: 0.9,
                duration: 2000,
              ),

            ),

        ));
  }
}



class DetailsPage extends StatefulWidget {
  String title, author, urlToImage, publishedAt, description;

  DetailsPage(
      {this.title,
        this.author,
        this.description,
        this.publishedAt,
        this.urlToImage});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Color(0xFF545D68)),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'News On-The-Go',
          style: TextStyle(
              fontFamily: 'Varela',fontSize: 20.0,color: Color(0xFF545D68)),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none,color: Color(0xFF545D68)),
            onPressed: (){},
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: <Widget>[
            Image.network(
              widget.urlToImage,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 350.0, 0.0, 0.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Material(
                  borderRadius: BorderRadius.circular(35.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        widget.publishedAt.substring(0, 10),
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      Text(
                        widget.author,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}