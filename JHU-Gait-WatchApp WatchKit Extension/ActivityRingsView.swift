//
//  ActivityRingsView.swift
//  JHU-Gait-WatchApp WatchKit Extension
//
//  Created by daniel on 2022/8/24.
//
//  This file might be helpful to get access to health metrics from watch device.

import Foundation
import HealthKit // get access to HKHealthStore
import SwiftUI //get access to WKinterfaceObjectRepresentable

struct ActivityRingsView: WKInterfaceObjectRepresentable{
    func updateWKInterfaceObject(_ wkInterfaceObject: WKInterfaceObjectType, context: Context) {
    }
    
    let healthStore : HKHealthStore // healthStore constant usually asigned to initialization program
    
    func makeWKInterfaceObject(context: Context) -> some WKInterfaceObject {
        let activityRingsObject = WKInterfaceActivityRing()
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.era,.year,.month,.day], from: Date())
        components.calendar = calendar
        
        let predicate = HKQuery.predicateForActivitySummary(with: components)
        
//        make the query to HKHealthStore
        let query = HKActivitySummaryQuery(predicate: predicate){
            query, summaries, error in DispatchQueue.main.async {
                activityRingsObject.setActivitySummary(summaries?.first, animated: true)
            }
        }
//        execute the query
        healthStore.execute(query)
//        return the result
        return activityRingsObject
    }
    
}


