import 'package:flutter/material.dart';

class TabHomeNavigation extends StatelessWidget {
  const TabHomeNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
        onPressed: (){},
      ) ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Row(
                children: [
                  MaterialButton(onPressed: (){}, minWidth: 40, child: Column(

                    children: [
                      Icon(Icons.dashboard)
                    ],
                  ),),
                  MaterialButton(onPressed: (){}, minWidth: 40, child: Column(
                    children: [
                      Icon(Icons.dashboard)
                    ],
                  ),),
                  MaterialButton(onPressed: (){}, minWidth: 40, child: Column(
                    children: [
                      Icon(Icons.dashboard)
                    ],
                  ),),
                  MaterialButton(onPressed: (){}, minWidth: 40, child: Column(
                    children: [
                      Icon(Icons.dashboard)
                    ],
                  ),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
