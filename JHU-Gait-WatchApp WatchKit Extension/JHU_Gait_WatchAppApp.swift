//
//  JHU_Gait_WatchAppApp.swift
//  JHU-Gait-WatchApp WatchKit Extension
//
//  Created by daniel on 2022/8/16.
//

import SwiftUI

@main
struct JHU_Gait_WatchAppApp: App {
//    Add WorkoutManager as StateObejct
    @StateObject var workoutManager = WorkoutManager()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }.sheet(isPresented: $workoutManager.showingSummaryView){
                SummaryView()
            }
            .environmentObject(workoutManager)
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
