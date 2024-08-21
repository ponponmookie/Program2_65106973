import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';  // Import the Product class
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Product> products = []; // Initialize the list of products

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var url = Uri.https("fakestoreapi.com", "products");
    var response = await http.get(url);

    setState(() {
      products = productFromJson(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT@WU Shop'),
        backgroundColor: const Color.fromARGB(255, 181, 152, 231),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];
          var imgUrl = product.image ??
              'https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-20.jpg';

          return ListTile(
            title: Text(product.title ?? 'No Title'),
            subtitle: Text("\$${product.price?.toStringAsFixed(2) ?? '0.00'}"),
            leading: AspectRatio(
              aspectRatio: 1.0,
              child: Image.network(imgUrl),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailScreen(),
                  settings: RouteSettings(
                    arguments: product,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    var imgUrl = product.image ??
        'https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-20.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? 'Product Details'),
      ),
      body: SingleChildScrollView( // เพิ่ม SingleChildScrollView ตรงนี้
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(imgUrl),
              ),
              const SizedBox(height: 10),
              Text(
                product.title ?? '',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "\$${product.price?.toStringAsFixed(2) ?? '0.00'}",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Category: ${product.category ?? 'N/A'}",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Rating: ${product.rating?.rate?.toStringAsFixed(1) ?? '0.0'} / 5.0 (${product.rating?.count ?? 0} reviews)",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 5),
              RatingBar.builder(
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) => print(value),
                minRating: 0,
                itemCount: 5,
                allowHalfRating: true,
                direction: Axis.horizontal,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                initialRating: product.rating?.rate ?? 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



