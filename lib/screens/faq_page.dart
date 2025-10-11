import 'package:flutter/material.dart';
import '../models/faq_model.dart';
import '../services/faq_service.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final FAQService _faqService = FAQService();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = [
    'general',
    'orders',
    'shipping',
    'payment',
    'other'
  ];

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context).locale;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأسئلة الشائعة'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'البحث في الأسئلة الشائعة...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Category filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('الكل'),
                        selected: _selectedCategory == null,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedCategory = null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ..._categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedCategory = selected ? category : null;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Display 5 mock FAQs
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final faq = FAQModel(
                  id: 'mock-$index',
                  question: 'Mock Question $index?',
                  answer:
                      'This is a mock answer for question $index. It provides details and solutions related to the question.',
                  order: index,
                  category: 'general',
                  translations: {},
                );
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    title: Text(
                      faq.getQuestion(locale.languageCode),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          faq.getAnswer(locale.languageCode),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
