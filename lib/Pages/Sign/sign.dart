import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotc/Pages/Sign/signin.dart';
import 'package:kotc/Pages/Sign/signup.dart';

class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                children: [
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        text: "Sign in".tr,
                      ),
                      Tab(
                        text: "Sign up".tr,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  Signin(),
                  Signup(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
