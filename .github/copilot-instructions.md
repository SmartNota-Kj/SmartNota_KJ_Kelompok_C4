# SmartNota KJ - Copilot Instructions

> **SmartNota KJ**: Photo Note Archive Management Application (Flutter + Supabase)

## Quick Start

### Prerequisites & Environment
- **Flutter SDK**: 3.2.0+
- **Dart SDK**: Included with Flutter
- **Environment Setup**:
  ```bash
  flutter pub get
  ```
- **`.env` Configuration**: Requires `SUPABASE_URL` and `SUPABASE_ANON_KEY` (stored in root `.env` file)

### Run Commands
```bash
# Get dependencies
flutter pub get

# Development (hot reload enabled)
flutter run -v

# Build for release
flutter build android   # Android APK/AAB
flutter build ios       # iOS app
flutter build web       # Web deployment

# Run tests
flutter test

# Code analysis
dart analyze
```

---

## Architecture Overview

### Layered Architecture Pattern
The project follows **Service → Provider → Page** architecture for clean separation of concerns:

```
Pages (UI Layer)
    ↓
Providers (State Management - ChangeNotifier)
    ↓
Services (Business Logic)
    ↓
Supabase Client (Backend)
```

### Directory Structure

| Directory | Purpose |
|-----------|---------|
| `lib/main.dart` | App entry point, Supabase initialization, Provider setup |
| `lib/models/` | Data models (NotaModel, UserModel) with JSON serialization |
| `lib/pages/` | UI pages: splash, login, admin/supervisor dashboards, nota CRUD |
| `lib/providers/` | ChangeNotifier state managers (AuthProvider, NotaProvider) |
| `lib/services/` | Business logic layer (AuthService, NotaService) |
| `lib/themes/` | Material Design theme configuration |
| `lib/widgets/` | Reusable UI components |
| `.env` | Environment variables (Supabase credentials) |

### Key Components

#### **Models** (`lib/models/`)
- **`NotaModel`**: Represents a photo note with items, customer, admin info, and timestamps
- **`NotaItem`**: Line items within a nota (name, qty, price, subtotal)
- **`UserModel`**: User profile with role (admin, supervisor, user)
- All models have `fromJson()` ↔ `toJson()` for serialization

#### **Services** (`lib/services/`)
Services contain business logic and communicate with Supabase:
- **`AuthService`**: Handles login, signup, session, profile fetching
- **`NotaService`**: CRUD operations for notas and items

#### **Providers** (`lib/providers/`)
State managers using `ChangeNotifier`:
- **`AuthProvider(AuthService)`**: Manages auth state (initial, loading, authenticated, unauthenticated, error) plus `currentUser` and `errorMessage`
- **`NotaProvider(NotaService)`**: Manages nota list state and operations

#### **Pages** (`lib/pages/`)
- **`SplashPage`**: Initial app load state
- **`LoginPage`**: User authentication
- **`AdminMain` / `SupervisorMain`**: Role-specific dashboards
- **`AdminDashboard` / `SupervisorDashboard`**: Statistics and overview
- **`NotaListPage`**: View all notas (grouped by date, modern design)
- **`NotaDetailPage`**: View single nota
- **`NotaFormPage`**: Create/edit nota
- **`RekapPage`**: Reports/summaries (admin only)
- **`UserManagementPage`**: Manage users (admin only)

---

## Development Conventions

### 1. State Management (Provider Pattern)
```dart
// Services handle logic:
class MyService {
  Future<Data> fetchData() async { /* Supabase call */ }
}

// Providers manage state:
class MyProvider extends ChangeNotifier {
  final MyService _service;
  Data? _data;
  Data? get data => _data;

  Future<void> load() async {
    _data = await _service.fetchData();
    notifyListeners();
  }
}

// Pages consume providers:
Consumer<MyProvider>(
  builder: (context, provider, _) => provider.isLoading
    ? LoadingWidget()
    : MyWidget(data: provider.data),
)
```

### 2. Model Serialization
All models must have `fromJson()` factory and `toJson()` method:
```dart
class MyModel {
  final String id;

  factory MyModel.fromJson(Map<String, dynamic> json) => MyModel(
    id: json['id'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id};
}
```

### 3. Supabase Integration
- Access via `SupabaseClient` in services
- Use `.select()`, `.insert()`, `.update()`, `.delete()` methods
- Handle `.maybeSingle()` for optional results
- All auth-protected operations verified by Supabase Row Level Security (RLS)

### 4. Error Handling
- Services throw exceptions on failures
- Providers catch and store in `_errorMessage`
- Use `AuthStatus.error` enum when applicable
- Pages display error messages via snackbars or error widgets

### 5. Status System
- **Active Notes**: Notes created within the last 30 days (automatically calculated)
- **Archived Notes**: Notes older than 30 days (automatically moved to archive)
- No manual "pending" status - all new notes are immediately active

---

## Hot Reload Best Practices

✅ **Safe** (preserves app state):
- UI changes (layouts, colors, text)
- Provider state mutations
- Service logic updates

