class AppUrls {
  // static String baseUrl = "https://admin.mingly.org/app/api/v1";
  // static String imageUrl = "https://backendapi.mingly.org";
  // static String imageUrlApp = "https://admin.mingly.org";

  static String baseUrl = "http://10.10.13.11:8900/app/api/v1";
  static String imageUrl = "https://backendapi.mingly.org";
  static String imageUrlApp = "https://admin.mingly.org";
  //authentication
  static String login = "/auth/login/";
  static String loginGoogle = "/google/login/";
  static String signUp = "/auth/signup/";
  static String verifyOtp = "/auth/verify-otp/";
  static String forgotPassword = "/auth/forget-password/";
  static String resetPassword = "/auth/reset-password/";
  //profile
  static String profile = "/profile/";
  static String profileUpdate = "/profile/update/";
  //event join
  static String joinEvent = "/events/";
  //venues
  static String venuesUrl = "/all-venues/";
  //events
  static String eventsUrl = "/all-events/";
  static String eventDetails = "/event/:id/detail/";
  static String eventSessions = "/event/:id/sessions/";
  static String ticketList = "/event_tickets/";
  static String buyTicket = "/book_ticket/:eventId/";
  static String continuePayment = "/book_ticket/continue/";
  //bottles
  static String getBottle = "/all-bottles/";
  static String myMenu = "/my-menu-orders/";
  static String createOrder = "/venue-menu-orders/create/";

  //tables and sofa ticket list
  static String getTableTicket = "/table-availability/";
  static String tableBook = "/book-table/";

  static String getTableTickets =
      "/event_tickets/:id/table/?slot_start=:time&date=:date";
  //top leader board
  static String featuredSection = "/featured-images/";
  //top leader board
  static String leaderBoard = "/top-spenders/";

  //subscription
  static String pakageget = "/membership/packages/";

  static String updagradePlan = "/membership/upgrade/";

  static String getPopularEvent = "/popular-events/";

  static String getEventsById = "/venue/:venue_id/events/";

  static String notification = "/get-notifications/";

  static String getVoucher = "/my-vouchers/";

  static String favourite = "/my-favourites/";

  static String checkFavourite = "/favourite/:eventId/check/";

  static String addToFav = "/favourite/:eventId/";

  static String deleteFromFav = "/favourite/:eventId/delete/";

  static String sendChat = "/chats/send_message/";

  static String pointHistory = "/my-point-transactions/";

  static String myReservation = "/my-reservations/";

  static String bookReservation = "/reserve-venue/:venueId/";

  static String bookingOrders = "/my-bookings/";

  static String getOrderHistory = "/order-history/";

  static String getRecomendedEvent = "/recommended-events/";

  static String promoCodeUrl = "/get-promocodes/";

  static String getAdsImage = "/featured-images/";
}
