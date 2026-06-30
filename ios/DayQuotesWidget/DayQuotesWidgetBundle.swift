//
//  DayQuotesWidgetBundle.swift
//  DayQuotesWidget
//
//  Created by Ari Khalid on 30.05.26.
//

import WidgetKit
import SwiftUI

@main
struct DayQuotesWidgetBundle: WidgetBundle {
    var body: some Widget {
        DayQuotesWidget()
        DayQuotesWidgetControl()
        DayQuotesWidgetLiveActivity()
    }
}
