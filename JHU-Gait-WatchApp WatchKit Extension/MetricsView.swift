//
//  MetricsView.swift
//  JHU-Gait-WatchApp WatchKit Extension
//
//  Created by daniel on 2022/8/16.
//

import SwiftUI


struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    // use workoutManager to update metrics view
    var body: some View {
        TimelineView(
            MetricsTimelineSchedule(
                from: workoutManager.builder?.startDate ?? Date()
            )
        ){context in
            VStack(alignment: .leading){
                ElapsedTimeView(
                    elapsedTime: workoutManager.builder?.elapsedTime ?? 0,
                    showSubseconds: context.cadence == .live
                ).foregroundColor(Color.yellow)
                Text(
                    Measurement(
                        value: workoutManager.activeEnergy,
                        unit: UnitEnergy.kilocalories
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .workout,
                            numberFormatStyle: .number.precision(.fractionLength(0))
                            //numberFormat:.numeric(precision:.fractionLength(0))
                        )
                    )
                )
                
                Text(
                    workoutManager.heartRate.formatted(
                        .number.precision(.fractionLength(0))
                    )
                    + " bpm"
                )
                
                Text(
                    Measurement(
                        value: workoutManager.distance,
                        unit: UnitLength.meters
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .road
                        )
                    )
                )
            }
            .font(.system(.title, design: .rounded)
                .monospacedDigit()
                .lowercaseSmallCaps()
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
        }
    }
}


struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}


// New in WatchOS 8. For AppleWatch's always-on state
private struct MetricsTimelineSchedule: TimelineSchedule{
    var startDate: Date
    
    init(from startDate: Date){
        self.startDate = startDate
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(
            // When the timeline schedule mode is lowFrequency, the timeline interval is 1 times / 1 second.
            // If mode is normal, so the interval is 30 times / 1 second.
            from: self.startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)
        ).entries(from: startDate, mode: mode)
    }
}
