//
//  BusConfimationView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/6/23.
//

import SwiftUI

struct BusTrackingView: View {
    var busStop: BusStop
    var busRoute: BusRoutes
    
    @StateObject var stopMonitoringFetcher: StopMonitoringFetcher = StopMonitoringFetcher()
    
    var body: some View {
        let distanceData = stopMonitoringFetcher.getDistanceAway()
        ZStack {
            Color("Color1").ignoresSafeArea()
            
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                Text("TRACKING")
                    .font(.title)
                    .fontWeight(.bold)
                Text("\(busRoute.shortName) \(busRoute.longName)" + "\n\(distanceData)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color("Color2"))
                    .cornerRadius(20)
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            stopMonitoringFetcher.fetchStopMonitoring(monitoringRef: busStop.code, lineRef: busRoute.id.replacingOccurrences(of: " ", with: "%20"))
        }
    }
}

struct BusTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        BusTrackingView(busStop: BusStop.sampleData, busRoute: BusRoutes.sampleData)
    }
}
