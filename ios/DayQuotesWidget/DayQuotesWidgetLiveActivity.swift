//
//  DayQuotesWidgetLiveActivity.swift
//  DayQuotesWidget
//
//  Created by Ari Khalid on 30.05.26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DayQuotesWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DayQuotesWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DayQuotesWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DayQuotesWidgetAttributes {
    fileprivate static var preview: DayQuotesWidgetAttributes {
        DayQuotesWidgetAttributes(name: "World")
    }
}

extension DayQuotesWidgetAttributes.ContentState {
    fileprivate static var smiley: DayQuotesWidgetAttributes.ContentState {
        DayQuotesWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DayQuotesWidgetAttributes.ContentState {
         DayQuotesWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DayQuotesWidgetAttributes.preview) {
   DayQuotesWidgetLiveActivity()
} contentStates: {
    DayQuotesWidgetAttributes.ContentState.smiley
    DayQuotesWidgetAttributes.ContentState.starEyes
}
