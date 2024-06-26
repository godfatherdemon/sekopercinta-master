import 'package:flutter/material.dart';
import 'package:sekopercinta_master/providers/contributor.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class ContributorPage extends StatelessWidget {
  const ContributorPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: gradientA,
        ),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                centerTitle: true,
                pinned: false,
                expandedHeight: 190.0,
                backgroundColor: Colors.transparent,
                title: const Text(
                  'Detail Kontributor',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                flexibleSpace: const FlexibleSpaceBar(
                  background: SafeArea(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 70,
                        ),
                        Text(
                          'Kontributor\nSekopercinta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Card(
                        color: const Color(0xFFF4F7F9),
                        shadowColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pemerintah',
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/logo/mog.jpg',
                                      width: 120,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      'Ministry of Gender Equality and Family',
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: governmentContributors.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1 / 1,
                                ),
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Image.asset(
                                      governmentContributors[index].imagePath,
                                      width: 80,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      governmentContributors[index].name,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                'Aplikasi ini dibuat sebagai bagian dari Project ODA untuk mendukung Pemberdayaan Perempuan di Indonesia (2020 - 2024) yang didukung pula oleh Ministry of Gender Equality and Family of the Republic of Korea (MOGEF)',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Card(
                        color: const Color(0xFFF4F7F9),
                        shadowColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Akademisi',
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: academyContributors.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Image.asset(
                                      academyContributors[index].imagePath,
                                      width: 80,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      academyContributors[index].name,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Card(
                        color: const Color(0xFFF4F7F9),
                        shadowColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Media',
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: mediaContributors.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Image.asset(
                                      mediaContributors[index].imagePath,
                                      width: 80,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      mediaContributors[index].name,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Card(
                        color: const Color(0xFFF4F7F9),
                        shadowColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bisnis',
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: businessContributors.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Image.asset(
                                      businessContributors[index].imagePath,
                                      width: 80,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      businessContributors[index].name,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Card(
                        color: const Color(0xFFF4F7F9),
                        shadowColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Komunitas',
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: communityContributors.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 11 / 12,
                                ),
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Image.asset(
                                      communityContributors[index].imagePath,
                                      width: 80,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      communityContributors[index].name,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Card(
                        color: const Color(0xFFF4F7F9),
                        shadowColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Komunitas',
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: communityContributors.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 11 / 12,
                                ),
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Image.asset(
                                      communityContributors[index].imagePath,
                                      width: 80,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      communityContributors[index].name,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Card(
                        color: const Color(0xFFF4F7F9),
                        shadowColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Partnership',
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: partnerContributors.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 11 / 12,
                                ),
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Image.asset(
                                      partnerContributors[index].imagePath,
                                      width: 80,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      partnerContributors[index].name,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/bg-card-2.png',
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
