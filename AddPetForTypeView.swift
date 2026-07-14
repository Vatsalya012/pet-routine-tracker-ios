//
//  AddPetForTypeView.swift
//  PetRoutineTrackerApp_vdr
//
//  Created by BMIIT on 05/12/25.
//

import SwiftUI
import CoreData

struct AddPetForTypeView: View {
    
    let type: String
    @ObservedObject var viewModel: PetListViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var details: String = ""
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("\(type) Info")) {
                    HStack {
                        Image(systemName: "pawprint.fill")
                            .foregroundColor(.blue)
                        TextField("Name", text: $name)
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
                            Text("Select Photo")
                        }
                    }
                }
            }
            .navigationTitle("Add \(type)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let trimmedName = name.trimmingCharacters(in: .whitespaces)
                        guard !trimmedName.isEmpty else { return }
                        
                        let photoData = selectedImage?.jpegData(compressionQuality: 0.8)
                        
                        viewModel.addPet(name: trimmedName,
                                         type: type,          // ✅ fixed type
                                         details: details,
                                         photoData: photoData)
                        dismiss()
                    } label: {
                        Text("Save")
                            .fontWeight(.semibold)
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