❌ **Unsafe** (restart needed):
- Model class changes
- Global const definitions
- Service constructor changes
- Use `flutter run` with `R` key for hot reload, or `shift+R` for full restart

---

## Common Tasks

### Add a New Page
1. Create `lib/pages/new_page.dart` with Material scaffold
2. Add to provider setup if state needed
3. Add navigation route in `main.dart` or through navigator
4. Example: `Navigator.of(context).push(MaterialPageRoute(builder: (_) => NewPage()))`

### Add a New API Endpoint
1. Add method to service (`lib/services/*.dart`)
2. Expose through provider in `lib/providers/*.dart`
3. Call in page via `Consumer<Provider>` widget
4. Verify Supabase RLS policies allow operation

### Create Reusable Widget
1. Add to `lib/widgets/`
2. Follow Material Design guidelines
3. Accept theme data & state from parent
4. Use `const` constructor when possible

### Debug Supabase Issues
1. Check `.env` has valid `SUPABASE_URL` and `SUPABASE_ANON_KEY`
2. Enable Supabase logs: `SupabaseClient` debug outputs in console
3. Verify RLS policies in Supabase dashboard
4. Check auth session with `Supabase.instance.client.auth.currentUser`

---

## Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `supabase_flutter` | 2.3.4 | Backend & auth |
| `provider` | 6.1.2 | State management |
| `flutter_dotenv` | 5.1.0 | Environment config |
| `intl` | 0.19.0 | Localization & date formatting |
| `google_fonts` | 6.2.1 | Custom fonts |
| `fl_chart` | 0.68.0 | Chart visualizations |
| `pdf` + `printing` | 3.10.8 + 5.12.0 | PDF export |
| `image_picker` | 0.8.7+4 | Photo selection |

---

## Code Style & Patterns

### Comment Headers
Use emoji-prefixed headers for organization:
```dart
// ── Authentication ───────────────────────────────────
void login() { }

// ── Business Logic ───────────────────────────────────
void process() { }
```

### Naming Conventions
- **Classes**: PascalCase (`NotaModel`, `AuthService`)
- **Properties/Methods**: camelCase (`currentUser`, `fetchData()`)
- **Private members**: `_prefix` (e.g., `_errorMessage`, `_service`)
- **Constants**: `UPPER_SNAKE_CASE` for true constants only

### File Organization
- One class per file (except closely related models)
- Logical grouping: models with serialization, services with methods
- Optional `lib/utils/` for utility functions

---

## Role-Based UI (Admin/Supervisor/User)

The app implements role-based access via:
1. **`UserModel.role`** field from Supabase
2. **Different entry points**: `AdminMain`, `SupervisorMain` after login
3. **Page visibility**: Some pages only accessible to specific roles
4. **Feature flags**: Use provider's `currentUser?.role` to conditionally show features

---

## Supervisor Dashboard Features

### Main Statistics Cards
- **Nota Hutang Hari Ini**: Debt notes created today
- **Nota Penjualan Hari Ini**: Sales notes created today
- **Nota Di Edit**: Notes edited today (tracked via `updatedAt` is today)
- **Nota Di Hapus**: Notes deleted today (tracked via deletion counter)

### Summary Section ("Total Nota Tersimpan")
A modern, minimalist card displaying the total combined count of all notes (active + archived) with left-aligned typography and clean design.

### Recent Notes Section ("Nota Terbaru")
- **Title**: Customer/store name (primary, bold)
- **Subtitle**: Nota number (secondary, smaller)
- **Layout**: Clean card design showing the 5 most recent notes

---

## User Management Features

### Supervisor User Management
- **View Users**: List all users with their roles and status
- **Add Admin**: Create new admin accounts with email, name, and password
- **Edit Users**: Modify user information and roles
- **Toggle Active Status**: Enable/disable user accounts
- **Role Management**: Assign admin or supervisor roles

## Nota List Page Features

### Modern Design Elements
- **Grouped by Date**: Notas are grouped by creation date for better organization
- **Store Name Priority**: Primary display shows store/customer name, nota number as secondary
- **Category Badges**: Visual indicators for "Nota Hutang" vs "Nota Penjualan"
- **Modern Search Bar**: Rounded container with proper styling
- **Modern Filter Button**: Container-styled with active state indicator
- **Modern Action Menu**: Three-dot menu with icons and proper styling

### Card Information Display
- **Title**: Customer/Store name (primary)
- **Subtitle**: Nota number (secondary)
- **Category**: Visual badge showing nota type
- **Total Amount**: Right-aligned currency display
- **Actions**: Modern three-dot menu for edit/delete operations

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| **Supabase connection fails** | Verify `.env` credentials, check internet connection |
| **Provider not updating** | Ensure `notifyListeners()` called, check `Consumer` widget wrapping |
| **Hot reload doesn't work** | Use full restart (`shift+R` or `flutter run`), check for syntax errors |
| **Model serialization error** | Verify `fromJson()` handles all fields, check Supabase response structure |
| **Auth not persisting** | Check `AuthProvider.init()` runs on app startup (in `main.dart`) |
