//
//  ChartView.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 28.04.2024.
//

import SwiftUI
import Charts

struct ChartView: View {
    @Bindable var exercise: Exercise
    
    var body: some View {
        if getDailyValues().count > 5 {
            Chart {
                ForEach(getDailyValues(), id: \.id) { dailyWeight in
                    if dailyWeight.range.upperBound == dailyWeight.range.lowerBound {
                        RuleMark(x: .value("Date", "\(formatDate(dailyWeight.date))"), yStart: .value("Lower", dailyWeight.range.upperBound-10), yEnd: .value("Higher", dailyWeight.range.lowerBound+10))
                            .lineStyle(StrokeStyle(lineWidth: 20))
                            .cornerRadius(20)
                    } else {
                        RuleMark(x: .value("Date", "\(formatDate(dailyWeight.date))"), yStart: .value("Lower", dailyWeight.range.upperBound), yEnd: .value("Higher", dailyWeight.range.lowerBound))
                            .lineStyle(StrokeStyle(lineWidth: 20))
                            .cornerRadius(20)
                    }
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartXAxis(.visible)
            .chartYAxis(.visible)
            .chartYScale(domain: getDomain())
            .frame(height: 200)
            .padding()
        } else {
            Chart {
                ForEach(getDailyValues(), id: \.id) { dailyWeight in
                    RuleMark(x: .value("Date", "\(formatDate(dailyWeight.date))"), yStart: .value("Lower", dailyWeight.range.upperBound), yEnd: .value("Higher", dailyWeight.range.lowerBound))
                        .lineStyle(StrokeStyle(lineWidth: 20))
                        .cornerRadius(20)
                        
                }
            }
            .chartXAxis(.visible)
            .chartYAxis(.visible)
            .chartYScale(domain: getDomain())
            .frame(height: 200)
            .padding()
        }
    }
    
    struct DailyWeights: Identifiable {
        var id = UUID()
        var range: ClosedRange<Double>
        var date: Date
    }
    
    func getDomain() -> ClosedRange<Double> {
        
        var domainRange: ClosedRange<Double> = 0...100
        
        var minValue: Double?
        var maxValue: Double?
        
        for record in exercise.weights {
            if let value = minValue {
                minValue = min(value, record.value)
            } else {
                minValue = record.value
            }
            if let value = maxValue {
                maxValue = max(value, record.value)
            } else {
                maxValue = record.value
            }
        }
        if let minValueNumber = minValue, let maxValueNumber = maxValue {
            let roundedUp = (maxValueNumber / 10).rounded(.up) * 10
            let roundedDown = (minValueNumber / 10).rounded(.down) * 10
            domainRange = (roundedDown)...(roundedUp)
        }
        
        return domainRange
    }
    
    func getDailyValues() -> [DailyWeights] {
        
        var dailyWeights: [DailyWeights] = []
        
        for record in exercise.weights {
            let value = record.value
            let date = record.date
            
            if let index = dailyWeights.firstIndex(where: { item in
                return isSameDay(item.date, date)
            }) {
                let newRange = min(dailyWeights[index].range.lowerBound, value)...max(dailyWeights[index].range.upperBound, value)
                dailyWeights[index].range = newRange
            } else {
                dailyWeights.append(.init(range: value...value, date: date))
            }
        }
        dailyWeights.sort { $0.date < $1.date }
        return dailyWeights
    }
    
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
        
        return components1.year == components2.year &&
        components1.month == components2.month &&
        components1.day == components2.day
    }
    
    func formatDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd. MM." // Formát pro datum a měsíc
            return dateFormatter.string(from: date)
        }
}
