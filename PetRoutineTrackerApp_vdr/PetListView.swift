//
//  PetListView.swift
//  PetRoutineTrackerApp_vdr
//
//  Created by BMIIT on 02/12/25.
//

import SwiftUI

struct PetListView: View {
    
    @StateObject private var viewModel = PetListViewModel()
    @State private var showingAddPet = false
    
    @State private var showDeleteAlert = false
    @State private var indexSetToDelete: IndexSet?
    
    @State private var showEditPet = false
    @State private var petToEdit: Pet?
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(white: 0.90)
                    .ignoresSafeArea()
                
                List {
                    ForEach(viewModel.pets) { pet in
                        NavigationLink(destination: PetDetailView(pet: pet, viewModel: viewModel)) {
                            HStack(spacing: 12) {
                                if let data = pet.petPhotoData,
                                   let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "pawprint.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.blue)
                                }
                                
                                Text(pet.petName ?? "Unnamed pet")
                                    .font(.headline)
                                
                                Spacer()
                                                               
                            }
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.08),
                                            radius: 3,
                                            x: 0,
                                            y: 2)
                            )
                        }
                    }
                    .onDelete{ offsets in
                        indexSetToDelete = offsets
                        showDeleteAlert = true
                    }
                }
                .listStyle(.plain)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .navigationTitle("My Pets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Delete Pet", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {
                }
                Button("Delete", role: .destructive) {
                    if let offsets = indexSetToDelete {
                        viewModel.deletePet(at: offsets)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this pet?")
            }
            .sheet(isPresented: $showingAddPet) {
                AddPetView(viewModel: viewModel)
            }
            .sheet(isPresented: $showEditPet) {
                if let pet = petToEdit {
                    EditPetView(pet: pet, viewModel: viewModel)
                }
            }
        }
    }
}

struct PetListView_Previews: PreviewProvider {
    static var previews: some View {
        PetListView()
    }
}

