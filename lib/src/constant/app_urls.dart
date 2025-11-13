class AppUrls {
  static String baseUrl = "http://10.10.13.11:8900/app/api/v1";
  // static String baseUrl = "https://api.dockploy.72-60-211-160.sslip.io/app/api/v1";
  static String imageUrl = "http://10.10.13.11:8000";

  // static String baseUrl = "https://080aadaa0adf.ngrok-free.app/app/api/v1";
  static String imageUrlNgrok = "http://10.10.13.11:8900";
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
  static String eventDetails = "/event/";
  static String eventSessions = "/event/:id/sessions/";
  static String ticketList = "/event_tickets/";
  static String buyTicket = "/book_ticket/";
  //bottles
  static String getBottle = "/all-bottles/";

  //tables and sofa ticket list
  static String getTableTicket = "/table-availability/";
  static String tableBook = "/book-table/";

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

  static String sendChat = "/chats/send_message/";

  static String pointHistory = "/my-point-transactions/";

  static String reservation = "/my-reservations/";

  static String addToFav = "/favourite/";

  static String getOrderHistory = "/order-history/";

  static String getRecomendedEvent = "/recommended-events/";

  static String promoCodeUrl = "/get-promocodes/";

  static String getAdsImage = "/featured-images/";
}
