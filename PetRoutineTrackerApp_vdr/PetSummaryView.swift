//
//  PetSummaryView.swift
//  PetRoutineTrackerApp_vdr
//
//  Created by BMIIT on 05/12/25.
//

import SwiftUI
import CoreData

struct PetSummaryView: View {
    
    @StateObject private var viewModel = PetListViewModel()
    
    private let petTypes = [
        "Dog",
        "Cat",
        "Bird",
        "Rabbit",
        "Fish",
        "Hamster",
        "Turtle",
        "Reptile",
        "Other"
    ]
    
    struct PetTypeSummary: Identifiable {
        let id = UUID()
        let type: String
        let count: Int
        let samplePet: Pet?
    }
    
    private var summaries: [PetTypeSummary] {
        petTypes.compactMap { type in
            let petsOfType = viewModel.pets.filter { ($0.petType ?? "") == type }
            let count = petsOfType.count
            if count == 0 {
                return nil
            }
            return PetTypeSummary(type: type, count: count, samplePet: petsOfType.first)
        }
    }
    
    var body: some View {
        ZStack {
            Color(white: 0.93)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                
                if summaries.isEmpty {
                    Text("No pets added yet.")
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                } else {
                    List {
                        Section(header: Text("Pets by Type")) {
                            ForEach(summaries) { summary in
                                NavigationLink(
                                    destination: PetTypeListView(
                                        type: summary.type,
                                        viewModel: viewModel
                                    )
                                ) {
                                    HStack(spacing: 12) {
                                        typeIcon(for: summary)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(summary.type)
                                                .font(.headline)
                                            Text("\(summary.count) pet(s)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                                                                
                                    }
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.05),
                                                    radius: 2,
                                                    x: 0,
                                                    y: 1)
                                    )
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding(.top, 8)
            .navigationTitle("Pet Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func typeIcon(for summary: PetTypeSummary) -> Image {
        if let pet = summary.samplePet,
           let data = pet.petPhotoData,
           let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        
        switch summary.type {
        case "Dog":
            return Image(systemName: "dog.fill")
        case "Cat":
            return Image(systemName: "cat.fill")
        case "Bird":
            return Image(systemName: "bird.fill")
        case "Fish":
            return Image(systemName: "fish.fill")
        case "Rabbit":
            return Image(systemName: "hare.fill")
        case "Hamster":
            return Image(systemName: "hamster.fill")
        case "Turtle", "Reptile":
            return Image(systemName: "tortoise.fill")
        default:
            return Image(systemName: "pawprint.fill")
        }
    }
}

struct PetSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PetSummaryView()
        }
    }
}

