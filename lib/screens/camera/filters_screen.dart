import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final String placeholderImage = 'assets/images/filter_placeholder.png';

// List of filters with their respective ColorFilter matrices
  final List<Map<String, dynamic>> filters = [
    {
      "name": "Original",
      "filter": const ColorFilter.mode(
        Colors.transparent,
        BlendMode.srcOver,
      ),
      "filterStr": ''
    },
    {
      "name": "Sepia",
      "filter": const ColorFilter.matrix([
        0.393, 0.769, 0.189, 0, 0, //
        0.349, 0.686, 0.168, 0, 0, //
        0.272, 0.534, 0.131, 0, 0, //
        0, 0, 0, 1, 0, //
      ]),
      "filterStr": [
        0.393, 0.769, 0.189, 0, 0, //
        0.349, 0.686, 0.168, 0, 0, //
        0.272, 0.534, 0.131, 0, 0, //
        0, 0, 0, 1, 0, //
      ]
    },
    {
      "name": "Grayscale",
      "filter": const ColorFilter.matrix([
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0, //
        0, 0, 0, 1, 0, //
      ]),
      "filterStr": [
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0, //
        0, 0, 0, 1, 0, //
      ]
    },
    {
      "name": "Invert",
      "filter": const ColorFilter.matrix([
        -1, 0, 0, 0, 255, //
        0, -1, 0, 0, 255, //
        0, 0, -1, 0, 255, //
        0, 0, 0, 1, 0, //
      ]),
      "filterStr": [
        -1, 0, 0, 0, 255, //
        0, -1, 0, 0, 255, //
        0, 0, -1, 0, 255, //
        0, 0, 0, 1, 0, //
      ]
    },
  ];

  ColorFilter? selectedFilter;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          children: [
            // Filter Selection Area
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter['filter'];
                      });

                      Navigator.pop(context, filter);
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: selectedFilter == filter['filter']
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2),
                          ),
                          child: ColorFiltered(
                            colorFilter: filter['filter'] ??
                                const ColorFilter.mode(
                                    Colors.transparent, BlendMode.multiply),
                            child: Image.asset(placeholderImage,
                                fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(filter['name'],
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
