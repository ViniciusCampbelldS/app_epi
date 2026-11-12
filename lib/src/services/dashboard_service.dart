import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard.dart';
import 'api_config.dart';

class DashboardService {
	Future<Dashboard> buscar(int adminId) async {
		final response = await http.get(
			Uri.parse('${ApiConfig.baseUrl}/dashboard?adminId=$adminId'),
		);
		if (response.statusCode == 200) {
			return Dashboard.fromJson(json.decode(utf8.decode(response.bodyBytes)));
		}
		throw Exception(utf8.decode(response.bodyBytes));
	}
}
