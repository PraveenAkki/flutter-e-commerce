E-Commerce Clothing App

A Flutter clothing store built with Clean Architecture and BLoC.
Modules: Splash and session, Login, Register, Forgot Password, Product listing
(categories and detail page), Watchlist, Cart, Dummy payment.

Setup

Requirements: Flutter 3.27 or newer (Dart 3.6 or newer).

```bash
git clone https://github.com/PraveenAkki/flutter-e-commerce.git
cd e_clothing
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```



Test login

 - Email: test@eclothing.com
 - Password: Test@123


You can also register a new account on the Register screen.

How the app behaves

- Guests can browse products and open product details.
- Tapping Cart, Watchlist, Add to Cart or the heart icon as a guest opens the
  Login screen. After login, the action the guest started is completed.
- The session token is stored in `flutter_secure_storage`. On the next launch
  the splash screen finds the token and the Logout button appears.
- Logout clears the token, the cart and the watchlist, and opens the product list.
- Products and categories are loaded from `assets/data/*.json`.
- Cart and watchlist are kept in memory (no database).
- Payment is simulated: a 2-second loading state, then a success screen with a
  generated order ID, and the cart is cleared.

Architecture

Each feature has three layers. Dependencies point inwards only.

```
Presentation  (pages, widgets, BLoC: events and states)
     |
Domain        (entities, use cases, repository interfaces, validators)
     |
Data          (repository implementations, local data sources, DTOs)
```


Packages Used

flutter_bloc, bloc, get_it, equatable, freezed_annotation, json_annotation,
flutter_secure_storage, cached_network_image, fluttertoast, another_flushbar,
google_fonts, http. Dev: build_runner, freezed, json_serializable, bloc_test, mocktail.

Unit tests:
1. Login validation
2. Cart total calculation
3. Watchlist add and remove


Run the tests:

```
flutter test
```

Application Video Demo
```
https://drive.google.com/file/d/1ikyZtYAYH6wGcBuC8txp5n4HrH5J5Ei-/view?usp=sharing
```

