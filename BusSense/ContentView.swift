//
//  ContentView.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/4/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var locationManager = LocationManager.shared
    
    @State private var busStops = [BusStop]()
    @State private var busRoutes = [BusRoutes]()
    @State private var busRouteNames = [String]()
    
    func nearestBusStop() {
        
        // stop for location api call
//        var request1 = URLRequest(url: URL(string: "http://bustime.mta.info/api/where/stops-for-location.json?lat=40.81666286321624&lon=-73.95375720902423&key=d0a7717c-417c-43cc-862b-5b513bb63753&radius=10")!,timeoutInterval: Double.infinity)
        
        var request1 = URLRequest(url: URL(string: "http://bustime.mta.info/api/where/stops-for-location.json?lat=40.83312769175062&lon=-73.86679670244578&key=d0a7717c-417c-43cc-862b-5b513bb63753&radius=200")!,timeoutInterval: Double.infinity)
        request1.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request1) { data, response, error in
            if let data = data {
                print("data fetched")
                if let decodedResponse = try? JSONDecoder().decode(RawServerResponseStopsForLocation.self, from: data) {
                    print("data decoded")
                    // we have good data – go back to the main thread
                    
                    DispatchQueue.main.async {
                        // update our UI
                        self.busStops = decodedResponse.data.stops
                        self.busRoutes = decodedResponse.data.stops[0].routes
                    }
                    print(decodedResponse.data.stops[0].name)
                }
            } else {
                // if we're still here it means there was a problem
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
        }.resume()
    }
    
    var body: some View {
        NavigationView{
            ZStack {

                Color("Color1").ignoresSafeArea()
                
                VStack {
                    
                    if locationManager.userLocation == nil {
                        Text("Current Bus Stop:\nAMSTERDAM AV/W 131 ST (NE)")
                            .frame(width: 375, height: 200)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .background(Color("Color2"))
                            .cornerRadius(20)
                            .onAppear() {
                                LocationManager.shared.requestLocation()
                            }
                    } else if let location = locationManager.userLocation {
                        VStack {
                            
                            if (busStops.count != 0) {
                                Text("Nearest Bus Stop:\n\(busStops[0].name)")
                                    .frame(width: 375, height: 200)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .background(Color("Color2"))
                                    .cornerRadius(20)
                                    .frame(maxWidth: .infinity)
                            }
                        }.onAppear(perform: nearestBusStop)
                    }
                    
                    Spacer()
                    
                    
                    Image("logo2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200).cornerRadius(20)
                    
                    Spacer()
                    
                    ZStack {
                        
                        Text("")
                            .frame(width: 375, height: 300)
                            .background(Color("Color2"))
                            .cornerRadius(20)
                        
                        VStack {
                            
                            Spacer().frame(height: 10)
                            
                            Text("Select Your Bus:")
                                .frame(width: 300, height: 50)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                                .background(Color("Color1"))
                                .cornerRadius(5)
                                .padding(10)
                            
                            Spacer().frame(height: 25)
                            
                            ForEach(busRoutes, id: \.id) { route in
                                Button {
                                    print(route.shortName)
                                } label: {
                                    NavigationLink(destination: BusTrackingView(busStop: busStops[0], busRoute: route).navigationBarBackButtonHidden(true)) {
                                        Text("\(route.shortName) \(route.longName)").frame(width: 300, height: 35, alignment: .leading)
                                            .padding(10)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.black)
                                            .background(Color("Color1"))
                                            .cornerRadius(10)
                                    }
                                }
                                Spacer().frame(height: 5)
                            }
                        }.frame(width: 350, height: 300, alignment: .top)
                    }.frame(width: 375, height: 350)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
