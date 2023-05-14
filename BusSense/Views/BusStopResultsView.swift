//
//  BusStopResultsView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/22/23.
//

import SwiftUI
import AVFoundation

struct BusStopResultsView: View {
    @ObservedObject var busStopRoutes: BusStopRoutesBuilder
//    @ObservedObject var busStopRoutes: MTA
    let speechSynthesizer = SpeechSynthesizer()
    let radius = 10.0
    
    
    var body: some View {
        
               
        NavigationView {
            
            ZStack {
                
                Color("Color3").ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                        Image("logoBus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 75, height: 75)
                        
                        Image("logoImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                        
                        Image("logoSense")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }.frame(width: 100, height: 100)
                    
                    GeometryReader { geometry in
                        
                        TabView() {
                                                        
                            ForEach(busStopRoutes.busStopRoutes, id: \.id) { stop in
                                
                                VStack {
                                    
                                    VStack {
                                                                                
                                        Text("Bus Stop Name:")
                                            .font(.title3)
                                            .foregroundColor(Color.white)
                                            .multilineTextAlignment(.center)
//                                            .onAppear() {
//                                                speechSynthesizer.speak("bus stop name")
//                                            }
                                        
                                        Spacer().frame(height: 10)
                                        
                                        Text("\(stop.name)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                            .multilineTextAlignment(.center)
                                            .onAppear() {
                                                speechSynthesizer.speak("\(stop.name)")
                                            }
                                    }
                                    .frame(width: 350, height: 150)
                                    .background(Color("Color2"))
                                    .cornerRadius(radius)
                                    
                                    Spacer().frame(height: 50)

                                    VStack {
                                        Spacer().frame(height: 20)
                                                                    
                                        Text("Select Your Bus:")
                                            .frame(width: 300, height: 50)
                                            .font(.title2)
                                            .foregroundColor(Color.white)
                                            .multilineTextAlignment(.center)
                                            .padding(10)
//                                            .onAppear() {
//                                                speechSynthesizer.speak("select your bus")
//                                            }
                                        
                                        Spacer().frame(height: 10)
                                        
                                        ForEach(stop.routes, id: \.lineRef) { route in
                                            
                                            Button (action: {
                                                print(route.lineNameAndDestinationName)
                                            }, label: {
                                                NavigationLink(destination: BusTrackingView(busStop: stop, busRoute: route).navigationBarBackButtonHidden(false)) {
                                                    Text("\(route.lineNameAndDestinationName)").frame(width: 300, height: 50, alignment: .leading)
                                                        .padding(10)
                                                        .font(.title3)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.black)
                                                        .background(Color("Color1"))
                                                        .cornerRadius(10)
                                                        .onAppear() {
                                                            speechSynthesizer.speak("\(route.lineNameAndDestinationName)")
                                                        }
                                                }
                                            })
                                            
                                            Spacer().frame(height: 20)
                                        }.onAppear() {
                                            print(busStopRoutes.busStopRoutes)
                                        }
                                    }
                                    .frame(width: 350, height: 400, alignment: .top)
                                    .background(Color("Color2"))
                                    .cornerRadius(radius)
                                }
                                .frame(width: 375, height: 650, alignment: .center)
                                .background(Color("Color1"))
                                .cornerRadius(radius)
                            }
                        }
                        .tabViewStyle(.page)
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                    }
                }
            }
        }
    }
}

struct BusStopResultsView_Previews: PreviewProvider {
    static var previews: some View {
        BusStopResultsView(busStopRoutes: BusStopRoutesBuilder())
//        BusStopResultsView(busStopRoutes: MTA())
    }
}
