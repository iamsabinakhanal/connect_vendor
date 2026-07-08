import 'package:flutter/material.dart';
import 'models/explore_tool_item.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedExploreCategoryIndex = 0;

  final List<String> _exploreCategories = [
    'All',
    'Screwdrivers',
    'Soldering',
    'Testing',
    'Screen Repair',
    'Accessories',
  ];

  final List<ExploreToolItem> _exploreItems = [
    ExploreToolItem(
      category: 'Screwdrivers',
      title: 'Precision Screwdriver Set 120-in-1',
      seller: 'ToolHub Nepal',
      likes: '31.3K',
      price: 'Rs. 2,450',
      icon: Icons.build,
      colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
    ),
    ExploreToolItem(
      category: 'Soldering',
      title: 'Quick Heat Soldering Station 60W',
      seller: 'FixMaster Store',
      likes: '14.8K',
      price: 'Rs. 4,900',
      icon: Icons.electrical_services,
      colors: [Color(0xFFF97316), Color(0xFFEA580C)],
    ),
    ExploreToolItem(
      category: 'Testing',
      title: 'Digital Multimeter with Probes',
      seller: 'Mobile Lab Supplies',
      likes: '19.3K',
      price: 'Rs. 1,850',
      icon: Icons.speed,
      colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
    ),
    ExploreToolItem(
      category: 'Screen Repair',
      title: 'LCD Separator Machine Mini',
      seller: 'Repair King',
      likes: '8.5K',
      price: 'Rs. 12,500',
      icon: Icons.tablet_android,
      colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
    ),
    ExploreToolItem(
      category: 'Accessories',
      title: 'Anti-Static ESD Mat + Wrist Strap',
      seller: 'SafeFix Tools',
      likes: '21.6K',
      price: 'Rs. 1,200',
      icon: Icons.shield,
      colors: [Color(0xFF22C55E), Color(0xFF15803D)],
    ),
    ExploreToolItem(
      category: 'Soldering',
      title: 'Lead-Free Solder Wire Pack',
      seller: 'Solder World',
      likes: '11.4K',
      price: 'Rs. 750',
      icon: Icons.cable,
      colors: [Color(0xFFFB7185), Color(0xFFBE123C)],
    ),
    ExploreToolItem(
      category: 'Testing',
      title: 'DC Power Supply 30V/5A',
      seller: 'Volt & Fix',
      likes: '9.9K',
      price: 'Rs. 8,200',
      icon: Icons.bolt,
      colors: [Color(0xFFF59E0B), Color(0xFFB45309)],
    ),
    ExploreToolItem(
      category: 'Screen Repair',
      title: 'Phone Opening Picks + Suction Kit',
      seller: 'Display Doctor',
      likes: '29.4K',
      price: 'Rs. 980',
      icon: Icons.phonelink_erase,
      colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final String selectedCategory =
        _exploreCategories[_selectedExploreCategoryIndex];
    final List<ExploreToolItem> visibleItems = selectedCategory == 'All'
        ? _exploreItems
        : _exploreItems
            .where((item) => item.category == selectedCategory)
            .toList();

    return Container(
      color: Color(0xFFF3F4F6),
      child: Column(
        children: [
          SizedBox(height: 8),
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: _exploreCategories.length,
              separatorBuilder: (_, index) => SizedBox(width: 8),
              itemBuilder: (context, index) {
                final bool isSelected = index == _selectedExploreCategoryIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedExploreCategoryIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFFE5E7EB) : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      _exploreCategories[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(12, 2, 12, 12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.67,
              ),
              itemCount: visibleItems.length,
              itemBuilder: (context, index) {
                final ExploreToolItem item = visibleItems[index];
                return GestureDetector(
                  onTap: () => _showActionMessage('${item.title} tapped'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: item.colors,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  item.icon,
                                  size: 68,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                bottom: 10,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      item.likes,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item.seller,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        item.price,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4338CA),
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

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
