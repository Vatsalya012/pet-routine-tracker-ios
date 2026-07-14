//
//  AddRoutineView.swift
//  PetRoutineTrackerApp_vdr
//
//  Created by BMIIT on 03/12/25.
//

import SwiftUI
import CoreData

struct AddRoutineView: View {
    let pet: Pet
    @ObservedObject var routineViewModel: RoutineListViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var time: Date = Date()
    @State private var repeatRule: String = "Daily"
    @State private var note: String = ""

    let repeatOptions = [
        "Daily",
        "Weekends",
        "Alternate Days",
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
    ]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Routine Info")) {
                    HStack {
                        Image(systemName: "text.badge.star")
                            .foregroundColor(.blue)
                        TextField("Title (e.g. Morning Walk)", text: $title)
                    }

                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.orange)
                        DatePicker("Time",
                                   selection: $time,
                                   displayedComponents: .hourAndMinute)
                    }

                    HStack {
                        Image(systemName: "repeat")
                            .foregroundColor(.purple)
                        Picker("Repeat", selection: $repeatRule) {
                            ForEach(repeatOptions, id: \.self) { option in
                                Text(option)
                            }
                        }
                    }

                    HStack(alignment: .top) {
                        Image(systemName: "note.text")
                            .foregroundColor(.green)
                            .padding(.top, 6)
                        TextField("Note (optional)", text: $note, axis: .vertical)
                    }
                }
            }

            .navigationTitle("Add Routine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
                        guard !trimmedTitle.isEmpty else { return }

                        routineViewModel.addRoutine(for: pet,
                                                    title: trimmedTitle,
                                                    time: time,
                                                    repeatRule: repeatRule,
                                                    note: note)

                        dismiss()
                    } label: {
                        Text("Save")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .tint(.blue)
    }
}

struct AddRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        Text("AddRoutineView preview not configured")
    }
}
