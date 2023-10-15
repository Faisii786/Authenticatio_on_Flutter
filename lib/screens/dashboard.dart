import 'package:apple_ui/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final String unsplashApiKey =
      'L3sEEOreLhkqLGRjoMZfERRiWxNK6k7L9_nzdUQYkxA'; // Replace with your API key
  final String unsplashApiUrl = 'https://api.unsplash.com';
  int page = 1; // Initialize the page number
  List<Map<String, dynamic>> images = [];

  bool isLoading = false; // Add a flag to track loading state

  @override
  void initState() {
    super.initState();
    fetchUnsplashImages();
  }

  Future<void> fetchUnsplashImages() async {
    setState(() {
      isLoading = true; // Set loading to true when fetching starts
    });
    final response = await http.get(
      Uri.parse(
          '$unsplashApiUrl/photos?page=$page&per_page=10'), // Adjust per_page as needed
      headers: {
        'Authorization': 'Client-ID $unsplashApiKey',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> fetchedImages =
          List<Map<String, dynamic>>.from(data);
      setState(() {
        images.addAll(fetchedImages); // Add the new images to the existing list
        page++; // Increment the page number for the next request
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false; // Set loading to false if there's an error
      });
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Unsplash"),
          //automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    images.clear(); // Clear the existing images
                    page = page++; // Reset the page number
                  });
                  fetchUnsplashImages();
                },
                icon: Icon(Icons.refresh)),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  'Faisal Aslam',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                accountEmail: Text(
                  'faisalaslam218@gmail.com',
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                leading: const Icon(
                  Icons.home,
                ),
                title: const Text(
                  "Home",
                ),
              ),
              const Divider(
                height: 10,
              ),
              const ListTile(
                leading: Icon(
                  Icons.person,
                ),
                title: Text(
                  "Profile",
                ),
              ),
              const Divider(
                height: 10,
              ),
              const Divider(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  });
                },
                leading: const Icon(
                  Icons.logout,
                ),
                title: const Text(
                  "Logout",
                ),
              ),
            ],
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    images[index]['urls']
                        ['small'], // You can choose from different image sizes
                    fit: BoxFit.cover,
                  );
                },
              ),
      ),
    );
  }
}
