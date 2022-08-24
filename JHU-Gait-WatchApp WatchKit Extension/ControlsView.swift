//
//  ControlsView.swift
//  JHU-Gait-WatchApp WatchKit Extension
//
//  Created by daniel on 2022/8/24.
//

import SwiftUI

struct ControlsView: View {
    var body: some View {
        HStack{
            VStack{
                Button{
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(Color.red)
                .font(.title2)
                Text("End")
            }
            
            VStack{
                Button{
                } label: {
                    Image(systemName: "pause")
                }
                .tint(Color.yellow)
                .font(.title2)
                Text("Pause")
                
            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
    }
}
