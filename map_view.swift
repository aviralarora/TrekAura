//
//  map_view.swift
//  TrekAura
//
//  Created by Aviral Arora on 29/08/23.
//

import Foundation
import SwiftUI
import MapKit

struct map_view: View {
    @State private var searchText = ""
    @State private var selectedPlace: IdentifiablePlacemark? = nil
    @State private var showingPlaceDetails = false

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        VStack {
            SearchBar(text: $searchText, onSearchButtonClicked: searchButtonClicked)
                .padding()

            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.none), annotationItems: [selectedPlace].compactMap { $0 }) { place in
                MapPin(coordinate: place.placemark.coordinate, tint: .blue)
            }
            .onAppear(perform: {
                searchButtonClicked()
            })

            if selectedPlace != nil {
                Button("Show Details") {
                    showingPlaceDetails = true
                }
                .padding()
                .sheet(isPresented: $showingPlaceDetails) {
                    if let selectedPlace = selectedPlace {
                        PlaceDetailsView(placemark: selectedPlace.placemark)
                    }
                }
            }
        }
    }

    func searchButtonClicked() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response, let firstItem = response.mapItems.first else {
                return
            }

            selectedPlace = IdentifiablePlacemark(placemark: firstItem.placemark)
            region.center = firstItem.placemark.coordinate
        }
    }
}

struct IdentifiablePlacemark: Identifiable {
    var id = UUID()
    var placemark: MKPlacemark
}

struct SearchBar: View {
    @Binding var text: String
    var onSearchButtonClicked: () -> Void

    var body: some View {
        HStack {
            TextField("Search for a location", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                onSearchButtonClicked()
            }) {
                Text("Search")
            }
            .padding(.trailing)
        }
    }
}

struct PlaceDetailsView: View {
    var placemark: MKPlacemark

    var body: some View {
        VStack(alignment: .leading) {
            Text(placemark.name ?? "")
                .font(.title)
            Text("\(placemark.locality ?? ""), \(placemark.administrativeArea ?? "")")
                .font(.subheadline)
            Spacer()
        }
        .padding()
    }
}

struct map_view_Preview: PreviewProvider {
    static var previews: some View {
        map_view()
    }
}

