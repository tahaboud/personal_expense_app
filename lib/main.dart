import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Personal Expenses",
        home: MyHomePage(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple,
            secondary: Colors.amber,
          ),
          fontFamily: "QuickSand",
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
            fontFamily: "OpenSans",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
          textTheme: ThemeData.light().textTheme.copyWith(
                titleMedium: const TextStyle(
                  fontFamily: "Open Sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
          buttonTheme: ButtonThemeData(
              colorScheme: Theme.of(context)
                  .colorScheme
                  .copyWith(secondary: Colors.white)),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: "0",
    //   title: "New Shoes",
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "1",
    //   title: "Weekly Groceries",
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(
            days: 7,
          ),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: chosenDate,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLanscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text(
        "Personal Expenses",
        style: TextStyle(fontFamily: "Open Sans"),
      ),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: const Icon(Icons.add),
        )
      ],
    );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: Expanded(
          child: TransactionList(_userTransactions, _deleteTransaction)),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLanscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Show Chart"),
                    Switch(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      },
                    )
                  ],
                ),
              if (!isLanscape)
                Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(_recentTransactions),
                ),
              if (!isLanscape) txListWidget,
              if (isLanscape)
                _showChart
                    ? Container(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.7,
                        child: Chart(_recentTransactions),
                      )
                    : txListWidget
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
