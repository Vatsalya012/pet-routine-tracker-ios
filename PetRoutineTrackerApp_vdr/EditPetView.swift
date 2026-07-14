//
//  EditPetView.swift
//  PetRoutineTrackerApp_vdr
//
//  Created by BMIIT on 04/12/25.
//

import SwiftUI
import CoreData

struct EditPetView: View {
    @ObservedObject var viewModel: PetListViewModel
    @Environment(\.dismiss) private var dismiss

    var pet: Pet

    @State private var name: String = ""
    @State private var type: String = "Dog"
    @State private var details: String = ""
    
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    let petTypes = [
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

    init(pet: Pet, viewModel: PetListViewModel) {
        self.pet = pet
        self.viewModel = viewModel

        _name = State(initialValue: pet.petName ?? "")
        _type = State(initialValue: pet.petType ?? "Dog")
        _details = State(initialValue: pet.petDetails ?? "")
        
        if let data = pet.petPhotoData,
            let image = UIImage(data: data) {
            _selectedImage = State(initialValue: image)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pet Info")) {
                    HStack {
                        Image(systemName: "pawprint.fill")
                            .foregroundColor(.blue)
                        TextField("Name", text: $name)
                    }

                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.purple)
                        Picker("Type", selection: $type) {
                            ForEach(petTypes, id: \.self) { t in
                                Text(t)
                            }
                        }
                    }

                    HStack(alignment: .top) {
                        Image(systemName: "text.alignleft")
                            .foregroundColor(.green)
                            .padding(.top, 6)
                        TextField("Details (optional)", text: $details)
                    }
                }

                Section(header: Text("Photo")) {
                    HStack {
                        Spacer()
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                                .padding(.bottom, 8)
                        } else {
                            Image(systemName: "pawprint.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.bottom, 8)
                        }
                        Spacer()
                    }

                    Button {
                        showImagePicker = true
                    } label: {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Change Photo")
                        }
                    }
                }
            }
            .navigationTitle("Edit Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedName = name.trimmingCharacters(in: .whitespaces)
                        guard !trimmedName.isEmpty else { return }

                        let photoData = selectedImage?.jpegData(compressionQuality: 0.8)

                        viewModel.updatePet(pet,
                                            name: trimmedName,
                                            type: type,
                                            details: details,
                                            photoData: photoData)
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
        .tint(.blue)
    }
}


struct EditPetView_Previews: PreviewProvider {
    static var previews: some View {
        Text("EditPetView preview not configured")
    }
}
