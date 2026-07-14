//
//  PetTypeListView.swift
//  PetRoutineTrackerApp_vdr
//
//  Created by BMIIT on 05/12/25.
//

import SwiftUI
import CoreData

struct PetTypeListView: View {
    
    let type: String
    @ObservedObject var viewModel: PetListViewModel
    
    @State private var showAddPetForType = false
    
    private var filteredPets: [Pet] {
        viewModel.pets.filter { ($0.petType ?? "") == type }
    }
    
    var body: some View {
        ZStack {
            Color(white: 0.93)
                .ignoresSafeArea()
            
            if filteredPets.isEmpty {
                VStack(spacing: 12) {
                    Text("No \(type.lowercased())s added yet.")
                        .foregroundColor(.secondary)
                    Button {
                        showAddPetForType = true
                    } label: {
                        Label("Add first \(type)", systemImage: "plus")
                    }
                }
            } else {
                List {
                    ForEach(filteredPets) { pet in
                        NavigationLink(
                            destination: PetDetailView(
                                pet: pet,
                                viewModel: viewModel
                            )
                        ) {
                            HStack(spacing: 12) {
                                if let data = pet.petPhotoData,
                                   let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "pawprint.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.blue)
                                }
                                
                                Text(pet.petName ?? "Unnamed pet")
                                    .font(.headline)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("\(type)s")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddPetForType = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddPetForType) {
            AddPetForTypeView(type: type, viewModel: viewModel)
        }
    }
}
