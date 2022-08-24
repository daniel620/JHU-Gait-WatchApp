//
//  ElapsedTimeView.swift
//  JHU-Gait-WatchApp WatchKit Extension
//
//  Created by daniel on 2022/8/24.
//

import SwiftUI

struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval = 0
    var showSubseconds: Bool = true
//    State variables
    @State private var timeFormatter = ElapsedTimeFormatter()
    
    var body: some View {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .fontWeight(.semibold)
            .onChange(of: showSubseconds){
                timeFormatter.showSubseconds = $0
            }
    }
}

class ElapsedTimeFormatter: Formatter{
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
//        not show subseconds
        formatter.allowedUnits = [.minute, .second]
//        pad with zeros
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    var showSubseconds = true
    
//    override string function that returns an optional string.
    override func string(for value: Any?) -> String?{
//        First guard ensures the value is TimeInterval
        guard let time = value as? TimeInterval else{
            return nil
        }
        
//        Second guard ensures the componentsFormatter returns the string
        guard let formattedString = componentsFormatter.string(from: time) else{
            return nil
        }
        
        if showSubseconds{
//            calculate subseconds
            let hundredths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            return String(format: "%@%@%0.2d", formattedString, decimalSeparator, hundredths)
        }
//        else if not showSubseconds
        return formattedString
    }
}

struct ElapsedTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ElapsedTimeView()
    }
}
