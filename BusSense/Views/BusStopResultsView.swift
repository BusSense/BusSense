//
//  BusStopResultsView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/22/23.
//

import SwiftUI

struct BusStopResultsView: View {
    @ObservedObject var busStopRoutes: BusStopRoutesBuilder
//    var busStopRoutes: [BusStopRoute]
    
    var body: some View {
        ZStack {
            Color("Color1").ignoresSafeArea()
            
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
            
            VStack {
//                Text("This is where the list of bus stops and available routes to track go!")
//                    .multilineTextAlignment(.center)
//                    .background(Color.green)
//                    .cornerRadius(5)
                ForEach(busStopRoutes.busStopRoutes, id: \.id) { route in
                    Button {
                        print(route.routes)
                    } label: {
                        NavigationLink(destination: BusTrackingView(busStop: busStopRoutes.busStopRoutes, busRoute: route).navigationBarBackButtonHidden(true)) {
                            Text("\(route.shortName) \(route.longName)").frame(width: 300, height: 35, alignment: .leading)
                                .padding(10)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                                .background(Color("Color1"))
                                .cornerRadius(10)
                        }
                    }
            }.onAppear() {
                print(busStopRoutes.busStopRoutes)
            }
        }
        
        
//        NavigationView{
//            ZStack {
//                Color("Color1").ignoresSafeArea()
//
//                VStack {
//                    if locationManager.userLocation == nil {
//                        Text("Current Bus Stop:\nAMSTERDAM AV/W 131 ST (NE)")
//                            .frame(width: 375, height: 200)
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundColor(Color.white)
//                            .multilineTextAlignment(.center)
//                            .background(Color("Color2"))
//                            .cornerRadius(20)
//                            .onAppear() {
//                                LocationManager.shared.requestLocation()
//                            }
//                    } else if let location = locationManager.userLocation {
//                        VStack {
//
//                            if (busStops.count != 0) {
//                                Text("Nearest Bus Stop:\n\(busStops[0].name)")
//                                    .frame(width: 375, height: 200)
//                                    .font(.title2)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(Color.white)
//                                    .multilineTextAlignment(.center)
//                                    .background(Color("Color2"))
//                                    .cornerRadius(20)
//                                    .frame(maxWidth: .infinity)
//                            }
//                        }.onAppear(perform: nearestBusStop)
//                    }
//
//                    Spacer()
//
//
//                    Image("logo2")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 200).cornerRadius(20)
//
//                    Spacer()
//
//                    ZStack {
//
//                        Text("")
//                            .frame(width: 375, height: 300)
//                            .background(Color("Color2"))
//                            .cornerRadius(20)
//
//                        VStack {
//
//                            Spacer().frame(height: 10)
//
//                            Text("Select Your Bus:")
//                                .frame(width: 300, height: 50)
//                                .font(.title2)
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.black)
//                                .multilineTextAlignment(.center)
//                                .background(Color("Color1"))
//                                .cornerRadius(5)
//                                .padding(10)
//
//                            Spacer().frame(height: 25)
//
//                            ForEach(busRoutes, id: \.id) { route in
//                                Button {
//                                    print(route.shortName)
//                                } label: {
//                                    NavigationLink(destination: BusTrackingView(busStop: busStops[0], busRoute: route).navigationBarBackButtonHidden(true)) {
//                                        Text("\(route.shortName) \(route.longName)").frame(width: 300, height: 35, alignment: .leading)
//                                            .padding(10)
//                                            .font(.title3)
//                                            .fontWeight(.bold)
//                                            .foregroundColor(Color.black)
//                                            .background(Color("Color1"))
//                                            .cornerRadius(10)
//                                    }
//                                }
//                                Spacer().frame(height: 5)
//                            }
//                        }.frame(width: 350, height: 300, alignment: .top)
//                    }.frame(width: 375, height: 350)
        
        
                    
        // old code
//        NavigationView{
//            ZStack {
//                
//                Color("Color1").ignoresSafeArea()
//                
//                VStack {
//                    
//                    Image("logo")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                    
//                    Spacer()
//                    
//                    if locationManager.userLocation == nil {
//                        Text("Current Bus Stop:\nAMSTERDAM AV/W 131 ST (NE)")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundColor(Color.white)
//                            .multilineTextAlignment(.center)
//                            .padding()
//                            .background(Color("Color2"))
//                            .cornerRadius(20)
//                            .onAppear() {
//                                LocationManager.shared.requestLocation()
//                            }
//                    } else if let location = locationManager.userLocation {
//                        Text("Current Bus Stop:\n\(location.coordinate.longitude), \(location.coordinate.latitude)")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundColor(Color.white)
//                            .multilineTextAlignment(.center)
//                            .padding()
//                            .background(Color("Color2"))
//                            .cornerRadius(20)
//                    }
//                    
//                    Text("Select Buses:")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                    
//                    // TODO: - Display JSON data
//                    //                    List {
//                    //                        for (busNumber, routeDescription) in sampleBusData {
//                    //                            Button {
//                    //                                print("\(busNumber)")
//                    //                            } label: {
//                    //                                NavigationLink(destination: BusConfimationView()) {
//                    //                                    Text("\(busNumber) - \(routeDescription)")
//                    //                                        .font(.title)
//                    //                                        .fontWeight(.bold)
//                    //                                        .foregroundColor(Color.white)
//                    //                                        .multilineTextAlignment(.center)
//                    //                                        .padding()
//                    //                                        .background(Color("Color2"))
//                    //                                        .cornerRadius(20)
//                    //                                }
//                    //                            }
//                    //                        }
//                    //                    }
//                    //                    .padding()
//                    
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
//                }
//            }
//        }
    }
}

struct BusStopResultsView_Previews: PreviewProvider {
    static var previews: some View {
        BusStopResultsView(busStopRoutes: BusStopRoutesBuilder())
    }
}
