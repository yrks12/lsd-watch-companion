import Foundation
import HealthKit
import Combine

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    private var heartRateQuery: HKQuery?
    private var hrvQuery: HKQuery?
    private var activityQuery: HKQuery?
    
    @Published var currentHeartRate: Double = 0
    @Published var currentHRV: Double = 0
    @Published var currentActivity: Double = 0
    @Published var batteryLevel: Int = 100
    
    private let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
    private let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
    private let activityType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    
    func requestAuthorization() {
        let typesToRead: Set = [heartRateType, hrvType, activityType]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if let error = error {
                print("Error requesting HealthKit authorization: \(error)")
            }
            
            if success {
                print("HealthKit authorization granted")
                DispatchQueue.main.async {
                    self.startMonitoring()
                }
            }
        }
    }
    
    func startMonitoring() {
        startHeartRateMonitoring()
        startHRVMonitoring()
        startActivityMonitoring()
        startBatteryMonitoring()
    }
    
    func stopMonitoring() {
        if let query = heartRateQuery {
            healthStore.stop(query)
        }
        if let query = hrvQuery {
            healthStore.stop(query)
        }
        if let query = activityQuery {
            healthStore.stop(query)
        }
    }
    
    private func startHeartRateMonitoring() {
        let query = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] query, samples, deletedObjects, anchor, error in
            if let error = error {
                print("Error querying heart rate: \(error)")
                return
            }
            
            if let samples = samples as? [HKQuantitySample],
               let lastSample = samples.last {
                DispatchQueue.main.async {
                    self?.currentHeartRate = lastSample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                }
            }
        }
        
        query.updateHandler = { [weak self] query, samples, deleted, anchor, error in
            if let samples = samples as? [HKQuantitySample],
               let lastSample = samples.last {
                DispatchQueue.main.async {
                    self?.currentHeartRate = lastSample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                }
            }
        }
        
        healthStore.execute(query)
        heartRateQuery = query
    }
    
    private func startHRVMonitoring() {
        let query = HKAnchoredObjectQuery(
            type: hrvType,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] query, samples, deletedObjects, anchor, error in
            if let error = error {
                print("Error querying HRV: \(error)")
                return
            }
            
            if let samples = samples as? [HKQuantitySample],
               let lastSample = samples.last {
                DispatchQueue.main.async {
                    self?.currentHRV = lastSample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                }
            }
        }
        
        query.updateHandler = { [weak self] query, samples, deleted, anchor, error in
            if let samples = samples as? [HKQuantitySample],
               let lastSample = samples.last {
                DispatchQueue.main.async {
                    self?.currentHRV = lastSample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                }
            }
        }
        
        healthStore.execute(query)
        hrvQuery = query
    }
    
    private func startActivityMonitoring() {
        let query = HKAnchoredObjectQuery(
            type: activityType,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] query, samples, deletedObjects, anchor, error in
            if let error = error {
                print("Error querying activity: \(error)")
                return
            }
            
            if let samples = samples as? [HKQuantitySample],
               let lastSample = samples.last {
                DispatchQueue.main.async {
                    self?.currentActivity = lastSample.quantity.doubleValue(for: HKUnit.kilocalorie())
                }
            }
        }
        
        query.updateHandler = { [weak self] query, samples, deleted, anchor, error in
            if let samples = samples as? [HKQuantitySample],
               let lastSample = samples.last {
                DispatchQueue.main.async {
                    self?.currentActivity = lastSample.quantity.doubleValue(for: HKUnit.kilocalorie())
                }
            }
        }
        
        healthStore.execute(query)
        activityQuery = query
    }
    
    private func startBatteryMonitoring() {
        // Note: This is a mock implementation since watchOS doesn't provide direct battery access
        // In a real app, you'd need to implement WatchConnectivity to get this from the watch
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.batteryLevel = Int.random(in: 20...100)
            }
        }
    }
}