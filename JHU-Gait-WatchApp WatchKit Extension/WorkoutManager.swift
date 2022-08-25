//
//  WorkoutManager.swift
//  JHU-Gait-WatchApp WatchKit Extension
//
//  Created by daniel on 2022/8/24.
//

import Foundation
import HealthKit

// WorkoutManager: An NSObject that conforms to the ObservableObject protocol
class WorkoutManager: NSObject, ObservableObject{
    var selectedWorkout: HKWorkoutActivityType?{
        didSet {
            guard let selectedWorkout = selectedWorkout else {
                return
            }
            startWorkout(workoutType: selectedWorkout)

        }
    }
    
    @Published var showingSummaryView: Bool = false{
        didSet{
            // Sheet dismissed
            if showingSummaryView == false{
//                selectedWorkout = nil
                resetWorkout() // Reset workout variables when leave.
            }
        }
    }
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    func startWorkout(workoutType: HKWorkoutActivityType){
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        // For our APP, all out workouts are outdoor. Outdoor activity generates accurate location data.
        configuration.locationType = .outdoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions
            return
        }
        // HKLiveWorkoutDataSource automatically provide live data from active workout session
        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration
        )
        
        // Make sure WorkoutManager is HKWorkoutSession delegate
        session?.delegate = self
        builder?.delegate = self
        
        // Start the workout session and begin data collection
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) {
            (sucess, error) in
            // The workout has started
        }
    }
    
    // Request authorization to access HealthKit.
    func requestAuthotization(){
        // The quantity type to write to the health store.
        // For workout sessions, we must have permissions to share workout type.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        // The quantity types to read from the health store
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.activitySummaryType() // Activity rings summary
        ]
        
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead){
            (sucess, error) in
            // Handle error.
        }
        
    }
    
    // MARK: - State Control
    // Session state control logic
    
    // The workout session state
    @Published var running = false
    // published variable running track if the session is running
    
    func pause(){
        session?.pause()
    }
    
    func resume(){
        session?.resume()
    }
    
    func togglePause(){
        if running == true{
            pause()
        }else{
            resume()
        }
    }
    
    func endWorkout(){
        session?.end()
        showingSummaryView = true
    }
    
    // MARK: - Workout Metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?
    
    func updateForStatistics(_ statistics: HKStatistics?){
        guard let statistics = statistics else {
            return
        }
        
        DispatchQueue.main.async {
            switch statistics.quantityType{
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }
    
    // Set all our workout variables to the initial state
    func resetWorkout(){
        selectedWorkout = nil
        builder = nil
        session = nil
        workout = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
    }
    
}

// Extend WorkoutManager to be HKWorkSession delegate
//      to listen for changes to the session state

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate{
    // Auto fix
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) {
        DispatchQueue.main.async{
            self.running = toState == .running
        }
        
        // Wait for the session to transition states before ending the builder
        // When endCollection ends, save the workout to the HK database
        if toState == .ended{
            builder?.endCollection(withEnd: date){(success, error) in
                self.builder?.finishWorkout{(workout, error)in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
        }
    }
//    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
//        // fatal
//    }

}
// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager:HKLiveWorkoutBuilderDelegate{
//    Auto fix
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes{
            guard let quantityType = type as? HKQuantityType else { return }
             
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            //Update the published values
            updateForStatistics(statistics)
        }
    }
//    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
//
//    }
}
