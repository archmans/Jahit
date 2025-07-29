import SwiftUI

struct ItemPickerView: View {
    @ObservedObject var viewModel: CustomizationViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                if viewModel.availableItems.isEmpty {
                    emptyStateView
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.availableItems) { item in
                            ItemCard(
                                item: item,
                                isSelected: viewModel.customizationOrder.selectedItem?.id == item.id,
                                onTap: {
                                    viewModel.selectItem(item)
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                    impactFeedback.impactOccurred()
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .padding(.top, 20)
        }
        .background(Color.white)
        .colorScheme(.light)
        .navigationBarHidden(true)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Color.white)
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            HStack {
                Text("Pilih Item")
                    .font(.custom("PlusJakartaSans-Regular", size: 20).weight(.bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("Tutup") {
                    dismiss()
                }
                .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.medium))
                .foregroundColor(.blue)
            }
            
            Text("\(viewModel.availableItems.count) item tersedia")
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .background(Color.white)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "tshirt")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("Tidak ada item tersedia")
                    .font(.custom("PlusJakartaSans-Regular", size: 18).weight(.semibold))
                    .foregroundColor(.black)
                
                Text("Belum ada item untuk kategori ini")
                    .font(.custom("PlusJakartaSans-Regular", size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
}

struct ItemCard: View {
    let item: TailorServiceItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    Image(item.image)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(height: 140)
                        .clipped()
                        .cornerRadius(12)
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                            .background(Color.white)
                            .clipShape(Circle())
                            .font(.system(size: 24))
                            .padding(8)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.name)
                        .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(NumberFormatter.currencyFormatter.string(from: NSNumber(value: item.price)) ?? "Rp0")
                        .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color(red: 0, green: 0.37, blue: 0.92) : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
        .shadow(
            color: Color.black.opacity(isSelected ? 0.15 : 0.08),
            radius: isSelected ? 6 : 4,
            x: 0,
            y: isSelected ? 3 : 2
        )
        .scaleEffect(isSelected ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
