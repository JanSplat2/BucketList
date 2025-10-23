//
//  ContentView.swift
//  BucketList
//
//  Created by Dittrich, Jan - Student on 10/21/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    // MARK: - Locations
    let cityCenter = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco
    let location1 = CLLocationCoordinate2D(latitude: 37.4221, longitude: -122.0853) // Google
    let location2 = CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090) // Apple
    let location3 = CLLocationCoordinate2D(latitude: 37.4851, longitude: -122.1483) // Meta
    let location4 = CLLocationCoordinate2D(latitude: 34.1016, longitude: -118.3296) // Walk of Fame
    let location5 = CLLocationCoordinate2D(latitude: 36.5323, longitude: -116.9325) // Death Valley
    
    @State private var camera: MapCameraPosition = .automatic
    @State private var selectedAttraction: Attraction? = nil
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $camera) {
                Annotation("Google Headquarters", coordinate: location1) {
                    Text("G")
                        .foregroundStyle(.white)
                        .padding()
                        .background(.green)
                        .clipShape(Circle())
                }
                Annotation("Apple Headquarters", coordinate: location2) {
                    Image(systemName: "applelogo")
                        .foregroundStyle(.black)
                        .padding()
                        .background(.white)
                        .clipShape(Circle())
                }
                Annotation("Meta Headquarters", coordinate: location3) {
                    Text("∞")
                        .foregroundStyle(.white)
                        .padding()
                        .background(.blue)
                        .clipShape(Circle())
                }
                Annotation("Walk of Fame", coordinate: location4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .padding()
                        .background(.black)
                        .clipShape(Circle())
                }
                Annotation("Death Valley", coordinate: location5) {
                    Text("💀")
                        .padding()
                        .background(.black)
                        .clipShape(Circle())
                }
            }
            .mapStyle(.hybrid)
            .onAppear {
                camera = .region(MKCoordinateRegion(center: cityCenter, latitudinalMeters: 30000, longitudinalMeters: 30000))
            }
            
            VStack {
                Text("San Francisco / California")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(8)
                    .background(.thinMaterial)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                Spacer()
            }
            .padding(.top, 40)
        }
        
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                Button {
                    moveTo(location1, name: "Google HQ", description: "Google's global headquarters, located in Mountain View, California. Home to innovation, AI, and the famous Android lawn statues.")
                } label: {
                    Text("Google")
                }
                Spacer()
                Button {
                    moveTo(location2, name: "Apple Park", description: "Apple’s futuristic campus, shaped like a spaceship, in Cupertino. A marvel of design and sustainability.")
                } label: {
                    Text("Apple")
                }
                Spacer()
                Button {
                    moveTo(location3, name: "Meta HQ", description: "Meta’s headquarters, home to Facebook, Instagram, and VR development. Known for its open and creative workspace.")
                } label: {
                    Text("Meta")
                }
                Spacer()
                Button {
                    moveTo(location4, name: "Hollywood Walk of Fame", description: "An iconic Los Angeles landmark honoring thousands of celebrities across the entertainment industry.")
                } label: {
                    Text("Walk of Fame")
                }
                Spacer()
                Button {
                    moveTo(location5, name: "Death Valley", description: "One of the hottest places on Earth, offering stunning desert landscapes and dramatic views.")
                } label: {
                    Text("DV")
                }
                Spacer()
            }
            .padding()
            .background(.thinMaterial)
        }
        
        // Sheet showing details
        .sheet(item: $selectedAttraction) { attraction in
            AttractionDetailView(attraction: attraction, cityCenter: cityCenter)
        }
    }
    
    // MARK: - Functions
    func moveTo(_ coordinate: CLLocationCoordinate2D, name: String, description: String) {
        camera = .region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800))
        selectedAttraction = Attraction(name: name, coordinate: coordinate, description: description)
    }
}

// MARK: - Attraction Model
struct Attraction: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let description: String
}

// MARK: - Attraction Detail View (Sheet)
struct AttractionDetailView: View {
    var attraction: Attraction
    var cityCenter: CLLocationCoordinate2D
    
    var distanceFromCity: Double {
        let attractionLocation = CLLocation(latitude: attraction.coordinate.latitude, longitude: attraction.coordinate.longitude)
        let cityLocation = CLLocation(latitude: cityCenter.latitude, longitude: cityCenter.longitude)
        return attractionLocation.distance(from: cityLocation) / 1000
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(attraction.name)
                .font(.largeTitle)
                .bold()
            
            Map(initialPosition: .region(MKCoordinateRegion(center: attraction.coordinate, latitudinalMeters: 500, longitudinalMeters: 500))) {
                Marker(attraction.name, coordinate: attraction.coordinate)
            }
            .frame(height: 250)
            .cornerRadius(12)
            .shadow(radius: 5)
            
            Text(attraction.description)
                .padding()
                .multilineTextAlignment(.center)
            
            Divider()
            
            Text("📍 Distance from San Francisco: \(String(format: "%.1f", distanceFromCity)) km")
                .font(.headline)
                .padding(.bottom, 10)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
