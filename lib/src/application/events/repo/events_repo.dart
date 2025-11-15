import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/events/model/event_details_model.dart';
import 'package:mingly/src/application/events/model/event_ticket_model.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/application/events/model/table_ticket_model.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/event_session_model.dart';

class EventsRepo {
  Future<List<EventsModel>> getEvents() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.eventsUrl,
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => EventsModel.fromJson(e)).toList();
  }

  Future<List<EventsModel>> getEventsSearch(String search, String date) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      "${AppUrls.eventsUrl}?search=$search&date=$date",
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => EventsModel.fromJson(e)).toList();
  }

  Future<List<EventsModel>> getEventsVenuseWise(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      "/venue/${id}/events/",
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => EventsModel.fromJson(e)).toList();
  }

  Future<EventDetailsModel> getEventsDetails(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getData(
      AppUrls.eventDetails.replaceFirst(":id", id),
      authToken: preferences.getString("authToken"),
    );
    return EventDetailsModel.fromJson(response);
  }

  Future<List<EventsTicketModel>> getEventTicket(String id) async {
    final response = await ApiService().getList("${AppUrls.ticketList}$id/");
    return response.map((e) => EventsTicketModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> buyEventTicket(
    Map<String, dynamic> data,
    String id,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().postData(
      "${AppUrls.buyTicket}${id}/",
      data,
      authToken: preferences.getString("authToken"),
    );
    return response;
  }

  Future<Map<String, dynamic>> getTableTicket(
    String eventId,
    String date,
    String selectedTime,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getData(
      "${AppUrls.getTableTicket}$eventId/?date=$date&selected_time=$selectedTime",
      authToken: preferences.getString("authToken"),
    );
    return response;
  }

  Future<List<EventsTicketModel>> getTablesTickets(String eventId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.getTableTickets.replaceFirst(":id", eventId),
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => EventsTicketModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> buyTableEventTicket(
    Map<String, dynamic> data,
    String id,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().postData(
      "${AppUrls.tableBook}${id}/",
      data,
      authToken: preferences.getString("authToken"),
    );
    return response;
  }

  Future<Map<String, dynamic>> getPopularEvent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final reseponse = await ApiService().getData(
      AppUrls.getPopularEvent,
      authToken: preferences.getString("authToken"),
    );
    return reseponse;
  }

  Future<List<EventsModel>> getEventsById(int venueId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final reseponse = await ApiService().getList(
      AppUrls.getEventsById.replaceFirst(":venue_id", venueId.toString()),
      authToken: preferences.getString("authToken"),
    );
    return reseponse.map((e) => EventsModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> getEventCategories(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final reseponse = await ApiService().postData(
      "/reserve/${id}/event/",
      {},
      authToken: preferences.getString("authToken"),
    );
    return reseponse;
  }

  Future getRecomendedEvent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final reseponse = await ApiService().getData(
      AppUrls.getRecomendedEvent,
      authToken: preferences.getString("authToken"),
    );
    return reseponse;
  }

  Future<List<EventSessionModel>> getEventSessions(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.eventSessions.replaceFirst(":id", id),
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => EventSessionModel.fromJson(e)).toList();
  }
}
