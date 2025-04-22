import 'package:flutter/material.dart';


class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppbar({required this.onsearch,super.key});
  final Function(String) onsearch;
  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  bool isSearching = false;
  TextEditingController _controller = new TextEditingController();
  

  

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      
      title:
          isSearching
              ? TextField(
                
                controller: _controller,
                autofocus: true,
                style: TextStyle(color: Colors.white,backgroundColor: Colors.transparent),
                decoration: InputDecoration(
                  
                  hintText: 'Enter city name',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                onSubmitted: (city){
                  widget.onsearch(city);
                },
              )
              : Text("WeatherApp",style: TextStyle(color: Colors.white),),

      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              if (isSearching) {
                isSearching = false;
                _controller.clear();
              } else {
                isSearching = true;
              }
            });
          },
          icon: Icon(isSearching ? Icons.clear : Icons.search , color: Colors.white,),
        ),
      ],
    );
  }
}
