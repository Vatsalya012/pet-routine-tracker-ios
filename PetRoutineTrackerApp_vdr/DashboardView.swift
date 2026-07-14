//
//  DashboardView.swift
//  PetRoutineTrackerApp_vdr
//
//  Created by BMIIT on 05/12/25.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(white: 0.93)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("Pet Routine Tracker")
                        .font(.largeTitle.bold())
                    
                    Text("Choose what you want to do")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 16) {
                        
                        NavigationLink {
                            PetListView()
                        } label: {
                            HStack {
                                Image(systemName: "pawprint.fill")
                                    .font(.title2)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Manage My Pets")
                                        .font(.headline)
                                    Text("Add, edit routines and details")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
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
                        }
                        
                        NavigationLink {
                            PetSummaryView()
                        } label: {
                            HStack {
                                Image(systemName: "chart.bar.doc.horizontal.fill")
                                    .font(.title2)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Pet Summary")
                                        .font(.headline)
                                    Text("See total pets and quick overview")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
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
                        }
                    }
                    .padding(.top, 16)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
