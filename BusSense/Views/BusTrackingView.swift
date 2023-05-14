//
//  BusConfimationView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/6/23.
//

import SwiftUI

struct BusTrackingView: View {
    
    var busStop: BusStopRoute
    var busRoute: RouteDetail
    let speechSynthesizer = SpeechSynthesizer()
        
    @StateObject var stopMonitoringFetcher: StopMonitoringFetcher = StopMonitoringFetcher()
    
    // generate notice of number of buses ahead of desired bus
    func notice(stop: BusStopRoute, route: RouteDetail, fetcher: StopMonitoringFetcher) -> [(Date, String)] {
        
        // array of tuples (oncoming time and bus to that specific stop)
        var arrivingTimes: [(day: Date, bus: String)] = []
        
        let currDate = Date()
        var curr = Calendar.current
        
        // get all buses arriving at stop
        fetcher.fetchStopMonitoring(monitoringRef: stop.code)
        
        for x in fetcher.monitoredStops! {
            
            var nextTime = x.monitoredVehicleJourney.monitoredCall.expectedArrivalTime
            
            var date = DateComponents()
            date.year = Int(String(nextTime!.prefix(4))) ?? 0
            date.month = Int(nextTime![nextTime!.index(nextTime!.startIndex, offsetBy: 6)..<nextTime!.index(nextTime!.endIndex, offsetBy: -22)]) ?? 0
            date.day = Int(nextTime![nextTime!.index(nextTime!.startIndex, offsetBy: 8)..<nextTime!.index(nextTime!.endIndex, offsetBy: -19)]) ?? 0
            date.timeZone = TimeZone(abbreviation: "EST")
            date.hour = Int(nextTime![nextTime!.index(nextTime!.startIndex, offsetBy: 11)..<nextTime!.index(nextTime!.endIndex, offsetBy: -16)]) ?? 0
            date.minute = Int(nextTime![nextTime!.index(nextTime!.startIndex, offsetBy: 15)..<nextTime!.index(nextTime!.endIndex, offsetBy: -13)]) ?? 0
            date.second = Int(nextTime![nextTime!.index(nextTime!.startIndex, offsetBy: 18)..<nextTime!.index(nextTime!.endIndex, offsetBy: -10)]) ?? 0
            let arrivingDateTime = curr.date(from: date)!
            
            arrivingTimes.append((arrivingDateTime, x.monitoredVehicleJourney.lineRef))
        }
            
            arrivingTimes = arrivingTimes.sorted(by: {$0.day < $1.day})
            
        
        return arrivingTimes
    }
    
    // count the number of buses ahead of the desired bus
    func ahead(route: RouteDetail, arrivingTimes: [(Date, String)]) -> Int {
        
        var numberofBus = 0
        for i in arrivingTimes {
            if i.1 != route.lineRef {
                numberofBus += 1
            }
        }
        return numberofBus
    }
    
    
    var body: some View {
        
        let proximityData = stopMonitoringFetcher.getProximityAway()
        let metersData = stopMonitoringFetcher.getMetersAway()
        let stopsData = stopMonitoringFetcher.getStopsAway()
        let timeData = stopMonitoringFetcher.getTimeAway()
                
        // call notice and ahead function to determine the buses ahead of desired bus
        let order = notice(stop: busStop, route: busRoute, fetcher: stopMonitoringFetcher)
        let busesAhead = ahead(route: busRoute, arrivingTimes: order)
        
        ZStack {
            
            Color("Color1").ignoresSafeArea()
            
            VStack {
                
                Spacer().frame(height: 10)
                
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
                    
                    if proximityData == "No vehicles detected at this time. Please try again later." {
                        Text("\(busRoute.lineNameAndDestinationName)" + "\n\n\(proximityData)")
                            .frame(width: 350, height: 200)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color("Color2"))
                            .cornerRadius(20)
                            .onAppear() {
                                speechSynthesizer.speak("currently tracking")
                                speechSynthesizer.speak("\(busRoute.lineNameAndDestinationName)" + "\n\n\(proximityData)")
                                speechSynthesizer.speak("NOTICE:")
                                speechSynthesizer.speak("Bx4A is approaching your stop. This is not your bus. There are two buses ahead of the Bx4.")
                            }
                    } else {
                        Text("\(busRoute.lineNameAndDestinationName)" + "\n\n\(proximityData)\n\(metersData) meters away\n\(stopsData) stops away\n\(timeData)")
                            .frame(width: 350, height: 200)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color("Color2"))
                            .cornerRadius(20)
                            .onAppear() {
                                speechSynthesizer.speak("currently tracking")
                                speechSynthesizer.speak("\(busRoute.lineNameAndDestinationName)" + "\n\n\(proximityData)")
                                speechSynthesizer.speak("NOTICE:")
                                speechSynthesizer.speak("Bx4A is approaching your stop. This is not your bus. There are two buses ahead of the Bx4.")
                            }
                    }
                }
                .frame(width: 375, height: 300, alignment: .top)
                .background(Color("Color2"))
                .cornerRadius(20)
                
                VStack {
                    
                    Spacer().frame(height: 10)
                    
                    Text("NOTICE:")
                        .frame(width: 350, height: 30)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .background(Color("Color1"))
                        .cornerRadius(10)
                    
                    Text("\(order[0].1) is the next approaching bus. The next approaching bus is not \(busRoute.lineNameAndDestinationName). There are \(busesAhead) buses ahead of \(busRoute.lineNameAndDestinationName).")
                        .frame(width: 350, height: 100)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color("Color2"))
                        .cornerRadius(20)
                        .onAppear()
                    
                    
                }.frame(width: 375, height: 200, alignment: .top)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                
                Spacer().frame(height: 10)
                
//                Image("logo2")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 150).cornerRadius(20)
                
                Spacer().frame(height: 10)
                
                HStack {
                    
                    Button {
                        print("user requests to change bus")
                    } label: {
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                            
                            ZStack {
                                
                                Text("").frame(width: 175, height: 225)
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
                                    
                                    Image(systemName: "arrowshape.backward")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    
                    Button {
                        print("user requests to change bus")
                    } label: {
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                            
                            ZStack {
                                
                                Text("").frame(width: 175, height: 225)
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
                                    
                                    Spacer().frame(height: 20)
                                    
                                    Image(systemName: "arrow.clockwise")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 75)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            stopMonitoringFetcher.fetchStopMonitoring(monitoringRef: busStop.code, lineRef: busRoute.lineRef.replacingOccurrences(of: " ", with: "%20"))
        }
    }
}

struct BusTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        BusTrackingView(busStop: BusStopRoute.sampleData, busRoute: RouteDetail.sampleData)
    }
}
