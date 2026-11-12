import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme.dart';

/// Single source of truth. Swap the mock data and simulated replies for
/// Firestore calls later (see README) without touching the screens.
class AppState extends ChangeNotifier {
  Student me = const Student(
    id: 'me', name: '', province: 'Mpumalanga', town: 'Mbombela',
    university: 'Walter Sisulu University', course: '', interests: [],
    travelDate: '17 Jan', color: kPrimary,
  );
  bool signedIn = false;
  bool verified = false; // finished the verify step (or skipped it)
  bool badge = false; // has the verified-student badge

  final List<Student> students = mockStudents();
  final Set<String> requested = {};
  final Set<String> connected = {};
  final Set<String> blocked = {};
  final Map<String, List<Message>> chats = {};

  bool joinedTrip = false;
  int selectedBus = 0;
  bool arrived = false;
  bool shareLocation = true;
  String trustedContact = 'Mom';

  bool useRealLocation = false;
  Position? position;

  String? banner;

  final Map<String, bool> settings = {
    'firstNameOnly': true,
    'hideProfile': false,
    'approxLocation': true,
    'appLock': false,
    'calendar': true,
  };

  // ---------- auth ----------
  void signIn(Student profile) {
    me = profile;
    signedIn = true;
    notifyListeners();
  }

  void completeVerification({required bool withBadge}) {
    verified = true;
    badge = withBadge;
    notifyListeners();
  }

  void signOut() {
    signedIn = false;
    verified = false;
    badge = false;
    requested.clear();
    connected.clear();
    blocked.clear();
    chats.clear();
    joinedTrip = false;
    arrived = false;
    banner = null;
    notifyListeners();
  }

  // ---------- matching ----------
  List<Student> matches({bool anyProvince = false}) => students
      .where((s) =>
          !blocked.contains(s.id) &&
          s.university == me.university &&
          (anyProvince || s.province == me.province))
      .toList();

  int score(Student s) {
    var p = 0;
    if (s.province == me.province) p += 30;
    if (s.university == me.university) p += 30;
    if (s.travelDate == me.travelDate) p += 15;
    if (s.course.isNotEmpty && s.course == me.course) p += 10;
    final shared = s.interests.where(me.interests.contains).length;
    p += (shared > 3 ? 3 : shared) * 5;
    return p;
  }

  Map<String, int> breakdown(Student s) {
    final shared = s.interests.where(me.interests.contains).length;
    final denom = me.interests.isEmpty ? 1 : me.interests.length;
    return {
      'Province': s.province == me.province ? 100 : 0,
      'University': s.university == me.university ? 100 : 0,
      'Travel date': s.travelDate == me.travelDate ? 100 : 0,
      'Interests': ((shared / denom) * 100).round().clamp(0, 100),
      'Course': (s.course.isNotEmpty && s.course == me.course) ? 100 : 0,
    };
  }

  // ---------- location ----------
  double distanceKm(Student s) {
    final lat = (useRealLocation && position != null) ? position!.latitude : me.lat;
    final lng = (useRealLocation && position != null) ? position!.longitude : me.lng;
    return Geolocator.distanceBetween(lat, lng, s.lat, s.lng) / 1000;
  }

  /// Returns an error message, or null on success.
  Future<String?> enableLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return 'Turn on location services on your phone.';
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        return 'Location permission was denied.';
      }
      position = await Geolocator.getCurrentPosition();
      useRealLocation = true;
      notifyListeners();
      return null;
    } catch (_) {
      return 'Could not get your location.';
    }
  }

  void disableLocation() {
    useRealLocation = false;
    notifyListeners();
  }

  // ---------- connections + chat ----------
  void connect(Student s) {
    requested.add(s.id);
    notifyListeners();
    // Simulated acceptance (a real backend would do this).
    Future.delayed(const Duration(seconds: 2), () {
      if (!requested.contains(s.id)) return;
      requested.remove(s.id);
      connected.add(s.id);
      chats[s.id] = [
        Message(s.shortName, 'Hi ${me.name.split(' ').first}! Are you also going to ${me.university} on ${s.travelDate}?'),
      ];
      pushNotification('${s.shortName} accepted your request');
    });
  }

  void sendMessage(String chatId, String text, {bool reply = false}) {
    chats.putIfAbsent(chatId, () => []).add(Message('me', text));
    notifyListeners();
    if (!reply) return;
    final s = students.firstWhere((x) => x.id == chatId, orElse: () => students.first);
    Future.delayed(const Duration(seconds: 2), () {
      if (blocked.contains(chatId)) return;
      chats[chatId]?.add(Message(s.shortName, 'Sounds good! See you at the bus stop.'));
      pushNotification('New message from ${s.shortName}');
    });
  }

  void block(String id) {
    blocked.add(id);
    connected.remove(id);
    requested.remove(id);
    chats.remove(id);
    notifyListeners();
  }

  void unblock(String id) {
    blocked.remove(id);
    notifyListeners();
  }

  // ---------- trip ----------
  void joinTrip() {
    joinedTrip = true;
    final going = matches().where((s) => s.travelDate == me.travelDate).toList();
    chats['trip'] = [
      for (final s in going.take(2))
        Message(s.shortName, 'Hi everyone! Which coach are we taking on ${me.travelDate}?'),
    ];
    pushNotification('You joined the ${me.travelDate} trip group');
    notifyListeners();
  }

  void markArrived() {
    arrived = true;
    pushNotification('$trustedContact was notified that you arrived safely');
    notifyListeners();
  }

  // ---------- settings + in-app notification banner ----------
  void setSetting(String key, bool v) {
    settings[key] = v;
    notifyListeners();
  }

  void setSharing(bool v) {
    shareLocation = v;
    notifyListeners();
  }

  void setTrustedContact(String v) {
    trustedContact = v.isEmpty ? 'Mom' : v;
    notifyListeners();
  }

  void selectBus(int i) {
    selectedBus = i;
    notifyListeners();
  }

  /// Simulated push notification (replace with Firebase Cloud Messaging).
  void pushNotification(String text) {
    banner = text;
    notifyListeners();
    Future.delayed(const Duration(seconds: 4), () {
      if (banner == text) {
        banner = null;
        notifyListeners();
      }
    });
  }
}
