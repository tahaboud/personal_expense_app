import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  late final List? userTransactions;
  final Function deleteTransaction;
  TransactionList(this.userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: userTransactions!.isEmpty
            ? Column(
                children: [
                  Text(
                    "No Transactions Added Yet!",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    child: Image.asset(
                      "assets/images/waiting.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
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
                                child: Text(
                                    "\$${userTransactions![index].amount}")),
                          ),
                        ),
                        title: Text(
                          userTransactions![index].title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(DateFormat.yMMMd()
                            .format(userTransactions![index].date)),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              deleteTransaction(userTransactions![index].id),
                          color: Theme.of(context).errorColor,
                        )),
                  );
                },
                itemCount: userTransactions!.length,
              ));
  }
}
