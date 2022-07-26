import 'package:flutter/material.dart';
import 'package:sqlite_project/sqlite/first_sqlite.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey=GlobalKey<FormState>();

  void _modalBottomSheetMenu(int ?id,String ?title,String ?description){
    TextEditingController titlecon=TextEditingController();
    TextEditingController descriptioncon=TextEditingController();
    if(id !=null){
      titlecon.text = title!;
      descriptioncon.text=description!;

    }
    Size size=MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        elevation: 100,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
          ),
        ),
        builder: (contex)=>SingleChildScrollView(
          child: Container(
            child: Padding(padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding:EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height:size.width*0.05),
                            TextField(
                              controller: titlecon,
                            ),
                            TextField(
                              controller: descriptioncon,
                            ),

                            InkWell(

                              onTap: (){
                                var title=titlecon.text.toString();
                                var des=descriptioncon.text.toString();
                                if(id==null){
                                  SQLiteHealper.insertData(title, des).then((value) =>
                                  {
                                    if(value != -1){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("value insert"))
                                      ),

                                    }else{

                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("value not inserted"))
                                      ),
                                    }
                                  }
                                  );
                                }else{
                                  SQLiteHealper.updatetData(id, title, des);
                                }

                                Navigator.of(context).pop(contex);
                                getDATA();
                              },
                                child: Padding(padding: EdgeInsets.all(10),
                                  child:Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(20)
                                    ),

                                    child:id==null? Text("CREATE NEW",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16),)
                                    :Text("Update date",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16),
                                  ),
                                )
                            ),
                            )],
                        )),
                  ],
                ),
              ),

            ),
          ),
        )

    );
  }

  List<Map<String,dynamic>> _dataList=[];
  getDATA()async{
    var list=await SQLiteHealper.getAlldata();
    setState((){
      _dataList=list;
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDATA();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sqlite first "),
      ),
      body: _dataList.isNotEmpty ? ListView.builder(
          itemCount: _dataList.length,
          itemBuilder: (BuildContext contex,int index){
            return ListTile(
              title: Text(_dataList[index]['title'].toString()),
              subtitle: Text(_dataList[index]['description'].toString()),
              trailing: Wrap(
                children: [
                  InkWell(
                    onTap: (){
                      _modalBottomSheetMenu(
                          _dataList[index]['id'],
                          _dataList[index]['title'].toString(),
                          _dataList[index]['description'].toString(),
                      );
                    },
                    child: Icon(Icons.add),
                  ),

                 SizedBox(
                   width: 20,
                 ),
                  InkWell(
                    onTap: (){
                      SQLiteHealper.deletData(_dataList[index]['id']);
                      getDATA();
                    },
                    child: Icon(Icons.delete),
                  ),

                ],
              ),
            );
          }):Center(child: Text("No data found"),),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _modalBottomSheetMenu(null,null,null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
