import WidgetKit
import SwiftUI

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quoteText: String
    let quoteAuthor: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(date: Date(), quoteText: "Reach for the skies, so if you fall you land on a cloud", quoteAuthor: "Unknown")
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        completion(entry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        let nextUpdate = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        completion(Timeline(entries: [entry()], policy: .after(nextUpdate)))
    }

    private func entry() -> QuoteEntry {
        let userDefaults = UserDefaults(suiteName: "group.com.arikhalid.quoteriseapp")
        let text = userDefaults?.string(forKey: "quote_text") ?? "Reach for the skies, so if you fall you land on a cloud"
        let author = userDefaults?.string(forKey: "quote_author") ?? "Unknown"
        return QuoteEntry(date: Date(), quoteText: text, quoteAuthor: author)
    }
}

struct DayQuotesWidgetEntryView: View {
    var entry: QuoteEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                Text(entry.quoteText)
                    .font(.system(size: family == .systemSmall ? 12 : 14, weight: .medium))
                    .foregroundColor(Color(white: 0.88))
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .lineLimit(family == .systemSmall ? 6 : 4)
                Spacer()
                HStack {
                    Spacer()
                    Text("— \(entry.quoteAuthor)")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(Color(white: 0.55))
                        .italic()
                }
            }
            .padding(14)

        }
    }
}

struct DayQuotesWidget: Widget {
    let kind: String = "DayQuotesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DayQuotesWidgetEntryView(entry: entry)
                .containerBackground(Color(red: 27/255, green: 77/255, blue: 62/255), for: .widget)
        }
        .configurationDisplayName("DayQuotes")
        .description("Your daily motivational quote.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
