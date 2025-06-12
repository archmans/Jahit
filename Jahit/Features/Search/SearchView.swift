//
//  SearchView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 21/05/25.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchTitle: String
    @StateObject private var filterViewModel = FilterViewModel()
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            ZStack (alignment: .top) {
                HeaderBackground()
                HStack {
                    Button(action: {}) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                    Text(searchTitle)
                        .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 70)
            
            // filter button
            HStack {
                Button(action: {
                    filterViewModel.isShowingFilter.toggle()
                }) {
                    Image("filter")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                    
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(red: 0.82, green: 0.89, blue: 1.0))
                .cornerRadius(15)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // list of tailors
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0..<8) { _ in
                        Button(action: {}) {
                            HStack(alignment: .top, spacing: 8) {
                                Image("penjahit")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .cornerRadius(8)
                                    .frame(width: 99, height: 99)
                                    .padding(.leading, 4)
                                VStack (spacing: 4) {
                                    Text("Alfa Tailor")
                                        .font(Font.custom("Plus Jakarta Sans", size: 12).weight(.semibold))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("$$$$$")
                                        .font(Font.custom("PlusJakartaSans-Regular", size: 10).weight(.light))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Atasan, Bawahan")
                                        .font(Font.custom("PlusJakartaSans-Regular", size: 10).weight(.light))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("0.5 km")
                                        .font(Font.custom("PlusJakartaSans-Regular", size: 10).weight(.light))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 4)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(.black.opacity(0.2), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .padding(.top, 8)
        }
        .sheet(isPresented: $filterViewModel.isShowingFilter) {
            FilterModalView(viewModel: filterViewModel)
        }
    }
}

#Preview {
    SearchView(searchTitle: .constant("Terekomendasi"))
}
