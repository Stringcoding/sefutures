name: savings_app
description: A modern savings app with Supabase backend

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.5

  # Supabase Core (Latest Stable Versions)
  supabase_flutter: ^2.1.1
  postgrest: ^3.1.0
  gotrue: ^2.1.0
  realtime_client: ^2.1.0
  storage_client: ^2.1.0

  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  hydrated_bloc: ^9.1.2

  # Form Validation
  formz: ^0.4.1

  # UI Components
  flutter_svg: ^2.0.7
  google_fonts: ^4.0.4
  shimmer: ^3.0.0
  percent_indicator: ^4.2.3
  syncfusion_flutter_charts: ^23.1.44
  intl: ^0.18.1
  fluttertoast: ^8.2.2

  # Animations
  animations: ^2.0.7

  # File/Image Picker
  image_picker: ^1.0.4
  file_picker: ^5.3.3

  # Local Storage
  shared_preferences: ^2.2.1
  hive_flutter: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  bloc_test: ^9.1.4
  mocktail: ^1.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
    - assets/svgs/
    - assets/fonts/

  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700