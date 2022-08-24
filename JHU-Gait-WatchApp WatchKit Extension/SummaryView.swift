//
//  SummaryView.swift
//  JHU-Gait-WatchApp WatchKit Extension
//
//  Created by daniel on 2022/8/24.
//

import SwiftUI
import HealthKit

struct SummaryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var durationFormatter: DateComponentsFormatter={
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour,.minute,.second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment: .leading){
                SummaryMetricView(
                    title: "Total time",
                    value: durationFormatter.string(from: 30 * 60 + 15) ?? ""
                ).accentColor(Color.yellow)
                
                SummaryMetricView(
                    title: "Total distance",
                    value: Measurement(
                        value: 1625,
                        unit: UnitLength.meters
                    ).formatted(
                        .measurement(width: .abbreviated, usage: .road)
                    )
                ).accentColor(Color.green)
                
                SummaryMetricView(
                    title: "Total energy",
                    value: Measurement(
                        value: 96,
                        unit: UnitEnergy.kilocalories
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .workout,
                            numberFormatStyle: .number.precision(.fractionLength(0))
                        )
                    )
                ).accentColor(Color.pink)
                
                SummaryMetricView(
                    title: "Avg. Heart Rate",
                    value: 143.formatted(.number.precision(.fractionLength(0)))+" bmp"
                    // bmp : beats per minute
                ).accentColor(Color.red)
                
                Text("Activity Rings")
                ActivityRingsView(
                    healthStore: HKHealthStore()
                ).frame(width: 50, height: 50)
                
                Button("Done"){
                    dismiss()
                }
            }
            .scenePadding()//对齐
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}

struct SummaryMetricView: View{
    var title: String
    var value: String
    
    var body: some View{
        Text(title)
        Text(value)
            .font(.system(.title2, design: .rounded).lowercaseSmallCaps())
            .foregroundColor(.accentColor)
        Divider()
    }
}
