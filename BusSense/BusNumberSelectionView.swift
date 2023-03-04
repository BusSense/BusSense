//
//  BusNumberSelectionView.swift
//  BusSense
//
//  Created by Suhaima Islam on 3/3/23.
//

import SwiftUI

func allNumbers(busBorough: String) -> Array<Int> {
    
    var busNumbers = [Int]()
    let nf = NumberFormatter()
    let path = "/Users/suhaimaislam/Downloads/routes.txt"
    
    let contents = try! NSString(contentsOfFile: path,
            encoding: String.Encoding.ascii.rawValue)
    
    let lines = contents.components(separatedBy: "\n")
    for line in lines {
        let arguments = line.split(separator:",")
        if String(arguments[3]) == busBorough {
            let bus_number = nf.number(from: String(arguments[4]))?.intValue ?? 0
            busNumbers.append(bus_number)
        }
    }
    
    return busNumbers
}

func chooseBusNumber(busBorough: String, busNumber: Int) -> Bus {
    
    let desiredBus = busBorough + String(busNumber)
    var bus = Bus()
    
    let path = "/Users/suhaimaislam/Downloads/routes.txt"
    
    let contents = try! NSString(contentsOfFile: path,
            encoding: String.Encoding.ascii.rawValue)
    
    let lines = contents.components(separatedBy: "\n")
    
    for line in lines {
        let arguments = line.split(separator:",")
        if arguments[0] == desiredBus {
            bus = Bus(bound1: String(arguments[1]), bound2: String(arguments[2]), borough: String(arguments[3]), number: busNumber)
            break
        }
    }
    
    return bus
}

struct BusNumberSelectionView: View {
    
    @ObservedObject var bus: Bus
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                Color("Color1").ignoresSafeArea()
                
                ScrollView {
                    let selection = "Bus Letter: " + bus.borough
                    
                    let busNumbers = allNumbers(busBorough: bus.borough)
                    
                    Text(selection)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(30)
                        .background(Color("Color2"))
                        .cornerRadius(20)
                    
                    Text("Select the bus number: ")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(30)
                        .background(Color("Color2"))
                        .cornerRadius(20)
                    
                    List {
                        
                        ForEach(busNumbers, id: \.self) { number in
                            Button {
                                print("GO")
                            } label: {
                                NavigationLink(destination: BusBoundSelectionView(bus: chooseBusNumber(busBorough: bus.borough, busNumber: number))) {
                                    Text("Go")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 65, height: 65)
                                        .background(Color("Color2"))
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct BusNumberSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        BusNumberSelectionView(bus: Bus())
    }
}
