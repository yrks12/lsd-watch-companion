# LSD Watch Companion

iOS companion app for streaming Apple Watch data to the Lucid State Dynamics (LSD) platform.

## Features

- Real-time heart rate monitoring
- Heart Rate Variability (HRV) tracking
- Activity level monitoring
- Battery level reporting
- Secure data streaming to LSD platform

## Requirements

- iOS 14.0+
- Apple Watch Series 3 or later
- Xcode 13.0+
- Apple Developer account (for HealthKit permissions)

## Setup Instructions

1. Clone this repository
2. Open `LSDCompanion.xcodeproj` in Xcode
3. Set your development team in project settings
4. Enable HealthKit capabilities in project settings
5. Build and run on your iPhone

## Usage

1. Launch the app on your iPhone
2. Grant HealthKit permissions when prompted
3. Enter your computer's IP address and port (default: 12345)
4. Tap "Connect" to start streaming data
5. The app will continue monitoring in the background

## Architecture

- **HealthKitManager**: Handles all HealthKit interactions and data queries
- **DataStreamManager**: Manages socket connection and data streaming
- **ContentView**: Main UI with connection settings and data display

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.