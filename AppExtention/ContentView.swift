//
//  ContentView.swift
//  AppExtention
//
//  Created by  inna on 01/02/2021.
//

import SwiftUI
import DFetcher
import UIFetchComponents

final class TwoColumnScreenViewModel: ObservableObject {

    @Published private(set) var items: String = ""
    
    
    init() {
        fetchedData()
    }
    
    func fetchedData() {
        items.append(DFetcher.fetchedSharedData())
    }
    
}

struct ContentView: View {
    
    @StateObject var  viewModel: TwoColumnScreenViewModel = .init()
  
    
    var body: some View {
        VStack(spacing: 10) {
            TableViewFetch(data: viewModel.items)
        }.onAppear {
            viewModel.fetchedData()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
