import 'package:flutter/material.dart';

// model for Tea
class Tea {
  final String name;
  int sugarAmount;
  String milkType;
  String image;

  Tea(this.name, this.sugarAmount, this.milkType, this.image);
}

// Create a class to manage the state using ChangeNotifier
class Cart extends ChangeNotifier {
  List<Tea> _teas = [];

  List<Tea> get teas => _teas;

  void addToCart(Tea tea) {
    _teas.add(tea);
    notifyListeners(); // Notify listeners that the data has changed
  }

  void removeFromCart(int index) {
    _teas.removeAt(index);
    notifyListeners();
  }

  int getTotalTeasInCart(Cart cart) {
    return cart.teas.length;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tea Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _navigateToMainScreen();
  }

  _navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 4));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TeaSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assect/masala.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Chai Wai',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800]),
            ),
          ],
        ),
      ),
    );
  }
}

class TeaSelectionPage extends StatefulWidget {
  @override
  _TeaSelectionPageState createState() => _TeaSelectionPageState();
}

class _TeaSelectionPageState extends State<TeaSelectionPage> {
  Cart cart = Cart();

  int sugarAmount = 5; // Default  amount
  String selectedMilkType = 'Regular'; // Default type

  void _customizeTea(Tea tea) {
    int sugarAmountLocal = sugarAmount;
    String selectedMilkTypeLocal = selectedMilkType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Addons'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Sugar Amount: $sugarAmountLocal'),
                  Slider(
                    activeColor: Colors.brown[300],
                    value: sugarAmountLocal.toDouble(),
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: sugarAmountLocal.toString(),
                    onChanged: (double value) {
                      setState(() {
                        sugarAmountLocal = value.round();
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedMilkTypeLocal,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMilkTypeLocal = newValue!;
                      });
                    },
                    items: <String>[
                      'Regular',
                      'Skimmed',
                      'Soy',
                      'Almond',
                      'Ice',
                      'Hot Water'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final selectedTea = Tea(tea.name, sugarAmountLocal,
                        selectedMilkTypeLocal, tea.image);
                    setState(() {
                      cart.addToCart(selectedTea);
                    });
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            backgroundColor: Colors.brown[50],
                            title:
                                Text('Tea added to cart: ${selectedTea.name}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.brown[700],
                                    ))));
                  },
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[550],
      drawer: Drawer(
        child: ListView(
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'GeeksforGeeks',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
            ),
            ListTile(
              title: Text('Item 2'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Choose your Tea'),
        backgroundColor: Colors.brown[600],
      ),
      body: ListView.builder(
        itemCount: availableTeas.length,
        itemBuilder: (context, index) {
          final tea = availableTeas[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(tea.name),
              leading: Image.asset(tea.image),
              onTap: () {
                _customizeTea(tea);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.brown[100],
        backgroundColor: Colors.brown[600],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(cart: cart),
            ),
          );
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final Cart cart;

  CartPage({required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' Your Cart',
        ),
      ),
      body: ListView.builder(
        itemCount: widget.cart.teas.length,
        itemBuilder: (context, index) {
          final tea = widget.cart.teas[index];
          return Card(
            color: Colors.brown[200],
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: Text(tea.name),
              leading: Image.asset(tea.image),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sugar Amount: ${tea.sugarAmount}'),
                  Text('Addon Type: ${tea.milkType}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    widget.cart.removeFromCart(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

List<Tea> availableTeas = [
  Tea('Black Tea', 7, 'Skimmed', 'assect/black-tea.png'),
  Tea('Herbal Tea', 3, 'Soy', 'assect/masala.png'),
  Tea('Ice Tea', 3, 'Soy', 'assect/iced-coffee.png'),
  Tea('lemon Tea', 3, 'Soy', 'assect/tea-cup.png'),
];
