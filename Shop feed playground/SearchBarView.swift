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
                            .font(.system(size: Tokens.bodySize, weight: .regular))
                            .tracking(Tokens.bodyTracking)
                            .foregroundColor(Tokens.textPlaceholder)
                            .padding(.leading, isSearchFocused ? Tokens.space16 : 0)
                    }

                    TextField("", text: $searchText)
                        .font(.system(size: Tokens.bodySize, weight: .regular))
                        .tracking(Tokens.bodyTracking)
                        .foregroundColor(Tokens.textPrimary)
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
                                .stroke(Color.black.opacity(0.12), lineWidth: 1)
                        )
                        .matchedGeometryEffect(id: "plusIcon", in: searchAnimation)
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: Tokens.chipSize, height: Tokens.chipSize)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.2))
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
            RoundedRectangle(cornerRadius: Tokens.radius28, style: .continuous)
                .fill(isSearchFocused ? .white : Tokens.overlayLight75)
                .shadow(
                    color: Tokens.shadowColor,
                    radius: Tokens.shadowRadius,
                    x: 0,
                    y: Tokens.shadowY
                )
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
