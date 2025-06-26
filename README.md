Sefutures - Smart Savings App 💰

📌 What is Sefutures?
Sefutures is a goal-oriented savings application that helps users:

Save money towards specific targets (e.g., education, vacation)

Lock funds for predetermined periods to prevent impulsive withdrawals

Earn interest on savings through customizable plans

Track progress with intuitive visualizations

Core Value Proposition: Combines behavioral finance principles with modern fintech to promote disciplined saving.

lib/
├── core/
│   ├── constants/          # App-wide constants
│   │   ├── app_constants.dart
│   │   └── supabase_constants.dart
│   │
│   ├── services/           # Business logic
│   │   ├── auth_service.dart
│   │   ├── storage_service.dart
│   │   └── savings_service.dart
│   │
│   ├── widgets/            # Reusable components
│   │   ├── custom_button.dart
│   │   ├── savings_card.dart
│   │   └── progress_chart.dart
│   │
│   └── utils/              # Helpers
│       ├── validators.dart
│       └── date_formatter.dart
│
├── features/
│   ├── auth/               # Auth flow
│   │   ├── bloc/           # State management
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   │
│   │   ├── screens/        # UI
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   │
│   │   └── widgets/        # Auth-specific components
│   │       ├── auth_header.dart
│   │       └── social_auth_buttons.dart
│   │
│   ├── dashboard/          # Main view
│   │   ├── bloc/
│   │   ├── screens/
│   │   └── widgets/
│   │
│   ├── savings/            # Goals feature
│   │   ├── bloc/
│   │   ├── models/         # Data models
│   │   │   └── savings_plan.dart
│   │   │
│   │   ├── screens/
│   │   │   ├── create_goal_screen.dart
│   │   │   └── goal_detail_screen.dart
│   │   │
│   │   └── widgets/
│   │       ├── timeline_widget.dart
│   │       └── amount_selector.dart
│   │
│   └── transactions/       # Money movement
│       ├── bloc/
│       ├── models/
│       │   └── transaction.dart
│       │
│       ├── screens/
│       │   ├── deposit_screen.dart
│       │   └── withdrawal_screen.dart
│       │
│       └── widgets/
│           └── receipt_viewer.dart
│
├── app.dart                # App configuration
└── main.dart               # Entry point


Implemented Core Flows:
graph TD
  A[Authentication] --> B[Dashboard]
  B --> C[Create Savings Goal]
  C --> D[Deposit Funds]
  D --> E[Track Progress]
  E --> B