import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:news_demo/core/app_color.dart';
import 'package:news_demo/animations/loading_animation.dart';
import 'package:news_demo/models/article_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _offsetToArmed = 60.0;
  final categoryList = ['Follow', 'Recommendation', 'Discover', 'Hot', 'Video', 'Covid', 'Election'];
  int selectedIndex = 0;
  int newArticle = 0;

  @override
  Widget build(BuildContext context) {
    final dummyList =
        List.generate(20, (index) => Article('https://picsum.photos/250?image=$index', 'Article text $index', 'Source $index', index));
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'iPhone 15',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.add,
                          color: AppColor.primary,
                        ),
                      ),
                      const Text(
                        'Publish',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 5,
              color: Colors.white,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 25,
                    color: Colors.white,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(right: 10),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    categoryList[index],
                                    style: TextStyle(fontSize: 16, color: index == selectedIndex ? AppColor.primary : Colors.black),
                                  ),
                                  Container(
                                    height: 2,
                                    width: 10,
                                    color: index == selectedIndex ? AppColor.primary : Colors.transparent,
                                  ),
                                ],
                              ),
                            ));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 10,
                        );
                      },
                      itemCount: categoryList.length,
                    ),
                  ),
                ),
                Container(height: 25, color: Colors.white, child: const Icon(Icons.format_list_bulleted_rounded))
              ],
            ),
            Container(
              height: 5,
              color: Colors.white,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: CustomRefreshIndicator(
                  onRefresh: () => Future.delayed(const Duration(seconds: 5)),
                  onStateChanged: (IndicatorStateChange change) {
                    if (change.currentState == IndicatorState.finalizing && change.newState == IndicatorState.idle) {
                      setState(() {
                        newArticle = 5;
                        Future.delayed(const Duration(seconds: 5), () {
                          setState(() {
                            newArticle = 0;
                          });
                        });
                      });
                    }
                  },
                  builder: (BuildContext context, Widget child, IndicatorController controller) {
                    return AnimatedBuilder(
                      animation: controller,
                      child: child,
                      builder: (context, child) {
                        return Stack(
                          clipBehavior: Clip.hardEdge,
                          children: <Widget>[
                            if (!controller.side.isNone)
                              Container(
                                height: _offsetToArmed * controller.value,
                                color: const Color(0xFFFDFEFF),
                                width: double.infinity,
                                child: const LoadingAnimation(
                                  width: 30,
                                  height: 15,
                                ),
                              ),
                            Transform.translate(
                              offset: Offset(0.0, _offsetToArmed * controller.value),
                              child: child,
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    children: [
                      Visibility(
                        visible: newArticle != 0,
                        child: Text('$newArticle articles updated'),
                      ),
                      Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(5),
                          itemBuilder: (BuildContext context, int index) {
                            Article article = dummyList[index];
                            return Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Image.network(
                                        article.url,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    article.text,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.account_circle_outlined,
                                        size: 14,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          article.source,
                                          style: const TextStyle(fontSize: 14, color: AppColor.grey),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.thumb_up_alt_outlined,
                                        size: 14,
                                        color: AppColor.grey,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${article.like}',
                                        style: const TextStyle(fontSize: 14, color: AppColor.grey),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                          itemCount: dummyList.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
