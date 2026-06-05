# Fahamni — Private Tutoring Platform

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-^3.11-0175C2?logo=dart&logoColor=white)
![React](https://img.shields.io/badge/React-19-61DAFB?logo=react&logoColor=black)
![Vite](https://img.shields.io/badge/Vite-8-646CFF?logo=vite&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-12-FFCA28?logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-Private-red)

**Fahamni** ("understand me" in Arabic) is a full-stack private tutoring marketplace for Algeria. Students find and book certified tutors, parents monitor their children's learning, and a React web dashboard lets administrators manage the whole platform — all powered by Firebase and an embedded AI study assistant.

---

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Installation](#installation)
  - [Mobile App (Flutter)](#mobile-app-flutter)
  - [Admin Web Dashboard (React)](#admin-web-dashboard-react)
- [Usage](#usage)
- [Configuration](#configuration)
- [Dependencies](#dependencies)
- [Contributors](#contributors)
- [Contributing](#contributing)
- [License](#license)

---

## Features

### Mobile App
- **Multi-role authentication** — Email/password, Google Sign-In, SMS OTP, and email OTP for students, tutors, and parents.
- **Teacher onboarding & approval** — Tutors upload certification files during registration; the account stays in `pending` state until an admin validates it.
- **Map-based service discovery** — Students and parents browse available tutoring services on an interactive Google Maps screen, with geolocation and routing.
- **Tutoring services** — Tutors create named services with subject, level, mode (in-person / online), price, and availability.
- **Session scheduling** — Students book sessions, tutors accept or decline; sessions are tracked with status and history.
- **Real-time messaging** — Group and direct conversations with text, images, audio messages, file attachments, and media galleries.
- **AI Study Assistant** — A slide-up sheet inside any tutor conversation lets students ask Claude (Anthropic) or Gemini to summarise the chat, generate practice questions, simplify tutor messages, or explain concepts. The provider and model are switchable via `.env`.
- **Quote & estimate system** — Students request a price quote from a tutor; tutors respond with a formal estimate that can be exported as a PDF.
- **Feedback & ratings** — Students leave star reviews for tutors after sessions.
- **Push notifications** — In-app notification centre backed by a Firestore `notifications` collection.
- **Suspended-account gate** — Suspended users see a dedicated screen explaining their status instead of reaching the main UI.
- **Parent dashboard** — Parents track their linked children's schedules, tutors, and courses; can explore services on behalf of a child.
- **Courses** — Tutors organise enrolled students into courses with sessions, members, and shared resources (files / links).

### Admin Web Dashboard
- **Teacher validation workflow** — Review pending tutor applications, inspect credentials, validate or reject with a reason.
- **User management** — Browse and search students, tutors, and parents; view full profiles; suspend or reinstate accounts.
- **Reports management** — Triage session and behaviour reports submitted by users.
- **Admin messaging** — Open a conversation with any user directly from their profile.
- **Statistics** — Charts (Recharts) for user growth, session trends, tutor activity, and revenue.
- **Real-time notifications** — Live Firestore listeners push new tutor applications and pending reports to the bell icon without a page refresh.
- **Multilingual UI** — English, French, and Arabic with full RTL document direction switching.
- **Admin settings** — Profile editing and language preference persisted in Firestore and `localStorage`.

---

## Project Structure

```
Fahamni/
├── fahamni/
│   ├── mobile/                         # Flutter cross-platform mobile app
│   │   ├── lib/
│   │   │   ├── main.dart               # Entry point; AuthGate routes by role
│   │   │   ├── firebase_options.dart   # Generated Firebase config (per-platform)
│   │   │   ├── models/                 # Dart data classes
│   │   │   │   ├── user_model.dart     # Abstract base; factory dispatches to sub-types
│   │   │   │   ├── student_model.dart
│   │   │   │   ├── tutor_model.dart    # Includes expertise, rating, certification fields
│   │   │   │   ├── parent_model.dart
│   │   │   │   ├── chat_model.dart     # ConversationModel + MessageModel
│   │   │   │   ├── service_model.dart
│   │   │   │   ├── session_model.dart
│   │   │   │   ├── notification_model.dart
│   │   │   │   ├── quote_model.dart
│   │   │   │   ├── resource_model.dart
│   │   │   │   ├── review_model.dart
│   │   │   │   └── ai_message.dart     # AI chat history entry
│   │   │   ├── Services/               # Business logic & Firebase wrappers
│   │   │   │   ├── auth_.service.dart          # Sign-up, sign-in, Google, OTP, certification upload
│   │   │   │   ├── ai_service.dart             # Claude / Gemini streaming AI assistant
│   │   │   │   ├── chat_service.dart           # Conversation CRUD, messaging
│   │   │   │   ├── notification_service.dart   # In-app push notifications
│   │   │   │   ├── session_service.dart        # Session lifecycle
│   │   │   │   ├── services_service.dart       # Tutor service listings
│   │   │   │   ├── student_tutor_action_service.dart  # Booking, request flows
│   │   │   │   ├── review_service.dart
│   │   │   │   ├── ressource_service.dart
│   │   │   │   ├── admin_support_chat_service.dart
│   │   │   │   ├── email_otp_service.dart
│   │   │   │   ├── phone_auth_service.dart
│   │   │   │   ├── parent_child_service.dart
│   │   │   │   ├── guest_mode_service.dart
│   │   │   │   └── suspended_account_gate.dart
│   │   │   ├── repositories/           # Data-access layer abstraction
│   │   │   │   ├── chat_repository.dart
│   │   │   │   ├── firestore_chat_repository.dart
│   │   │   │   ├── review_repository.dart
│   │   │   │   └── firestore_review_repository.dart
│   │   │   ├── navigation/
│   │   │   │   └── app_navigation.dart  # Singleton NavigationService + fade route builder
│   │   │   ├── messaging/              # All chat UI
│   │   │   │   ├── conversation_page.dart   # Conversation list
│   │   │   │   ├── chat_page.dart           # Active chat thread
│   │   │   │   ├── message_bubble.dart
│   │   │   │   ├── Message_input.dart       # Rich input: text, image, audio, file
│   │   │   │   ├── ai_assistant_sheet.dart  # Slide-up AI panel
│   │   │   │   ├── ai_study_chat_page.dart
│   │   │   │   ├── admin_support_chat_page.dart
│   │   │   │   ├── ConversationBox.dart
│   │   │   │   ├── conversation_members.dart
│   │   │   │   ├── Conversation_media.dart
│   │   │   │   └── conversation_doc_page.dart
│   │   │   ├── StudentHomePage/        # Student main screen + service browsing
│   │   │   ├── TeacherDashboard/       # Tutor dashboard, services, quotes, schedule
│   │   │   ├── ParentDashboread/       # Parent home, children tracking, explore
│   │   │   ├── Courses/                # Course management (sessions, members, resources)
│   │   │   ├── Explore_map_pages/      # Google Maps integration
│   │   │   ├── estimate/               # Quote request, estimate builder, PDF export
│   │   │   ├── feedback/               # Rating & review submission
│   │   │   ├── Login_Screen/
│   │   │   ├── Onboarding/
│   │   │   ├── Notification_page/
│   │   │   ├── Account_Settings_Student/
│   │   │   ├── Account_Settings_Teacher/
│   │   │   ├── Account_Settings_Parent/
│   │   │   ├── User_status/            # Suspended-account screens
│   │   │   ├── utils/
│   │   │   └── widgets/                # Reusable UI components (ServiceCard, CustomNavBar, …)
│   │   ├── firestore.rules             # Firestore security rules
│   │   ├── storage.rules               # Firebase Storage security rules
│   │   ├── functions/                  # Firebase Cloud Functions (Node.js)
│   │   ├── assets/                     # Images, icons, fonts, map style JSON
│   │   └── pubspec.yaml
│   │
│   └── web/                            # React admin dashboard
│       ├── src/
│       │   ├── main.jsx                # React root; i18n import
│       │   ├── App.jsx                 # Firebase Auth gate
│       │   ├── Dashboard.jsx           # Shell layout + routing state machine
│       │   ├── Login.jsx
│       │   ├── TeachersPage.jsx        # Pending / validated teacher list
│       │   ├── TeacherProfilePage.jsx  # Detail view + validate/reject actions
│       │   ├── UsersPage.jsx           # All / suspended user list
│       │   ├── UserProfilePage.jsx     # User detail + suspend / contact
│       │   ├── ReportsPage.jsx         # Session & behaviour reports triage
│       │   ├── MessagesPage.jsx        # Admin ↔ user messaging
│       │   ├── StatisticsPage.jsx      # Recharts analytics
│       │   ├── SettingsPage.jsx        # Admin profile & language settings
│       │   ├── ServiceDetailPanel.jsx  # Tutor service inspector
│       │   ├── firebase.js             # Firebase app initialisation
│       │   ├── i18n.js                 # i18next setup + RTL toggle
│       │   ├── locales/
│       │   │   ├── en.json
│       │   │   ├── fr.json
│       │   │   └── ar.json
│       │   └── suspensionNotifications.js
│       ├── package.json
│       └── vite.config.js
│
├── Instalation web/                    # Static landing page for app download links
├── android/                            # Android host project (Flutter)
├── ios/                                # iOS host project (Flutter)
├── linux/                              # Linux desktop runner
├── macos/ windows/                     # Additional desktop runners
├── .env.example                        # AI provider keys template
└── package.json                        # Root-level firebase-admin for seeding scripts
```

---

## Architecture

### Data Model & Firestore Collections

All data lives in **Cloud Firestore**. The schema uses separate top-level collections per role:

| Collection | Purpose |
|---|---|
| `users` | Lightweight auth lookup: `uid`, `email`, `role`, `account_status`, `is_suspended` |
| `students` | Full student profiles |
| `tutors` | Tutor profiles including `expertise_domain`, `certification_url`, `account_status` (`pending` / `validated` / `rejected`), `average_rating` |
| `parents` | Parent profiles with child links |
| `admins` | Admin accounts; presence in this collection grants admin Firestore privileges |
| `conversations` | Chat threads; `participants[]` list drives access control |
| `messages` | Sub-collection under each conversation |
| `notifications` | In-app notifications consumed by the mobile notification centre |
| `services` | Tutor service listings |
| `sessions` | Booked sessions with status lifecycle |
| `reports` | User-submitted reports on sessions or behaviour |
| `reviews` | Star ratings tied to tutor+student+session |

**Firestore security rules** (`fahamni/mobile/firestore.rules`) encode the permission model: `isAdmin()` checks for a document in `admins/` under the caller's UID; conversation access uses `participants[]` membership; tutors own their services and sessions via `tutor_id` field checks.

### Mobile Auth Flow

`main.dart → AuthGate._checkAuth()`:

1. If no Firebase user → show `OnboardingScreen` (first run) or `LoginScreen`.
2. If logged in → fetch `users/{uid}` for `role` and `is_suspended`.
3. Fetch the role-specific profile document to double-check `is_suspended`.
4. Dispatch to the correct home screen:
   - `student` → `Studenthomepage`
   - `tutor` + `pending` → `TeacherGuestDashboardScreen`
   - `tutor` + `validated` → `TeacherDashboardScreen`
   - `parent` → `Parenthomepage`
   - Any + `is_suspended == true` → `SuspendedAccountGate.accountScreenForRole(role)`

### AI Study Assistant

`AIService` (`lib/Services/ai_service.dart`) streams responses token-by-token from either **Anthropic Claude** or **Google Gemini**, selected at runtime via `AI_PROVIDER` in `.env`.

The system prompt is dynamically constructed from:
- The student's `StudyLevel` (primary / secondary / university) → adjusts vocabulary and depth.
- The `AITaskType` (summarise, practice question, simplify, explain, smart reply, general help) → adjusts the task instruction.
- An injected transcript of the real tutor conversation as context.

The service first attempts a **streaming** HTTP request; if streaming fails (e.g., browser CORS restrictions), it falls back to a non-streaming POST and simulates streaming by yielding words with 15 ms delays.

Model selection is task-aware: `explainConcept` uses the "large" model; all other tasks use the "small" model — configurable in `.env`.

### Admin Web Dashboard

`Dashboard.jsx` is a **single-component state machine**: all pages share a common `active` string ("dashboard", "teachers", "users", …). Page components are conditionally rendered — no router library needed. Error boundaries (`PageErrorBoundary`) wrap each page so a crash in one section doesn't bring down the whole shell.

Real-time notifications arrive via two `onSnapshot` listeners (pending tutors + pending reports) that run for the lifetime of the session. Read state is stored in `localStorage` under a per-admin key.

The i18n system (`src/i18n.js`) uses **react-i18next** with three locale bundles (EN / FR / AR). Switching to Arabic also flips `document.documentElement.dir` to `"rtl"`. The admin's language preference is stored in their Firestore document and applied on login.

---

## Installation

### Prerequisites

- Flutter SDK ≥ 3.11 and Dart SDK ≥ 3.11
- Node.js ≥ 18 and npm
- A Firebase project with Firestore, Auth, Storage, and Functions enabled
- (Optional) Anthropic API key or Google Gemini API key for AI features

---

### Mobile App (Flutter)

```bash
# 1. Clone the repository
git clone https://github.com/Abdelmouname-Meznaoui/Fahamni.git
cd Fahamni/fahamni/mobile

# 2. Install Flutter dependencies
flutter pub get

# 3. Configure Firebase
# Place your google-services.json in android/app/
# Place your GoogleService-Info.plist in ios/Runner/
# The firebase_options.dart is already generated — regenerate if you use a different project:
# flutterfire configure

# 4. Create your .env file for AI features (optional)
cp ../../.env.example .env
# Then fill in ANTHROPIC_API_KEY or GEMINI_API_KEY

# 5. Run on a connected device or emulator
flutter run
```

> **Note:** The app uses `firebase_app_check` with `AndroidProvider.debug` — suitable for development. Switch to `AndroidProvider.playIntegrity` for production builds.

---

### Admin Web Dashboard (React)

```bash
# From repo root
cd fahamni/web

# 1. Install dependencies
npm install

# 2. Configure Firebase
# Edit src/firebase.js and fill in your Firebase project credentials

# 3. Start the development server
npm run dev
# → http://localhost:5173

# 4. Build for production
npm run build
# Output goes to dist/
```

The web app is deployed via Firebase Hosting. `firebase.json` in `fahamni/web/` points the hosting target at the `dist/` directory.

---

## Usage

### Running the Mobile App

```bash
cd fahamni/mobile

# Debug build on Android
flutter run -d android

# Debug build on iOS
flutter run -d ios

# Release APK
flutter build apk --release
```

### Running the Admin Dashboard in Development

```bash
cd fahamni/web
npm run dev
```

Navigate to `http://localhost:5173`. Log in with an admin account (the user's UID must exist in the `admins` Firestore collection).

### Seeding Test Data

Several Node.js scripts in `fahamni/web/` populate Firestore for development:

```bash
# From fahamni/web/
node seed-test-data.cjs          # General seed
node seed-rejected-teachers.cjs  # Seed teachers with rejected status
node seed_last_login.cjs         # Backfill last_login timestamps
node migrate-is-suspended.cjs    # Migration: add is_suspended field to existing docs
```

> Requires `serviceAccountKey.json` (Firebase Admin SDK private key) in the same directory. **Do not commit this file.**

---

## Configuration

### Mobile App — `.env`

Place the file at `fahamni/mobile/.env` (copied from `.env.example`):

| Variable | Default | Description |
|---|---|---|
| `AI_PROVIDER` | `anthropic` | Which AI backend to use: `anthropic` or `gemini` |
| `ANTHROPIC_API_KEY` | *(required for Anthropic)* | Your Anthropic API key |
| `ANTHROPIC_SMALL_MODEL` | `claude-3-5-haiku-latest` | Model for fast tasks (summarise, smart reply, practice Q) |
| `ANTHROPIC_LARGE_MODEL` | `claude-3-7-sonnet-latest` | Model for deep tasks (explain concept) |
| `GEMINI_API_KEY` | *(required for Gemini)* | Your Google Gemini API key |
| `GEMINI_SMALL_MODEL` | `gemini-2.5-flash` | Gemini model for fast tasks |
| `GEMINI_LARGE_MODEL` | `gemini-2.5-pro` | Gemini model for deep tasks |

If `.env` is absent, the app starts normally — AI features are simply unavailable.

### Web Dashboard — Firebase

Edit `fahamni/web/src/firebase.js` and replace the `firebaseConfig` object with your project's values (found in the Firebase console under Project Settings → Your apps).

### Firestore Security Rules

`fahamni/mobile/firestore.rules` governs all data access. Key rules:

- Admin access is granted by presence in `admins/{uid}` — never by a client-supplied claim.
- Conversation read/write requires `request.auth.uid` to be in `participants[]`.
- Tutors can only write to service and session documents where `tutor_id == request.auth.uid`.

Deploy rules with:

```bash
firebase deploy --only firestore:rules
```

---

## Dependencies

### Mobile (Flutter / Dart)

| Package | Purpose |
|---|---|
| `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage` | Core Firebase SDK |
| `firebase_app_check` | App attestation; blocks abusive API traffic |
| `cloud_functions` | Calls Firebase Cloud Functions for server-side logic |
| `google_sign_in` | OAuth login via Google account |
| `google_maps_flutter` | Interactive map for service discovery |
| `geolocator`, `geocoding`, `flutter_polyline_points` | Location services and routing |
| `http` | Streaming HTTP requests to AI APIs |
| `flutter_dotenv` | Loads `.env` at startup |
| `record`, `just_audio` | Audio message recording and playback |
| `file_picker` | Attachment picker for documents and images |
| `image_picker` | Camera and gallery image selection |
| `pdf`, `printing` | Quote / estimate PDF generation and sharing |
| `flutter_markdown`, `flutter_math_fork` | Renders AI responses with Markdown and LaTeX |
| `cached_network_image` | Efficient remote image loading with caching |
| `shared_preferences` | Local persistence (onboarding state, preferences) |
| `carousel_slider` | Onboarding screen image carousel |
| `google_fonts`, `flutter_svg` | Typography and SVG icon rendering |
| `intl` | Date/time formatting and localisation |
| `permission_handler` | Runtime permission requests (camera, mic, storage) |

### Web (React / Node)

| Package | Purpose |
|---|---|
| `react` + `react-dom` v19 | UI library |
| `firebase` v12 | Firestore and Auth client SDK |
| `i18next` + `react-i18next` | Multilingual UI with RTL support |
| `recharts` | Bar, line, and pie charts for statistics page |
| `lucide-react` | Consistent icon set throughout the dashboard |
| `vite` + `@vitejs/plugin-react` | Build tool and HMR dev server |

---

## Contributors

### Top Contributors

| Avatar | Name | Commits | Main Areas |
|---|---|---|---|
| ![Mahieddine](https://github.com/om-mimoun.png?size=40) | **Mahieddine Mohamed Mimoun** | 85 | Admin web dashboard (all pages), AI assistant, estimate/PDF system, i18n, Firebase infrastructure, CI/deploy |
| ![Abdelmouname](https://github.com/Abdelmouname-Meznaoui.png?size=40) | **Abdelmouname Meznaoui** | 74 | Messaging UI/backend, parent dashboard, mobile auth, service cards, database models |
| ![Hamza](https://github.com/Hamza-Bhm24.png?size=40) | **Hamza Benrabah** | 39 | Student homepage, teacher dashboard, notification system, onboarding, schedule page |
| ![Wassim](https://github.com/ow-bedoui.png?size=40) | **Bedoui Wassim** | 34 | Student backend page, Google Maps / explore, messaging polish, service details UI |
| — | **Aimed Benahmed** | 17 | Mobile auth flows, additional UI work |
| ![Alicia](https://github.com/alicia-messaoud.png?size=40) | **Alicia Messaoud** | 6 | Parent/tutor status pages, initial user-info screens |

### Per-Contributor Breakdown

#### Mahieddine Mohamed Mimoun (`om_mimoun@esi.dz`)
**Role:** Lead — Admin Web & Full-Stack Integration

Built and owns the entire React admin dashboard: `Dashboard.jsx` (layout shell, routing state machine, real-time notification listeners), `TeachersPage`, `TeacherProfilePage`, `UsersPage`, `UserProfilePage`, `ReportsPage`, `MessagesPage`, `StatisticsPage`, `SettingsPage`, and the i18n setup. On the mobile side, authored the estimate/quote system (`estimate_service.dart`, `estimate_pdf_generator.dart`, `send_estimate_page.dart`), the teacher portal service layer, and integrated the Firebase Hosting deployment. Implemented the three-locale (EN/FR/AR) web translation system and RTL switching.

Notable commits: *languages + stats*, *quote facture* (quote-to-PDF pipeline), *some web fixs* (full dashboard polish pass).

#### Abdelmouname Meznaoui (`oa_meznaoui@esi.dz`)
**Role:** Mobile Messaging & Data Layer

Designed the initial Firestore data models (Phase 1), built the full messaging module (`ConversationBox`, `chat_page`, `message_bubble`, conversation details/media screens), wired the chat repository abstraction (`chat_repository.dart`, `firestore_chat_repository.dart`), and developed the parent dashboard screens. Drove the backend for the student homepage. Owns most of the service-card UI (`servicecard.dart`, `servicedetails.dart`).

Notable commits: *Phase 1: Implementation of firebase collections and DB models*, *conversation box + chat_model modifications*, *Save last tasks work*.

#### Hamza Benrabah (`oh_benrabah@esi.dz`)
**Role:** Student & Teacher UX

Built and iterated the student homepage (`Student_homepage.dart`), teacher dashboard (`teacher_dashboard.dart`), onboarding screens, and the push-notification system (`notification_service.dart`, `notification_page.dart`). Developed the schedule management page and drove several bug-fix rounds across the teacher and student flows.

Notable commits: *Student homepage added with separate navbar*, *fixed bugs* (schedule + notification overhaul).

#### Bedoui Wassim (`ow_bedoui@esi.dz`)
**Role:** Backend Pages & Map

Added the complete student-page backend (linked via PR #5), overhauled the Google Maps explore screen (`explorepage.dart`, `map.dart`) including polyline routing, and polished the service details widget and messaging bubble. Contributed to admin messaging on the web side.

Notable commits: *Add backend to the student page*, *bla bla bla* (MessagesPage admin chat), *yarabi tstr* (full map + service card overhaul).

#### Aimed Benahmed (`aimed.b04020@gmail.com`)
**Role:** Auth & Mobile Misc

Contributed SMS OTP verification (`phone_auth_service.dart`), password-recovery UI, early mobile auth fixes, and a custom Linux audio plugin override (`third_party/record_linux`).

#### Alicia Messaoud (`oa_messaoud@esi.dz`)
**Role:** Initial Screens

Built the early parent-status and tutor-status onboarding screens and the initial personal-info widget, establishing the folder structure the team expanded on.

### File Ownership Map

| File | Primary Owner |
|---|---|
| `fahamni/web/src/Dashboard.jsx` | Mahieddine Mohamed Mimoun |
| `fahamni/web/src/StatisticsPage.jsx` | Mahieddine Mohamed Mimoun |
| `fahamni/web/src/i18n.js` | Mahieddine Mohamed Mimoun |
| `fahamni/mobile/lib/Services/ai_service.dart` | Mahieddine Mohamed Mimoun |
| `fahamni/mobile/lib/estimate/` | Mahieddine Mohamed Mimoun |
| `fahamni/mobile/lib/messaging/chat_page.dart` | Abdelmouname Meznaoui + Hamza Benrabah |
| `fahamni/mobile/lib/messaging/Message_input.dart` | Abdelmouname Meznaoui |
| `fahamni/mobile/lib/repositories/` | Abdelmouname Meznaoui |
| `fahamni/mobile/lib/models/chat_model.dart` | Abdelmouname Meznaoui |
| `fahamni/mobile/lib/StudentHomePage/Student_homepage.dart` | Hamza Benrabah + Bedoui Wassim |
| `fahamni/mobile/lib/Services/notification_service.dart` | Hamza Benrabah |
| `fahamni/mobile/lib/Courses/schedule_page.dart` | Hamza Benrabah |
| `fahamni/mobile/lib/Explore_map_pages/` | Bedoui Wassim |
| `fahamni/mobile/lib/widgets/servicecard.dart` | Abdelmouname Meznaoui + Bedoui Wassim |

---

## Contributing

1. **Fork** the repository and create a feature branch from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Set up** the project following the [Installation](#installation) section.

3. **Code style:**
   - Dart: run `flutter analyze` and fix all warnings before committing.
   - JavaScript/JSX: run `npm run lint` in `fahamni/web/`.
   - Keep Firebase security rules in sync with any new collections you add.

4. **Test** your changes:
   - Mobile: `flutter test` for unit tests; manually verify on an Android emulator or device.
   - Web: manually verify in a browser against a Firebase emulator or test project.

5. **Commit** with a clear message describing *what* changed and *why*.

6. **Open a pull request** against `main` with a description of the feature, screenshots if UI-related, and any Firestore rule changes.

> For changes that affect Firestore security rules or the data schema, please update `firestore.rules` and note the change in your PR description so it can be reviewed carefully before deployment.

---

## License

This project is **private** and not licensed for public distribution. All rights are reserved by the project team. Contact the maintainers for any usage enquiries.
