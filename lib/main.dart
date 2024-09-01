import 'package:api_project/api_data_source.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const NewScreen(),
      theme: ThemeData.light(),
    );
  }
}

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  ApiDataSource api = ApiDataSource();
  List<NewsModel> news = [];
  int currentPage = 0;
  int limit = 10;
  bool isLoading = false;
  final ScrollController _scroollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
    _scroollController.addListener(() {
      if (_scroollController.position.pixels ==
          _scroollController.position.maxScrollExtent) {
        fetchData();
      }
    });
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    List<NewsModel> tempNews = await api.fetchNews(currentPage, limit);
    currentPage++;
    setState(() {
      news.addAll(tempNews);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News book'),
      ),
      body: ListView.builder(
        controller: _scroollController,
        itemCount: news.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == news.length) {
            return isLoading
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 50.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink();
          }
          final item = news[index];

          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  item.author ?? 'don\'t have author',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                InkWell(
                  onTap: () {
                    _launchUrl(item.url);
                  },
                  child: Text(
                    item.url,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _launchUrl(item.url),
                  child: const Text(
                    'Don\'t have  ',
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                item.urlToImage == null
                    ? const SizedBox.shrink()
                    : Image.network(item.urlToImage!),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  item.publishedAt,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  item.content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    Uri url0 = Uri.parse(url);

    if (!await launchUrl(url0)) {
      throw Exception('Could not launch $url0');
    }
  }
}
