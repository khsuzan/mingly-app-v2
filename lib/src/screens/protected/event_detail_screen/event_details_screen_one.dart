import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mingly/src/screens/protected/event_detail_screen/widget/custom_dialog_membership.dart';

class EventDetailsScreenOne extends StatelessWidget {
  const EventDetailsScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD1B26F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'High Club Mile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            color: Colors.grey.shade800,
            height: 2,
            width: double.infinity,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image carousel (static for now)
              SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'lib/assets/images/dummy_plane.png',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 8,
                      top: 80,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white70,
                        size: 24,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 80,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white70,
                        size: 24,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == 0 ? Colors.white : Colors.white24,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("lib/assets/icons/calendar.svg"),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          Text(
                            'Fri, 26 Jan 2025',
                            style: TextStyle(
                              color: const Color(0xFFFFFAE5),
                              fontSize: 14,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                            ),
                          ),
                          Text(
                            'Open gate at 20:00',
                            style: TextStyle(
                              color: const Color(0xFFB1A39E),
                              fontSize: 12,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      SvgPicture.asset("lib/assets/icons/Loc.svg"),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Outlet',
                            style: TextStyle(
                              color: const Color(0xFFFFFAE5),
                              fontSize: 14,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                            ),
                          ),
                          Text(
                            '[Address] City - Country',
                            style: TextStyle(
                              color: const Color(0xFFB1A39E),
                              fontSize: 12,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                'Description',
                style: TextStyle(
                  color: Color(0xFFD1B26F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Villagio restaurant and bar has one mission: to provide guests with a fine and fresh seafood experience. Featuring seasonal and sustainable seafood that is flown in fresh daily, our chef-driven menu proves that no matter when you\'re dining, seafood can ',
                style: TextStyle(color: Colors.white70),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Read More...',
                  style: TextStyle(color: Color(0xFFD1B26F), fontSize: 12),
                ),
              ),
              const SizedBox(height: 100),
              InkWell(
                onTap: ()=> showCustomDialog(context),
                child: Container(
                  width: double.infinity,
                  // height: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFF7D99A),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Book Ticket',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFF7D99A),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w600,
                      height: 1.43,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
