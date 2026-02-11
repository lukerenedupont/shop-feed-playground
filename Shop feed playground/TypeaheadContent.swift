//
//  TypeaheadContent.swift
//  Shop feed playground
//
//  Created by Luke Dupont on 2/11/26.
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
                    HStack(spacing: 8) {
                        ForEach(0..<suggestions.count, id: \.self) { i in
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.up.left")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.black.opacity(0.4))

                                Text(suggestions[i].0)
                                    .font(.system(size: 14, weight: .medium))
                                    .tracking(-0.2)
                                    .foregroundColor(.black)
                                    .lineLimit(1)

                                Text(suggestions[i].1)
                                    .font(.system(size: 14))
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 36)
                            .background(
                                Capsule()
                                    .fill(Color.black.opacity(0.04))
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 16)

                // Recents header
                Text("Recents")
                    .font(.system(size: 18, weight: .semibold))
                    .tracking(-0.5)
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 8)

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
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Recent Search Row

private struct RecentSearchRow: View {
    let title: String
    let time: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(4))

                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(color)
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(-3))
            }
            .frame(width: 44, height: 44)

            // Text
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .tracking(-0.2)
                    .foregroundColor(.black)
                    .lineLimit(1)

                Text(time)
                    .font(.system(size: 12, weight: .regular))
                    .tracking(-0.2)
                    .foregroundColor(.black.opacity(0.4))
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
