import SwiftUI

struct ContentView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var webSocketManager = WebSocketManager()
    @State private var showingSettings = false
    @State private var serverAddress = "localhost:8765"
    
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Connection Status
                HStack {
                    Image(systemName: webSocketManager.isConnected ? "wifi" : "wifi.slash")
                        .foregroundColor(webSocketManager.isConnected ? .green : .red)
                    Text(webSocketManager.isConnected ? "Connected" : "Disconnected")
                }
                .padding()
                
                // Biometric Data Display
                VStack(spacing: 15) {
                    BiometricDataRow(
                        icon: "heart.fill",
                        title: "Heart Rate",
                        value: String(format: "%.0f", healthKitManager.currentHeartRate),
                        unit: "BPM"
                    )
                    
                    BiometricDataRow(
                        icon: "waveform.path.ecg",
                        title: "HRV",
                        value: String(format: "%.1f", healthKitManager.currentHRV),
                        unit: "ms"
                    )
                    
                    BiometricDataRow(
                        icon: "flame.fill",
                        title: "Activity",
                        value: String(format: "%.1f", healthKitManager.currentActivity),
                        unit: "kcal"
                    )
                    
                    BiometricDataRow(
                        icon: "battery.100",
                        title: "Battery",
                        value: "\(healthKitManager.batteryLevel)",
                        unit: "%"
                    )
                }
                .padding()
                
                Spacer()
                
                // Connect/Disconnect Button
                Button(action: {
                    if webSocketManager.isConnected {
                        webSocketManager.disconnect()
                    } else {
                        if let url = URL(string: "ws://\(serverAddress)") {
                            webSocketManager.connect()
                        }
                    }
                }) {
                    Text(webSocketManager.isConnected ? "Disconnect" : "Connect")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(webSocketManager.isConnected ? Color.red : Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("LSD Companion")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(serverAddress: $serverAddress)
            }
            .onAppear {
                healthKitManager.requestAuthorization()
            }
            .onReceive(timer) { _ in
                if webSocketManager.isConnected {
                    webSocketManager.sendBiometricData(
                        heartRate: healthKitManager.currentHeartRate,
                        hrv: healthKitManager.currentHRV,
                        activity: healthKitManager.currentActivity,
                        batteryLevel: healthKitManager.batteryLevel
                    )
                }
            }
        }
    }
}

struct BiometricDataRow: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title2)
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(unit)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var serverAddress: String
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Server Configuration")) {
                    TextField("Server Address", text: $serverAddress)
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}