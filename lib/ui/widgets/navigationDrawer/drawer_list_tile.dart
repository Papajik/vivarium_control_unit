import 'package:flutter/material.dart';

class DrawerListTile extends StatefulWidget {
  final String? title;
  final IconData? icon;
  final bool isSelected;
  final Function? onTap;
  final bool isActive;

  const DrawerListTile(
      {Key? key,this.isActive = true, this.title, this.icon, this.isSelected = false, this.onTap})
      : super(key: key);

  @override
  _DrawerListTileState createState() => _DrawerListTileState();
}

class _DrawerListTileState extends State<DrawerListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        widget.onTap!();
      },
      child: Container(
          // width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: widget.isSelected
                  ? Colors.transparent.withOpacity(0.3)
                  : Colors.transparent),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(widget.icon, size: 30, color: widget.isActive? Colors.white:Colors.grey.shade500),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: SizedBox(
                    child: Text(
                      widget.title!,
                      style: TextStyle(color: widget.isActive? Colors.white:Colors.grey.shade500, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
