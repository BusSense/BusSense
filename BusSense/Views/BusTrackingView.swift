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
        let milesData = stopMonitoringFetcher.getMilesAway()
        let metersData = stopMonitoringFetcher.getMetersAway()
        let stopsData = stopMonitoringFetcher.getStopsAway()
        let timeData = stopMonitoringFetcher.getTimeAway()
        
        ZStack {
            
            Color("Color1").ignoresSafeArea()
            
            VStack {
                
                Spacer().frame(height: 20)
                
                VStack {
                    
                    Spacer().frame(height: 10)
                    
                    Text("CURRENTLY TRACKING:")
                        .frame(width: 350, height: 30)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .background(Color("Color1"))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                    
                    if milesData == "No vehicles detected at this time. Please try again later." {
                        Text("\(busRoute.shortName) \(busRoute.longName)" + "\n\n\(milesData)")
                            .frame(width: 350, height: 200)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color("Color2"))
                            .cornerRadius(20)
                    } else {
                        Text("\(busRoute.shortName) \(busRoute.longName)" + "\n\n\(milesData)\n\(metersData) meters away\n\(stopsData) stops away\n\(timeData)")
                            .frame(width: 350, height: 200)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color("Color2"))
                            .cornerRadius(20)
                    }
                }
                .frame(width: 375, height: 300, alignment: .top)
                .background(Color("Color2"))
                .cornerRadius(20)
                
                Spacer()
                
                Image("logo2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200).cornerRadius(20)
                
                Spacer()
                
                HStack {
                    
                    Button {
                        print("user requests to change bus")
                    } label: {
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                            
                            ZStack {
                                
                                Text("").frame(width: 175, height: 250)
                                    .background(Color("Color2"))
                                    .cornerRadius(20)
                                
                                VStack {
                                    
                                    Spacer().frame(height: 10)
                                    
                                    Text("Change\nBus").frame(width: 175, height: 50)
                                        .background(Color("Color2"))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                    
                                    Spacer().frame(height: 20)
                                    
                                    Image("leftarrow")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150)
                                }
                            }
                        }
                    }
                    
                    Button {
                        print("user requests to change bus")
                    } label: {
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                            
                            ZStack {
                                
                                Text("").frame(width: 175, height: 250)
                                    .background(Color("Color2"))
                                    .cornerRadius(20)
                                
                                VStack {
                                    Text("Update Bus \nStatus")
                                        .frame(width: 175, height: 50)
                                        .multilineTextAlignment(.center)
                                        .background(Color("Color2"))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                    
                                    Spacer().frame(height: 40)
                                    
                                    Image("refresh")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100)
                                }
                            }
                        }
                    }
                    
//                    ZStack {
//
//                        Text("").frame(width: 175, height: 250)
//                            .background(Color("Color2"))
//                            .cornerRadius(20)
//
//                        VStack {
//                            Text("Update Bus \nStatus")
//                                .frame(width: 175, height: 50)
//                                .multilineTextAlignment(.center)
//                                .background(Color("Color2"))
//                                .font(.title3)
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.white)
//                                .cornerRadius(20)
//
//                            Spacer().frame(height: 40)
//
//                            Image("refresh")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 100)
//                        }
//                    }
                    
                }
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
