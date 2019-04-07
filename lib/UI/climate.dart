import 'package:flutter/material.dart';
import '../utils/utils.dart' as util;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


class climate extends StatefulWidget {
  @override
  _climateState createState() => _climateState();
}

class _climateState extends State<climate> {
  var _location = util.defaultCity;
  
  Future navigateCity(BuildContext context)async{
    Map result = await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context){
      return secondScreen();
      })
    );
      if(result!= null && result.containsKey("enter")){
        _location = result["enter"];
      }else {
        _location = util.defaultCity;
      }

  }
  Future<Map>getWeather(String appId , String city)async{
    String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appid}&units=metric";
    http.Response response = await http.get(apiUrl);
    return jsonDecode(response.body);
  }


//  void display ()async{
//    Map object = await getWeather(util.defaultCity, util.appid);
////    print(object.toString());
//  }

  Widget tempBuilder (String place){
    return new FutureBuilder(
      future: getWeather(util.appid, place == null ? util.defaultCity : place),
        builder:(BuildContext context,AsyncSnapshot <Map>snapshot){
          if(snapshot.hasData)
            {
              Map content = snapshot.data;
              return new Container(

                child:new Center(
                child: new Column(
                  children: <Widget>[
                    new ListTile(


                      title: new Text(content['main']['temp'].toString()+ "°C",
                        style: infoStyle(),),
                      subtitle:new ListTile(
                        title: new Text("Humidity:${content['main']['humidity'].toString()}"+
                            "\nMin temp:${content['main']['temp_min'].toString()}"+
                            "\nMax temp:${content['main']['temp_max'].toString()}",
                          style:subtitleStyle(),

                        ),
                      ) ,
                    )




                  ],
                ),
                ));


            }else {
            new Container(
              child: new Text(""),
            );
          }

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar:AppBar(title: Text("Weather App"),
      backgroundColor: Colors.black54,
      centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon:Icon(Icons.menu),
              onPressed:()=> navigateCity(context),
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[

          new Center(

            child: new Opacity(
              opacity: 0.9,
            child: new Image.asset("images/umbrella.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,

            ),
            )

          ),
          new Container(

            child: new Text(_location == null ? util.defaultCity : _location,
            style: climateStyle(),
            ),

            alignment: Alignment.topRight,
            margin:  const EdgeInsets.fromLTRB(0.0, 12.5, 20.9, 0.0),


          ),

          new Container(
            alignment: Alignment.center,
            child: Image.asset("images/light_rain.png"),

          ),
          new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.5)),
          new Container(
            height: (MediaQuery.of(context).size.height)/1.45,
            width: MediaQuery.of(context).size.width,
//            margin: const EdgeInsets.fromLTRB(50.0, 400.0, 0.0, 0.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,


              children: <Widget>[
                tempBuilder(_location),
//                new Text("${content['main']['humidity'].toString()}")
    ],
    )
          )
        ],
      ),
          
    );
  }
}

climateStyle(){
  return new TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 28.0,
    fontStyle: FontStyle.italic
  );
}

infoStyle(){
  return new TextStyle(color: Colors.white,fontStyle: FontStyle.normal,fontSize: 50.0);
}
subtitleStyle(){
  return new TextStyle(color: Colors.white70,fontStyle: FontStyle.normal,fontSize: 20.0);
}

class secondScreen extends StatelessWidget {
  var _secondControl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: new Text("Change the city"),
      centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      
      body: new Stack(
        children: <Widget>[
          Center(
            child:
            new Opacity(
              opacity: 1.0,
                child: new Image.asset("images/white_snow.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            )),
          ),
          new Container(
            margin: EdgeInsets.all(5.5),
            child: new Column(
              children:<Widget>[
                Padding(padding: EdgeInsets.all(5.5)),
                
                new TextField(
                    controller: _secondControl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      icon: Icon(Icons.location_city),
                    hintText: "Enter the city name"
                    ),
                ),
                Padding(padding: EdgeInsets.all(5.5)),
                new FlatButton(onPressed: (){
                      Navigator.pop(context,{
                        "enter": _secondControl.text
                      });
                    },
                    child:new Text("Change"),
                    color: Colors.black54,
                ),
              ]
            )
          )

        ],
      ),
    );
  }
}
