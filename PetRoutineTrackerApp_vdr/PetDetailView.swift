//
//  PetDetailView.swift
//  PetRoutineTrackerApp_vdr
//
//  Created by BMIIT on 02/12/25.
//

import SwiftUI
import CoreData

struct PetDetailView: View {
    
    let pet: Pet
    
    @ObservedObject var viewModel: PetListViewModel
    @StateObject private var routineViewModel = RoutineListViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showAddRoutine = false
    @State private var showEditRoutine = false
    @State private var routineToEdit: Routine?
    
    @State private var showEditPet = false
    @State private var petToEdit: Pet?
    
    @State private var showRoutineDeleteAlert = false
    @State private var routineOffsetsToDelete: IndexSet?

    var body: some View {
        ZStack{
            Color(white: 0.93)
                .ignoresSafeArea()
            
                VStack(alignment: .leading, spacing: 16) {

                    VStack(alignment: .leading, spacing: 8) {
                        if let data = pet.petPhotoData,
                           let uiImage = UIImage(data: data) {
                            HStack {
                                Spacer()
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .padding(.bottom, 8)
                                Spacer()
                            }
                        }

                        Text(pet.petName ?? "Unnamed pet")
                            .font(.title)
                            .bold()

                        Text("Type: \(pet.petType ?? "Unknown")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        if let details = pet.petDetails, !details.isEmpty {
                            Text("Details: ")
                                .font(.headline)
                            Text(details)
                        } else {
                            Text("No extra details added.")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.08),
                                    radius: 4,
                                    x: 0,
                                    y: 2)
                    )
                    Divider()
                    
                    HStack {
                        Text("Routines")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Button {
                            showAddRoutine = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                    }
                    
                    if routineViewModel.routines.isEmpty {
                        Text("No routines yet. (We will add this soon!)")
                            .foregroundColor(.secondary)
                    } else {
                        List {
                            ForEach(routineViewModel.routines) { routine in
                                NavigationLink(
                                    destination: RoutineDetailView(
                                        routineViewModel: routineViewModel,
                                        pet: pet,
                                        routine: routine
                                    )
                                ) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(routine.routineTitle ?? "Untitled routine")
                                            .font(.headline)

                                        if let time = routine.timeOfDay {
                                            Text(time.formatted(date: .omitted, time: .shortened))
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }

                                        if let note = routine.routineNote, !note.isEmpty {
                                            Text(note)
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                    )
                                }
                            }
                            .onDelete { offsets in
                                routineOffsetsToDelete = offsets
                                showRoutineDeleteAlert = true
                            }
                        }
                        .listStyle(.plain)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .frame(maxHeight: 250)
                    }
                    Spacer(minLength: 0)
                }
            .padding()
        }
        .navigationTitle("Pet Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEditPet = true
                    petToEdit = pet
                }
            }
        }
        .onAppear {
            routineViewModel.loadRoutines(for: pet)
        }
        .sheet(isPresented: $showAddRoutine) {
            AddRoutineView(pet: pet, routineViewModel: routineViewModel)
        }
        .sheet(isPresented: $showEditPet) {
            if let petToEdit = petToEdit {
                EditPetView(pet: petToEdit, viewModel: viewModel)
            }
        }
        .alert("Delete Routine",
                isPresented: $showRoutineDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if let offsets = routineOffsetsToDelete {
                    routineViewModel.deleteRoutine(at: offsets, for: pet)
                }
            }
        } message: {
            Text("Are you sure you want to delete this routine?")
        }
    }   
}

struct PetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Preview not configured")
    }
}
