// final class OrderHistoryList extends StatelessWidget {
//   late final List<Order> _orders;
//   final OrderController orderController = Get.find();
//   final FirebaseAnalytics? analytics;
//   final FirebaseAnalyticsObserver? observer;
//   final scrollController = ScrollController();
//
//   OrderHistoryList({this.analytics, this.observer, super.key});
//   /* if (orderController.page.value == 1) {
//       _orders = orderController.activeOrderList!;
//     } else {
//       _orders = orderController.completedOrderList;
//     }
//   }*/
//
//   List<Order> get orders => orderController.page.value == 1
//       ? orderController.completedOrderList
//       : /orderController.activeOrderList!/[];
//
//   List<Order> get orders1 => orderController.page1.value == 1
//       ? orderController.activeOrderList! : [];
//   /: orderController.completedOrderList;/
//
//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         await _onRefresh();
//       },
//       child: SingleChildScrollView(
//         controller: scrollController,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             children: [
//               /*orders.isEmpty || orders1.isEmpty
//                   ? SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.6,
//                       child: const Center(
//                         child: Text(
//                           "No Orders found",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                     )
//                   : */
//               if (orders.isNotEmpty)
//                 ListView.builder(
//                   shrinkWrap: true,
//                   itemCount:orderController.page.value == 1? orderController.completedOrderList.length : orderController.activeOrderList.length,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, i) {
//                     return Column(
//                       children: [
//                         OrderHistoryCard(
//                           analytics: analytics,
//                           observer: observer,
//                           order: orders[i],
//                           index: i,
//                         ),
//                         const SizedBox(height: 8),
//                       ],
//                     );
//                   },
//                 ),
//               if (orders1.isNotEmpty)
//                 ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: /_orders.length/ orders1.length,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, i) {
//                     return Column(
//                       children: [
//                         OrderHistoryCard(
//                           analytics: analytics,
//                           observer: observer,
//                           // order: _orders[i],
//                           order: orders1[i],
//                           index: i,
//                         ),
//                         const SizedBox(height: 8),
//                       ],
//                     );
//                   },
//                 ),
//               orderController.isMoreDataLoaded.value == true
//                   ? const SizedBox(
//                   child: CircularProgressIndicator(
//                     color: ColorConstants.contBlueColor,
//                   ))
//                   : const SizedBox()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _onRefresh() async {
//     try {
//       orderController.getOrderHistory();
//     } catch (e) {
//       debugPrint("Exception - order_history_screen.dart - _onRefresh():$e");
//     }
//   }
// }

