# Garbagemana

Garbagemana is a Flutter application designed for managing waste collection logistics. The app integrates with Firestore and Firebase Authentication to provide user and worker registration, login, and user data management. It also includes features for payment processing, task management, and Google Maps for pickup locations.

## Features

- User and worker registration and login
- User data management using Firestore
- Payment processing and status updates
- Task management for waste collection
- Integration with Google Maps for pickup locations

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/nami63/Garbom.git
    cd Garbom
    ```

2. Install the dependencies:
    ```bash
    flutter pub get
    ```

3. Set up Firebase:
    - Go to the [Firebase Console](https://console.firebase.google.com/).
    - Create a new project or use an existing project.
    - Add an Android and/or iOS app to the project.
    - Download the `google-services.json` (for Android) and/or `GoogleService-Info.plist` (for iOS) files and place them in the respective directories.

4. Set up Google Maps API:
    - Go to the [Google Cloud Console](https://console.cloud.google.com/).
    - Create a new project or use an existing project.
    - Enable the "Maps SDK for Android" and "Maps SDK for iOS" APIs.
    - Create an API key and restrict its usage to your app.
    - Add the API key to your Flutter project:
      - For Android, add it to `android/app/src/main/AndroidManifest.xml`:
        ```xml
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_API_KEY"/>
        ```
      - For iOS, add it to `ios/Runner/AppDelegate.swift`:
        ```swift
        GMSServices.provideAPIKey("YOUR_API_KEY")
        ```

5. Run the app:
    ```bash
    flutter run
    ```

## Firebase Configuration

Make sure to add your Firebase configuration files:

- `google-services.json` for Android in `android/app/`
- `GoogleService-Info.plist` for iOS in `ios/Runner/`

## Usage

### Authentication

The `AuthService` class handles user and worker registration and login using Firebase Authentication.

### User Data Management

User data is managed using Firestore. Additional fields "pickup data" and "map" are added to the "users" collection.

### Payment Processing

The `PaymentService` class updates payment status and moves user details to the 'tasks' collection in Firestore.

### Task Management

Tasks related to waste collection are managed and stored in Firestore. The app includes screens for viewing and managing tasks.

### Google Maps Integration

The app uses Google Maps API to display pickup locations on a map. The `map_screen.dart` and `map_widget.dart` files handle the map functionality.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
- [Google Maps API](https://developers.google.com/maps/documentation)

- ![Demo GIF](https://drive.google.com/file/d/1zludHPh24Irypk44oHMetayiBGBsmF81/view?usp=sharing)


## Contact

For any inquiries or feedback, please contact Namitha, Shriya, and Riya.


