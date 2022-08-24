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
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView()
    }
}
