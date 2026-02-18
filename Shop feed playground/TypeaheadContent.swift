//
//  TypeaheadContent.swift
//  Shop feed playground
//

import SwiftUI

// MARK: - Typeahead Content

struct TypeaheadContent: View {
    private let suggestions = [
        ("Outfit to pair with the Linen Camp Shirt", "👕"),
        ("Compare running shoes under $150", "👟"),
        ("Gift ideas for dad", "🎁"),
    ]

    private let recents: [(String, String, Color)] = [
        ("running shoes", "Just now", Color(hex: 0xC4C0B6)),
        ("Summer trip", "1 hour ago", Color(hex: 0x5588CC)),
        ("Back to school shopping", "June 4", Color(hex: 0xA0A0A0)),
        ("ANAGRAM teddy fur vest", "June 3", Color(hex: 0x8B6040)),
        ("Espresso setup under $3k", "June 3", Color(hex: 0x4A4A4A)),
        ("Annie boots by Tecovas", "June 2", Color(hex: 0x8B7355)),
        ("Gift ideas for mom", "June 1", Color(hex: 0xD48B5A)),
        ("Skincare routine suggestions", "May 31", Color(hex: 0xC4956A)),
        ("Trendy lighting inspiration", "May 30", Color(hex: 0xD4714A)),
        ("New coffees to explore", "May 30", Color(hex: 0xA67B5C)),
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                // Suggestion pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Tokens.space8) {
                        ForEach(0..<suggestions.count, id: \.self) { i in
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.up.left")
                                    .font(.system(size: Tokens.captionSize, weight: .medium))
                                    .foregroundColor(Tokens.textPlaceholder)

                                Text(suggestions[i].0)
                                    .shopTextStyle(.bodySmall)
                                    .foregroundColor(Tokens.textPrimary)
                                    .lineLimit(1)

                                Text(suggestions[i].1)
                                    .shopTextStyle(.bodySmall)
                            }
                            .padding(.horizontal, Tokens.space12)
                            .frame(height: 36)
                            .background(
                                Capsule().fill(Tokens.overlayDark04)
                            )
                        }
                    }
                    .padding(.horizontal, Tokens.space16)
                }
                .padding(.top, Tokens.space16)

                // Recents header
                Text("Recents")
                    .shopTextStyle(.subtitle)
                    .foregroundColor(Tokens.textPrimary)
                    .padding(.horizontal, Tokens.space16)
                    .padding(.top, Tokens.space24)
                    .padding(.bottom, Tokens.space8)

                // Recent search items
                VStack(spacing: 0) {
                    ForEach(0..<recents.count, id: \.self) { i in
                        RecentSearchRow(
                            title: recents[i].0,
                            time: recents[i].1,
                            color: recents[i].2
                        )
                    }
                }
            }
            .padding(.bottom, Tokens.space16)
        }
    }
}

// MARK: - Recent Search Row

private struct RecentSearchRow: View {
    let title: String
    let time: String
    let color: Color

    var body: some View {
        HStack(spacing: Tokens.space12) {
            ZStack {
                RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(4))

                RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                    .fill(color)
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(-3))
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .shopTextStyle(.bodySmall)
                    .foregroundColor(Tokens.textPrimary)
                    .lineLimit(1)

                Text(time)
                    .shopTextStyle(.caption)
                    .foregroundColor(Tokens.textPlaceholder)
            }

            Spacer()
        }
        .padding(.horizontal, Tokens.space16)
        .padding(.vertical, Tokens.space8)
    }
}
