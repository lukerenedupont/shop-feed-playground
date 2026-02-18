//
//  BottomNavBar.swift
//  Shop feed playground
//

import SwiftUI

struct BottomNavBar: View {
    @Binding var selectedTab: Int
    @Namespace private var tabAnimation

    private let tabs = ["HomeIcon", "SearchIcon", "OrdersIcon"]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Image(tabs[index])
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(selectedTab == index ? Tokens.textPrimary : Tokens.textPlaceholder)
                        .frame(width: 50, height: 44)
                        .background(
                            Group {
                                if selectedTab == index {
                                    Capsule()
                                        .fill(Tokens.ShopClient.bgFill)
                                        .shadow(
                                            color: Tokens.ShopClient.shadowSColor,
                                            radius: Tokens.ShopClient.shadowSRadius,
                                            x: 0,
                                            y: Tokens.ShopClient.shadowSY
                                        )
                                        .matchedGeometryEffect(id: "activeTab", in: tabAnimation)
                                }
                            }
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                selectedTab = index
                            }
                        }
                }
            }
            .padding(Tokens.space6)
            .glassEffect(.regular, in: .capsule)
        }
        .padding(.horizontal, Tokens.space20)
        .padding(.top, Tokens.space16)
        .padding(.bottom, Tokens.space24)
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black.opacity(0.5), location: 0.35),
                            .init(color: .black, location: 0.6),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .ignoresSafeArea(edges: .bottom)
        )
    }
}
