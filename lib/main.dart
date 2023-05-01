import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(248, 231, 162, 1),
        appBar: AppBar(
          title: const Text('Country Information App'),
          backgroundColor: const Color.fromARGB(69, 80, 84, 1),
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var desc = "No records found",
      capital = '',
      currencyName = '',
      currencyCode = '',
      gdp = 0.0,
      population = 0.0,
      surfaceArea = 0.0,
      iso = '';
    TextEditingController select = TextEditingController();

    @override
  Widget build(BuildContext context) {
    ButtonStyle style;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(iso.isNotEmpty)
          Image.network("https://flagsapi.com/$iso/shiny/64.png",scale: 0.5,),
          const Text("Country Information",
          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),

          TextField(
            controller: select,
            decoration: const InputDecoration(
              hintText: "Search Contry",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5
                )
              )
            ),
          ),

          ElevatedButton(
            onPressed: _getInfo, 
            style: style = ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(252, 243, 207, 1)),
            child: const Text("Load Information")),

            Text(desc, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

Future<void> _getInfo() async {
    String country = select.text;
    var apiid = "jJ0Y1ZYyG/28WMOn8HLtRA==QE5lite9QGWELNBd";
    var url = Uri.parse('https://api.api-ninjas.com/v1/country?name=$select');
    var response = await http.get(url, headers: {'X-Api-Key': apiid });
    var rescode = response.statusCode;
    if (rescode == 200) {
      try{
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        capital = parsedJson[0]['capital'];
        currencyName = parsedJson[0]['currency']['name'];
        currencyCode = parsedJson[0]['currency']['code'];
        gdp = parsedJson[0]['gdp'];
        population = parsedJson[0]['population'];
        surfaceArea = parsedJson[0]['surface_area'];
        iso = parsedJson[0]['iso2'];
        desc = 
        "Name = $country \nCapital = $capital \nCurrency Name = $currencyName \nCurrency Code = $currencyCode \nGDP = $currencyCode $gdp \nPopulation = $population \nSurface area = $surfaceArea m2 ";
      });
      
    } catch(e){
        setState(() {
          desc = "No record found";
        });
      }
      } else if(select.text.isEmpty){
        setState(() {
          desc = "Please enter a country name!";
        });
    }
    
    else {
      setState(() {
        desc = "No record found";
           iso = "";

      });
    }
  }
}