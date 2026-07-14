//
//  PetListViewModel.swift
//  PetRoutineTrackerApp_vdr
//
//  Created by BMIIT on 02/12/25.
//

import Foundation
import CoreData

class PetListViewModel: ObservableObject{
    @Published var pets: [Pet] = []
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        fetchPets()
    }
    
    func fetchPets() {
        let request: NSFetchRequest<Pet> = Pet.fetchRequest()
        let sortByName = NSSortDescriptor(key: "petName", ascending: true)
        request.sortDescriptors = [sortByName]
        do {
            pets = try context.fetch(request)
        } catch {
            print("Error fetching pets: \(error)")
        }
    }
    
    func addPet(name: String,
                type: String,
                details: String,
                photoData: Data?) {
        let newPet = Pet(context: context)
        newPet.petName = name
        newPet.petType = type
        newPet.petDetails = details
        newPet.petPhotoData = photoData

        do {
            try context.save()
            fetchPets()
        } catch {
            print("Error saving new pet: \(error)")
        }
    }
    
    func deletePet(at offsets: IndexSet) {
        offsets.map { pets[$0] }.forEach { pet in
            context.delete(pet)
        }
        do {
            try context.save()
            fetchPets()
        } catch {
            print("Error deleting pet: \(error)")
        }
    }
    
    func updatePet(_ pet: Pet,
                   name: String,
                   type: String,
                   details: String,
                   photoData: Data?) {
        pet.petName = name
        pet.petType = type
        pet.petDetails = details
        pet.petPhotoData = photoData
        do {
            try context.save()
            fetchPets()
        } catch {
            print("Error updating pet: \(error)")
        }
    }
}
