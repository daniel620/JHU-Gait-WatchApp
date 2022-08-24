//
//  SessionPagingView.swift
//  JHU-Gait-WatchApp WatchKit Extension
//
//  Created by daniel on 2022/8/16.
//

import SwiftUI
import WatchKit

//WatchKit provide NowPlayingView()

struct SessionPagingView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var selection: Tab = .metrics
    
    enum Tab{
        case controls, metrics, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection){
//            Text("Controls").tag(Tab.controls)
//            Text("Metrics").tag(Tab.metrics)
//            Text("Now Playing").tag(Tab.nowPlaying)
            ControlsView().tag(Tab.controls)
            MetricsView().tag(Tab.metrics)
            NowPlayingView().tag(Tab.nowPlaying)// provided by WatchKit imported
        }
        .navigationTitle(workoutManager.selectedWorkout?.name ?? "")
        .navigationBarBackButtonHidden(true) // BackButton is hidden because do not want to users to get back to the start view while workout
        .navigationBarHidden(selection == .nowPlaying) // When the nowPlaying is shown we want to hide the navigation bar
        .onChange(of: workoutManager.running){
            _ in displayMetricsView()
        }
        // When some one pause or resume their workout, they shouldn't swipe to the metics view. We can do this by adding an onChange re-modifier
    }
    private func displayMetricsView(){
        withAnimation{
            selection = .metrics
        }
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView()
    }
}
