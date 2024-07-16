//
//  SampleEntries.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 02.07.2024.
//

import Foundation

extension JournalEntry {
    static let sampleEntries = [
        JournalEntry(
            summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id.",
            date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
            emotion: emotions[4],
            causes: [Cause(name: "Cauza 1"), Cause(name: "Cauza 2"), Cause(name: "Cauza 3")],
            selectedTips: ["Categoria 1": Tip.sampleTips[0]]
        ),
        JournalEntry(
            summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id.",
            date: .now,
            emotion: emotions[2],
            causes: [Cause(name: "Cauza 1"), Cause(name: "Cauza 2"), Cause(name: "Cauza 3"), Cause(name: "Cauza 4")],
            selectedTips: [:]
        ),
        JournalEntry(
            summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id.",
            date: Date().addingTimeInterval(86400 * 3),
            emotion: emotions[0],
            causes: [Cause(name: "Cauza 1"), Cause(name: "Cauza 2"), Cause(name: "Cauza 3")],
            selectedTips: ["Categoria 1": Tip.sampleTips[1]]
        ),
        JournalEntry(
            summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id.",
            date: Date().addingTimeInterval(86400 * 5),
            emotion: emotions[4],
            causes: [Cause(name: "Cauza 1"), Cause(name: "Cauza 2"), Cause(name: "Cauza 3")],
            selectedTips: ["Categoria 1": Tip.sampleTips[1]]
        ),
        JournalEntry(
            summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id.",
            date: Date().addingTimeInterval(86400 * 6),
            emotion: emotions[4],
            causes: [Cause(name: "Cauza 1"), Cause(name: "Cauza 2"), Cause(name: "Cauza 3")],
            selectedTips: ["Categoria 1": Tip.sampleTips[1]]
        ),
        JournalEntry(
            summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id.",
            date: Date().addingTimeInterval(86400 * 9),
            emotion: emotions[3],
            causes: [Cause(name: "Cauza 1"), Cause(name: "Cauza 2")],
            selectedTips: ["Categoria 1": Tip.sampleTips[0], "Categoria 2": Tip.sampleTips[1]]
        ),
        JournalEntry(
            summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id.",
            date: Date().addingTimeInterval(86400 * 13),
            emotion: emotions[2],
            causes: [Cause(name: "Cauza 1"), Cause(name: "Cauza 2")],
            selectedTips: ["Categoria 1 Categoria 1 Categoria 1 Categoria 1 Categoria 1": Tip.sampleTips[0], "Categoria 2": Tip.sampleTips[1], "Categoria 3": Tip.sampleTips[0]]
        ),
        JournalEntry(
            summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id.",
            date: Date().addingTimeInterval(86400 * 14),
            emotion: emotions[1],
            causes: [Cause(name: "Cauza 1"), Cause(name: "Cauza 2")],
            selectedTips: ["Categoria 1": Tip.sampleTips[2], "Categoria 2": Tip.sampleTips[3]]
        ),
        JournalEntry(
            summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id.",
            date: Calendar.current.date(byAdding: .month, value: 2, to: Date())!,
            emotion: emotions[1],
            causes: [Cause(name: "Cauza 1"), Cause(name: "Cauza 2"), Cause(name: "Cauza 3")],
            selectedTips: ["Categoria 1": Tip.sampleTips[1]]
        ),
        JournalEntry(
            summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id.",
            date: Calendar.current.date(byAdding: .month, value: 4, to: Date())!,
            emotion: emotions[2],
            causes: [Cause(name: "Cauza 1")],
            selectedTips: ["Categoria 1": Tip.sampleTips[0]]
        )
    ]
}
