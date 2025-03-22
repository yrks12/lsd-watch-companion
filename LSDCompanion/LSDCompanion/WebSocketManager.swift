import Foundation

class WebSocketManager: ObservableObject {
    private var webSocket: URLSessionWebSocketTask?
    private let serverURL: URL
    @Published var isConnected = false
    
    init(serverURL: URL = URL(string: "ws://localhost:8765")!) {
        self.serverURL = serverURL
    }
    
    func connect() {
        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: serverURL)
        webSocket?.resume()
        isConnected = true
        receiveMessage()
    }
    
    func disconnect() {
        webSocket?.cancel(with: .normalClosure, reason: nil)
        isConnected = false
    }
    
    private func receiveMessage() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error)")
                self?.isConnected = false
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text message: \(text)")
                case .data(let data):
                    print("Received binary message: \(data)")
                @unknown default:
                    print("Received unknown message type")
                }
                
                // Continue receiving messages
                self?.receiveMessage()
            }
        }
    }
    
    func send(data: [String: Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("Failed to serialize data")
            return
        }
        
        webSocket?.send(.string(jsonString)) { error in
            if let error = error {
                print("WebSocket send error: \(error)")
            }
        }
    }
    
    func sendBiometricData(heartRate: Double, hrv: Double, activity: Double, batteryLevel: Int) {
        let data: [String: Any] = [
            "type": "biometric_data",
            "data": [
                "heart_rate": heartRate,
                "hrv": hrv,
                "activity": activity,
                "battery_level": batteryLevel
            ]
        ]
        send(data: data)
    }
}