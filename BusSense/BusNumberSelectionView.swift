//
//  BusNumberSelectionView.swift
//  BusSense
//
//  Created by Suhaima Islam on 3/3/23.
//

import SwiftUI

func allNumbers(busBorough: String) -> Array<String> {
    
    var busNumbers = [String]()
    var arguments = [String]()
    
    // read from file
    let fileURL = Bundle.main.url(forResource: "routes", withExtension: "txt")!
    let contents = try! String(contentsOf: fileURL, encoding: String.Encoding.utf8)
    
    var lines = contents.components(separatedBy: "\n")
    lines.removeLast()
    for line in lines {
        arguments = line.components(separatedBy: ",")
        if arguments[3] == busBorough {
//            let bus_number = nf.number(from: String(arguments[4]))?.intValue ?? 0
            busNumbers.append(arguments[4])
        }
    }
    
    return busNumbers
}

func chooseBusNumber(busBorough: String, busNumber: String) -> Bus {
    
    let desiredBus = busBorough + busNumber
    var bus = Bus()
    
    // read from file
    let fileURL = Bundle.main.url(forResource: "routes", withExtension: "txt")!
    let contents = try! String(contentsOf: fileURL, encoding: String.Encoding.utf8)
    
    let lines = contents.components(separatedBy: "\n")
    
    for line in lines {
        let arguments = line.components(separatedBy: ",")
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
                
                ScrollView(.vertical) {
                    
                    let busNumbers = allNumbers(busBorough: bus.borough)
                    
                    let selection = "Bus Letter: " + bus.borough
                    
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
                    
                    // buttons for bus numbers
                    VStack {
                        ForEach(busNumbers, id: \.self) {
                            i in
                            NavigationLink(destination: BusBoundSelectionView(bus: chooseBusNumber(busBorough: bus.borough, busNumber: i))) {
                                Text("\(i)")
                                    .font(.title)
                                    .frame(width:300, height:200)
                                    .foregroundColor(Color.white)
                                    .background(Color("Color2"))
                                    .cornerRadius(20)
                            }
                        }
                        Spacer()
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
