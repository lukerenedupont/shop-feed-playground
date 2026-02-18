//
//  SearchBarView.swift
//  Shop feed playground
//

import SwiftUI

struct SearchBarView: View {
    @Binding var isSearchFocused: Bool
    @FocusState private var textFieldFocused: Bool
    @State private var searchText: String = ""

    @Namespace private var searchAnimation
    private let spring = Animation.spring(response: 0.25, dampingFraction: 0.75)

    var body: some View {
        VStack(spacing: 0) {
            // Main input row
            HStack(spacing: 0) {
                // Plus icon in top row (only when collapsed)
                if !isSearchFocused {
                    Image("PlusIcon")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Tokens.textPrimary)
                        .frame(width: Tokens.chipSize, height: Tokens.chipSize)
                        .matchedGeometryEffect(id: "plusIcon", in: searchAnimation)
                }

                // Text field
                ZStack(alignment: .leading) {
                    if searchText.isEmpty {
                        Text("Ask anything")
                            .shopTextStyle(.bodyLarge)
                            .foregroundColor(Tokens.ShopClient.textPlaceholder)
                            .padding(.leading, isSearchFocused ? Tokens.space16 : 0)
                    }

                    TextField("", text: $searchText)
                        .shopTextStyle(.bodyLarge)
                        .foregroundColor(Tokens.ShopClient.text)
                        .padding(.leading, isSearchFocused ? Tokens.space16 : 0)
                        .focused($textFieldFocused)
                        .allowsHitTesting(isSearchFocused)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Voice icon
                Image("VoiceIcon")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(Tokens.textPrimary)
                    .frame(width: Tokens.chipSize, height: Tokens.chipSize)
            }
            .padding(Tokens.space4)

            // Action row — grows in height when focused
            HStack {
                if isSearchFocused {
                    Image("PlusIcon")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Tokens.textPrimary)
                        .frame(width: Tokens.chipSize, height: Tokens.chipSize)
                        .background(
                            Circle()
                                .stroke(Tokens.ShopClient.border, lineWidth: 1)
                        )
                        .matchedGeometryEffect(id: "plusIcon", in: searchAnimation)
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: Tokens.ShopClient.textSpec(.buttonMedium).fontSize, weight: .semibold))
                    .foregroundColor(Tokens.ShopClient.textInverse)
                    .frame(width: Tokens.chipSize, height: Tokens.chipSize)
                    .background(
                        Circle()
                            .fill(Tokens.ShopClient.bgFillBrand)
                    )
            }
            .padding(.horizontal, Tokens.space8)
            .padding(.bottom, Tokens.space8)
            .frame(maxHeight: isSearchFocused ? nil : 0)
            .clipped()
            .opacity(isSearchFocused ? 1 : 0)
        }
        .opacity(isSearchFocused ? 1.0 : 0.75)
        .background(
            Group {
                if isSearchFocused {
                    RoundedRectangle(cornerRadius: Tokens.radius28, style: .continuous)
                        .fill(Tokens.ShopClient.bgFill)
                        .overlay(
                            RoundedRectangle(cornerRadius: Tokens.radius28, style: .continuous)
                                .stroke(Tokens.ShopClient.borderSecondary, lineWidth: 0.5)
                        )
                        .shadow(
                            color: Tokens.ShopClient.shadowSColor,
                            radius: Tokens.ShopClient.shadowSRadius,
                            x: 0,
                            y: Tokens.ShopClient.shadowSY
                        )
                } else {
                    RoundedRectangle(cornerRadius: Tokens.radius28, style: .continuous)
                        .fill(.clear)
                        .glassEffect(.regular, in: .capsule)
                }
            }
        )
        .contentShape(RoundedRectangle(cornerRadius: Tokens.radius28, style: .continuous))
        .onTapGesture {
            if !isSearchFocused {
                withAnimation(spring) {
                    isSearchFocused = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    textFieldFocused = true
                }
            }
        }
        .padding(.horizontal, Tokens.space16)
        .animation(spring, value: isSearchFocused)
        .onChange(of: isSearchFocused) { _, newValue in
            if !newValue {
                textFieldFocused = false
                searchText = ""
            }
        }
    }
}
