import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  double? _numberFrom;
  String? _startMeasure;
  String? _convertedMeasure;
  String? _resultMessage;
  final TextStyle inputStyle = TextStyle(
    fontSize: 20,
    color: Colors.blue[900],
  );
  final TextStyle labelStyle = TextStyle(
    fontSize: 24,
    color: Colors.grey[700],
  );

  final List<String> _measures = [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feets',
    'miles',
    'pounds (lbs)',
    'ounces',
  ];


  final Map<String,int> _measuresMap = {
    'meters':0,
    'kilometers':1,
    'grams':2,
    'kilograms':3,
    'feets':4,
    'miles':5,
    'pounds (lbs)':6,
    'ounces':7,
  };

  final Map<String,dynamic> _formulas = {
    '0':[1,0.0001,0,0,3.28084,0.00062,0,0],
    '1':[1000,1,0,0,3280.84,0.62137,0,0],
    '2':[0,0,1,0.0001,0,0,0.0022,0.03527],
    '3':[0,0,1000,1,0,0,2.20462,35.274],
    '4':[0.304,0.003,0,0,1,0.00019,0,0],
    '5':[1609.34,1.60934,0,0,5280,1,0,0],
    '6':[0,0,453.592,0.45359,0,0,1,16],
    '7':[0,0,28.3495,0.02835,0,0,0.0625,1],
  };

  void convert(double value,String from,String to){
    int nFrom = _measuresMap[from] as int;
    int nTo = _measuresMap[to] as int;
    var multiplier = _formulas[nFrom.toString()][nTo];
    var result = value * multiplier;

    if(result == 0){
      _resultMessage = 'This message cannot be performed';
    }else{
      _resultMessage = '${_numberFrom.toString()} $_startMeasure are ${result.toString()} $_convertedMeasure';
    }
    setState(() {
      _resultMessage = _resultMessage;
    });
  }

  @override
  void initState() {
    _numberFrom = 0;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      home: Scaffold(
        appBar: AppBar(title: Text('Measures Converter'),),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,),
          child: SingleChildScrollView(
            child: Column(
            children: [
             SizedBox(height: 20,),
              Text('Value',style: labelStyle,),
              SizedBox(height: 30,),
              TextField(
                decoration: InputDecoration(border: OutlineInputBorder(),hintText: 'Please insert the measure to be converted'),
                onChanged: (value){
                  var rv = double.tryParse(value);
                  if(rv != null){
                    setState(() {
                      _numberFrom = rv;
                    });
                  }
                  if(rv == null){
                    setState(() {
                      _numberFrom = 0.0;
                    });
                  }
                },
              ),
             SizedBox(height: 20,),
              Text('From',style: labelStyle,),
              DropdownButton(
                  isExpanded: true,
                  value: _startMeasure,
                  items: _measures.map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
              )).toList(),
                  onChanged: (value){
                    setState((){
                      _startMeasure = value;
                    });
                  }),
              SizedBox(height: 20,),
              Text('To',style: labelStyle,),
              DropdownButton(
                isExpanded: true,
                  value: _convertedMeasure,
                  items: _measures.map((String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  )).toList(),
                  onChanged: (value){
                    setState((){
                      _convertedMeasure = value;
                    });
                  }),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                if(_startMeasure!.isEmpty || _convertedMeasure!.isEmpty || _numberFrom == 0){
                  return;
                }else{
                  convert(_numberFrom as double, _startMeasure.toString(), _convertedMeasure.toString());
                }
              }, child: Text('Convert',style: inputStyle,),),
              SizedBox(height:30,),
              Text((_resultMessage == null? '' : _resultMessage.toString()),style: labelStyle,),
              SizedBox(height:30,),
            ],
             ),
          ),
        ),
      ),
    );
  }
}
