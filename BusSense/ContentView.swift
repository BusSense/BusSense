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
        var request1 = URLRequest(url: URL(string: "http://bustime.mta.info/api/where/stops-for-location.json?lat=40.81666286321624&lon=-73.95375720902423&key=d0a7717c-417c-43cc-862b-5b513bb63753&radius=10")!,timeoutInterval: Double.infinity)
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
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color("Color2"))
                            .cornerRadius(20)
                            .onAppear() {
                                LocationManager.shared.requestLocation()
                            }
                    } else if let location = locationManager.userLocation {
                        VStack {
                            
                            if (busStops.count != 0) {
                                Text("Nearest Bus Stop:\n\(busStops[0].name)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(Color("Color2"))
                                    .cornerRadius(20)
                                    .frame(maxWidth: .infinity)
                            }
//                            List(busStops, id: \.id) { item in
//
//                                Text("\(item.name)")
//                                    .font(.title)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(Color.white)
//                                    .multilineTextAlignment(.center)
//                                    .padding()
//                                    .background(Color("Color2"))
//                                    .cornerRadius(20)
//
//                            }
                        }.onAppear(perform: nearestBusStop)
                    }
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 200, height:200)
                    
                    Text("Select Desired Bus Below:")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color("Color2"))
                        .cornerRadius(20)
                    
                    ForEach(busRoutes, id: \.id) { route in
                        Button {
                            print(route.shortName)
                        } label: {
                            NavigationLink(destination: BusTrackingView(busStop: busStops[0], busRoute: route)) {
                                Text("\(route.shortName) \(route.longName)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(Color("Color2"))
                                    .cornerRadius(20)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    
//                    List(busRoutes, id: \.id) { item in
//                        Button {
//                            print("M11")
//                        } label: {
//                            NavigationLink(destination: BusConfimationView()) {
//                                Text("\(item.shortName) \(item.longName)")
//                                    .font(.subheadline)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(Color.white)
//                                    .multilineTextAlignment(.center)
//                                    .padding()
//                                    .background(Color("Color2"))
//                                    .cornerRadius(20)
//                            }
//                        }
//                    }.onAppear(perform: nearestBusStop)
                    
                    
                    // TODO: - Display JSON data
                    //                    List {
                    //                        for (busNumber, routeDescription) in sampleBusData {
                    //                            Button {
                    //                                print("\(busNumber)")
                    //                            } label: {
                    //                                NavigationLink(destination: BusConfimationView()) {
                    //                                    Text("\(busNumber) - \(routeDescription)")
                    //                                        .font(.title)
                    //                                        .fontWeight(.bold)
                    //                                        .foregroundColor(Color.white)
                    //                                        .multilineTextAlignment(.center)
                    //                                        .padding()
                    //                                        .background(Color("Color2"))
                    //                                        .cornerRadius(20)
                    //                                }
                    //                            }
                    //                        }
                    //                    }
                    //                    .padding()
                    
//                    Button {
//                        print("M11")
//                    } label: {
//                        NavigationLink(destination: BusConfimationView()) {
//                            Text("M11 - Riverbank Park & Harlem")
//                                .font(.title)
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.white)
//                                .multilineTextAlignment(.center)
//                                .padding()
//                                .background(Color("Color2"))
//                                .cornerRadius(20)
//                        }
//                    }
//
//                    Button {
//                        print("M100")
//                    } label: {
//                        NavigationLink(destination: BusConfimationView()) {
//                            Text("M100 - Inwood")
//                                .font(.title)
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.white)
//                                .multilineTextAlignment(.center)
//                                .padding()
//                                .background(Color("Color2"))
//                                .cornerRadius(20)
//                        }
//                    }
//
//                    Button {
//                        print("M101")
//                    } label: {
//                        NavigationLink(destination: BusConfimationView()) {
//                            Text("M100 - Fort George")
//                                .font(.title)
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.white)
//                                .multilineTextAlignment(.center)
//                                .padding()
//                                .background(Color("Color2"))
//                                .cornerRadius(20)
//                        }
//                    }
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
