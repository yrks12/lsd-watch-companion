# Changelog

All notable changes to the LSD project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Apple Watch integration through custom iOS companion app
  - Real-time heart rate monitoring
  - HRV (Heart Rate Variability) tracking
  - Activity level monitoring
  - Battery level monitoring
  - WebSocket-based communication protocol
- New `AppleWatchSensor` class in the biometrics module
  - Support for both companion app and BLE modes
  - Thread-safe data handling
  - Automatic reconnection handling
  - Signal quality assessment
  - Confidence level calculation
- iOS companion app (LSD Companion)
  - SwiftUI-based user interface
  - HealthKit integration
  - Real-time data streaming
  - Configurable server connection
  - Battery level monitoring
- WebSocket server implementation for biometric data
  - Secure communication protocol
  - JSON-based data format
  - Automatic connection management
- Dependencies
  - Added websockets==11.0.3 for WebSocket server support

### Changed
- Updated project structure to include biometrics module
- Enhanced documentation with biometric integration details
- Modified sensor interface to support real-time data streaming
- Updated requirements.txt with new dependencies

### Technical Details
- WebSocket server runs on port 8765
- Data format:
  ```json
  {
    "type": "biometric_data",
    "data": {
      "heart_rate": float,
      "hrv": float,
      "activity": float,
      "battery_level": int
    }
  }
  ```
- Threading model:
  - Main thread: Core application logic
  - WebSocket thread: Handles companion app communication
  - Data collection thread: Processes biometric readings