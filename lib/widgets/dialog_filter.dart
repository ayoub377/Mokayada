import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogFilter extends StatefulWidget {
  final method_mokayada;
  final method_achat;
  final Function() notifyParent;


  DialogFilter({Key? key,this.method_mokayada,this.method_achat,required this.notifyParent}) : super(key: key);

  @override
  State<DialogFilter> createState() => _DialogFilterState();
}

class _DialogFilterState extends State<DialogFilter> {
  bool isMokayad = false;
  bool isAchat = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dialog(
        child: Container(
          height: 200,
          child: Column(
            children: [
              Text("Filtrer par"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Mokayada"),
                    Checkbox(
                      value: isMokayad,
                      onChanged: (value){
                        setState(() {
                          isMokayad = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Achat"),
                    Checkbox(
                      value: isAchat,
                      onChanged: (bool? value) {
                        setState(() {
                          isAchat = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              ElevatedButton(onPressed: () async {
                if(isMokayad == true)
                {
                  widget.notifyParent();
                  await widget.method_mokayada();

                }
                if(isAchat == true)
                {
                  widget.notifyParent();
                  await widget.method_achat();
                }
                Navigator.pop(context);

              }, child: Text("Filtrer"))
            ],
          ),
        ),
      ));
  }
}
