import '../logic/router/my_router_delagate.dart';

void appLinkHandler(Uri link, MyRouterDelegate router) {
  final path = link.path;

  final list = path.split("/game/");

  if (list.length != 2) return;

  router.goToGamePage(list[1]);
}
