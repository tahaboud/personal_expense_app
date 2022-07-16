import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  late final List? userTransactions;
  final Function deleteTransaction;
  TransactionList(this.userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return userTransactions!.isEmpty
        ? LayoutBuilder(builder: ((context, constraints) {
            return Column(
              children: [
                Text(
                  "No Transactions Added Yet!",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.1,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          }))
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                elevation: 5,
                child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                            child:
                                Text("\$${userTransactions![index].amount}")),
                      ),
                    ),
                    title: Text(
                      userTransactions![index].title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(DateFormat.yMMMd()
                        .format(userTransactions![index].date)),
                    trailing: MediaQuery.of(context).size.width > 460
                        ? TextButton.icon(
                            onPressed: () =>
                                deleteTransaction(userTransactions![index].id),
                            icon: Icon(Icons.delete),
                            label: Text("Delete"),
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                    Theme.of(context).errorColor)),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                deleteTransaction(userTransactions![index].id),
                            color: Theme.of(context).errorColor,
                          )),
              );
            },
            itemCount: userTransactions!.length,
          );
  }
}
