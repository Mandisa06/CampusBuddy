# Campus Buddy (Flutter)

Connect first-year students by home province and destination university before they travel.
Runs fully offline with sample data (no Firebase needed), so the demo cannot fail.

## Run it (Windows, Mac or Linux)
1. Install Flutter (https://docs.flutter.dev/get-started/install) and Android Studio. Run `flutter doctor` until it is green.
2. Create a fresh project, then drop this code in:
   ```
   flutter create campus_buddy
   cd campus_buddy
   ```
   - Delete the folder `lib/` and the file `test/widget_test.dart`
   - Copy `lib/` and `pubspec.yaml` from this download into the project (replace the existing ones)
3. Android permissions: open `android/app/src/main/AndroidManifest.xml`.
   Inside `<manifest>` and ABOVE `<application ...>` add:
   ```xml
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
   <queries>
     <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent>
     <intent><action android:name="android.intent.action.DIAL"/><data android:scheme="tel"/></intent>
   </queries>
   ```
4. Start an emulator (or plug in a phone with USB debugging), then:
   ```
   flutter pub get
   flutter run
   ```

## Demo script (about 5 minutes)
1. Onboarding: fill the form, accept consent, tap "Find my buddies".
2. Verify: enter `name@wsu.ac.za`, "Send code", type `482913`. You get the verified badge.
3. Buddies: show match scores, filters, tap a card for the "Why you match" breakdown.
4. Tap Connect. After 2 seconds a push-style banner appears and a chat opens in Chats.
5. Chats: send a message, show the reply banner. Show Report and Block.
6. Trips: pick a coach, "Join trip group", open the group chat, "Book on operator site".
7. Safe arrival: set a trusted contact, "I have arrived safely".
8. Profile: privacy toggles, blocked users, sign out.
Tip: tap "Use my location" to use the real GPS (in the emulator set a location under Extended controls).

## Code structure (explain this in the report)
- `lib/main.dart` app entry and screen routing by state
- `lib/models/` Student, Message, BusOption
- `lib/data/mock_data.dart` sample students, buses, dropdown lists
- `lib/services/app_state.dart` all logic (Provider ChangeNotifier): matching score, location, connections, chat, trip, settings
- `lib/screens/` one file per screen; `lib/widgets/` shared UI

Mobile features used: GPS location (geolocator), phone dialler and browser (url_launcher), in-app push-style notifications, forms and validation, state management (Provider).

## What is simulated (say so in your report)
- Students, buses and prices are sample data. Replies and "accepted" events are simulated with timers.
- Google sign-in, the email code, push notifications, fingerprint lock and live location sharing are demo versions.
- To make them real: Firebase Auth (Google), Cloud Firestore (students, requests, messages), Firebase Cloud Messaging (push), `local_auth` (fingerprint). Replace the methods in `app_state.dart` one by one; the screens do not change.
# CampusBuddy
