import 'package:flutter/material.dart';
import 'app_router.dart';

void main() {
  runApp(BreakingBad(
    appRouter: AppRouter(),
  ));
}

class BreakingBad extends StatelessWidget {
  final AppRouter appRouter;

  const BreakingBad({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
