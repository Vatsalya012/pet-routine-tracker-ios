//
//  RoutineListViewModel.swift
//  PetRoutineTrackerApp_vdr
//
//  Created by BMIIT on 02/12/25.
//

import Foundation
import CoreData

class RoutineListViewModel: ObservableObject {
    @Published var routines: [Routine] = []
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func loadRoutines(for pet: Pet) {
        let request: NSFetchRequest<Routine> = Routine.fetchRequest()

        request.predicate = NSPredicate(format: "pet == %@", pet)

        let sortByTime = NSSortDescriptor(key: "timeOfDay", ascending: true)
        request.sortDescriptors = [sortByTime]

        do {
            routines = try context.fetch(request)
        } catch {
            print("Error fetching routines: \(error)")
        }
    }
    
    func addRoutine(for pet: Pet,
                        title: String,
                        time: Date,
                        repeatRule: String,
                        note: String) {
        let routine = Routine(context: context)

        routine.routineTitle = title
        routine.timeOfDay = time
        routine.repeatRule = repeatRule
        routine.routineNote = note
        routine.pet = pet

        do {
            try context.save()
            loadRoutines(for: pet)
        } catch {
            print("Error saving routine: \(error)")
        }
    }
    
    func deleteRoutine(at offsets: IndexSet, for pet: Pet) {
        offsets.map { routines[$0] }.forEach { routine in
            context.delete(routine)
        }

        do {
            try context.save()
            loadRoutines(for: pet)
        } catch {
            print("Error deleting routine: \(error)")
        }
    }
    
    func updateRoutine(_ routine: Routine,
                           for pet: Pet,
                           title: String,
                           time: Date,
                           repeatRule: String,
                           note: String) {
        routine.routineTitle = title
        routine.timeOfDay = time
        routine.repeatRule = repeatRule
        routine.routineNote = note

        do {
            try context.save()
            loadRoutines(for: pet)
        } catch {
            print("Error updating routine: \(error)")
        }
    }
}
