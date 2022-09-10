import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';


import 'Category.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({Key key, this.allTextList, this.selectedUserList})
      : super(key: key);
  final List<Category> allTextList;
  final List<Category> selectedUserList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter list Page"),
      ),
      body: SafeArea(
        child: FilterListWidget<Category>(
          themeData: FilterListThemeData(context),
          hideSelectedTextCount: true,
          controlButtons: [ContolButtonType.All, ContolButtonType.Reset],
          selectedListData: selectedUserList,
          onApplyButtonClick: (list) {
            Navigator.pop(context, list);
          },
          choiceChipLabel: (item) {
            /// Used to print text on chip
            return item.name;
          },
          // choiceChipBuilder: (context, item, isSelected) {
          //   return Container(
          //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //     decoration: BoxDecoration(
          //         border: Border.all(
          //       color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
          //     )),
          //     child: Text(item.name),
          //   );
          // },
          validateSelectedItem: (list, val) {
            ///  identify if item is selected or not
            return list.contains(val);
          },
          onItemSearch: (user, query) {
            /// When search query change in search bar then this method will be called
            ///
            /// Check if items contains query
            return user.name.toLowerCase().contains(query.toLowerCase());
          },
        ),
      ),
    );
  }
}
