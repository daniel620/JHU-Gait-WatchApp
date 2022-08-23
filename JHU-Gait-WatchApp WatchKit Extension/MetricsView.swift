//
//  MetricsView.swift
//  JHU-Gait-WatchApp WatchKit Extension
//
//  Created by daniel on 2022/8/16.
//

import SwiftUI

struct MetricsView: View {
    static let formatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
//            formatter. = .numeric(precision:.fractionaLength(0))
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        return formatter
        }()
    
    var body: some View {
        VStack(alignment: .leading){
            Text("03:15.23")
                .foregroundColor(Color.yellow)
                .fontWeight(.semibold)
            Text(
                Measurement(
                    value: 47,
                    unit: UnitEnergy.kilocalories
                ),
                formatter: Self.formatter
            )
            Text(
                "153" + " bmp"
            )
            Text(
                Measurement(
                    value: 515,
                    unit: UnitLength.meters
                ),
                formatter: Self.formatter
            )
        }
        .font(.system(.title, design: .rounded)
//                .monospacedDigit()
//                .lowercaseSmcallCaps()
        )
//        .frame(minWidth: .infinity, alignment: .leading)
//        .ignoresSafeArea(edges: .bottom)
//        .scenePadding()
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}
