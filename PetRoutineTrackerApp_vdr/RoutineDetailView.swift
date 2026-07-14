//
//  RoutineDetailView.swift
//  PetRoutineTrackerApp_vdr
//
//  Created by BMIIT on 03/12/25.
//

import SwiftUI
import CoreData

struct RoutineDetailView: View {
    
    @ObservedObject var routineViewModel: RoutineListViewModel
    let pet: Pet
    let routine: Routine
        
    @State private var showEditRoutine = false
    
    var body: some View {
        ZStack {
            Color(white: 0.93)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 12) {
                
                HStack(spacing: 6) {
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                    Text("Routine for \(pet.petName ?? "your pet")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text(routine.routineTitle ?? "Untitled routine")
                        .font(.title2)
                        .bold()
                    
                    if let time = routine.timeOfDay {
                        HStack(spacing: 8) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.blue)
                            Text(time.formatted(date: .omitted, time: .shortened))
                        }
                        .font(.subheadline)
                    }
                    
                    if let repeatRule = routine.repeatRule, !repeatRule.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Image(systemName: "repeat")
                                    .foregroundColor(.orange)
                                Text("Repeat")
                                    .font(.headline)
                            }
                            
                            Text(repeatRule)
                                .font(.subheadline)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .background(
                                    Capsule()
                                        .fill(Color.orange.opacity(0.1))
                                )
                        }
                    }
                    
                    if let note = routine.routineNote, !note.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Image(systemName: "note.text")
                                    .foregroundColor(.green)
                                Text("Notes")
                                    .font(.headline)
                            }
                            
                            Text(note)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(.top, 2)
                        }
                    } else {
                        Text("No extra notes added for this routine.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08),
                                radius: 4,
                                x: 0,
                                y: 2)
                )
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .navigationTitle("Routine Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showEditRoutine = true
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $showEditRoutine) {
            EditRoutineView(
                routine: routine,
                pet: pet,
                routineViewModel: routineViewModel
            )
        }
    }
}

struct RoutineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Text("RoutineDetailView preview not configured")
    }
}

