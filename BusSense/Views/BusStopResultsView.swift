//
//  BusStopResultsView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/22/23.
//

import SwiftUI

struct BusStopResultsView: View {
    @ObservedObject var busStopRoutes: BusStopRoutesBuilder
    
    var body: some View {
        
               
        NavigationView {
            
            ZStack {
                
                //                                Image("logo")
                //                                    .resizable()
                //                                    .aspectRatio(contentMode: .fit)
                //                                    .frame(width: 300, height: 300)
                                
                GeometryReader { geometry in
                    ScrollView(.horizontal) {
                        
                        HStack(alignment: .center, spacing: 20) {
                            
                            ForEach(busStopRoutes.busStopRoutes, id: \.id) { stop in
                                
                                VStack {
                                    
                                    VStack {
                                        Text("Bus Stop Name:")
                                            .font(.title3)
                                            .foregroundColor(Color.white)
                                            .multilineTextAlignment(.center)
                                        
                                        Spacer().frame(height: 10)
                                        
                                        Text("\(stop.name)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                            .multilineTextAlignment(.center)
                                    }.frame(width: 350, height: 150).background(Color("Color2"))
                                    
                                    Spacer().frame(height: 150)
                                    
                                    VStack {
                                        Spacer().frame(height: 10)
                                                                    
                                        Text("Select Your Bus:")
                                            .frame(width: 300, height: 50)
                                            .font(.title2)
                                            .foregroundColor(Color.white)
                                            .multilineTextAlignment(.center)
                                            .padding(10)
                                        
                                        ForEach(stop.routes, id: \.lineRef) { route in
                                            
                                            Button (action: {
                                                print(route.lineNameAndDestinationName)
                                            }, label: {
                                                NavigationLink(destination: BusTrackingView(busStop: stop, busRoute: route).navigationBarBackButtonHidden(true)) {
                                                    Text("\(route.lineNameAndDestinationName)").frame(width: 300, height: 50, alignment: .leading)
                                                        .padding(10)
                                                        .font(.title3)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.black)
                                                        .background(Color("Color1"))
                                                        .cornerRadius(10)
                                                }
                                            })
                                        }.onAppear() {
                                            print(busStopRoutes.busStopRoutes)
                                        }
                                    }.frame(width: 350, height: 400, alignment: .top).background(Color("Color2"))
                                    
                                }
                                .frame(width: 375, height: 750, alignment: .center)
                                .background(Color("Color1"))
                                .cornerRadius(20)
                            }
                        }.frame(width: geometry.size.width)
                    }
                }
//                ScrollView(.horizontal) {
//                    HStack(alignment: .center, spacing: 20) {
//                        VStack {
//
//                            Image("logo")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 300, height: 300)
//
//                            ForEach(busStopRoutes.busStopRoutes, id: \.id) { stop in
//
//                                VStack {
//                                    Text("Bus Stop Name:")
//                                        .font(.title3)
//                                        .foregroundColor(Color.black)
//                                        .multilineTextAlignment(.center)
//
//                                    Text("\(stop.name)")
//                                        .font(.title)
//                                        .fontWeight(.bold)
//                                        .foregroundColor(Color.black)
//                                        .multilineTextAlignment(.center)
//                                }.frame(width: 350, height: 150).background(Color("Color1"))
//
//                                ForEach(stop.routes, id: \.lineRef) { route in
//
//                                    Button (action: {
//                                        print(route.lineNameAndDestinationName)
//                                    }, label: {
//                                        NavigationLink(destination: BusTrackingView(busStop: stop, busRoute: route).navigationBarBackButtonHidden(true)) {
//                                            Text("\(route.lineNameAndDestinationName)").frame(width: 300, height: 35, alignment: .leading)
//                                                .padding(10)
//                                                .font(.title3)
//                                                .fontWeight(.bold)
//                                                .foregroundColor(Color.black)
//                                                .background(Color("Color1"))
//                                                .cornerRadius(10)
//                                        }
//                                    })
//                                }.onAppear() {
//                                    print(busStopRoutes.busStopRoutes)
//                                }
//                            }
//                        }
//                        .frame(width: 375, height: 700, alignment: .center)
//                        .background(Color("Color2"))
//                        .cornerRadius(20)
//                    }.frame(width: geometry.size.width)
//                }
            }
        }
        
        
                    
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
