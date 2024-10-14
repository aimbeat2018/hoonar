import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/color_constants.dart';
import '../../constants/theme.dart';
import '../../providers/auth_provider.dart';

class StateCityScreen extends StatefulWidget {
  final String? selectedStateId;
  final bool isState;
  final bool isDarkMode;

  const StateCityScreen(
      {super.key,
      this.selectedStateId,
      required this.isDarkMode,
      required this.isState});

  @override
  State<StateCityScreen> createState() => _StateCityScreenState();
}

class _StateCityScreenState extends State<StateCityScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isState) {
        Provider.of<AuthProvider>(context, listen: false).getFilteredStates('');
      } else {
        Provider.of<AuthProvider>(context, listen: false)
            .getFilteredCities('', widget.selectedStateId ?? '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stateList;
    if (widget.isState) {
      stateList = Provider.of<AuthProvider>(context).filteredStateList;
    } else {
      stateList = Provider.of<AuthProvider>(context).filteredCityList;
    }

    double halfScreenHeight = MediaQuery.of(context).size.height * 0.7;

    return SizedBox(
      height: halfScreenHeight, // Set the height to half of the screen
      child: Column(
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: GradientText(
                widget.isState
                    ? AppLocalizations.of(context)!.selectState
                    : AppLocalizations.of(context)!.selectCity,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: widget.isDarkMode ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      widget.isDarkMode ? Colors.white : Colors.black,
                      widget.isDarkMode ? Colors.white : Colors.black,
                      widget.isDarkMode ? greyTextColor8 : Colors.grey.shade700
                    ]),
              ),
            ),
          ),

          // Search TextField
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black,
                errorStyle: GoogleFonts.poppins(),
                border: GradientOutlineInputBorder(
                  width: 1,
                  gradient: LinearGradient(
                    colors: [
                      widget.isDarkMode ? Colors.white : Colors.black,
                      greyTextColor4
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                hintText: widget.isState
                    ? AppLocalizations.of(context)!.searchState
                    : AppLocalizations.of(context)!.searchCity,
                hintStyle: GoogleFonts.poppins(
                  color: hintGreyColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: textFieldGreyColor,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: textFieldGreyColor,
                    width: 1.0,
                  ),
                ),
              ),
              onChanged: (value) {
                if (widget.isState) {
                  Provider.of<AuthProvider>(context, listen: false)
                      .getFilteredStates(value);
                } else {
                  Provider.of<AuthProvider>(context, listen: false)
                      .getFilteredCities(value, widget.selectedStateId ?? '');
                }
              },
            ),
          ),

          // City List
          Expanded(
            child: stateList == null
                ? const Center(child: CircularProgressIndicator())
                : stateList.isEmpty
                    ? Center(
                        child: Text(
                        widget.isState
                            ? AppLocalizations.of(context)!.stateNotFound
                            : AppLocalizations.of(context)!.cityNotFound,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: stateList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () {
                              /*    if ((widget.selectedStateId == null ||
                                  widget.selectedStateId == "")) {*/
                              Navigator.pop(context, stateList[index]);
                              // }
                            },
                            title: Text(
                              stateList[index].name ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            // Customize the city item as needed
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
