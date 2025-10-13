import 'package:flutter/material.dart';
import 'package:store/l10n/app_localizations.dart';
import '../models/faq_model.dart';
import '../services/faq_service.dart';

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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final List<String> _categories = [
      loc.faqCategoryGeneral,
      loc.faqCategoryOrders,
      loc.faqCategoryShipping,
      loc.faqCategoryPayment,
      loc.faqCategoryOther
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.faq),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: loc.searchInFAQ,
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

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: Text(loc.all),
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
              itemCount: 5,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final faq = FAQModel(
                  id: 'mock-$index',
                  question: loc.mockQuestion(index),
                  answer:
                      loc.mockAnswer(index),
                  order: index,
                  category: 'general',
                  translations: {},
                );
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    title: Text(
                      faq.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          faq.answer,
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
