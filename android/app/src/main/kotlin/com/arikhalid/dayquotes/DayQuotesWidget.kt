package com.arikhalid.quoteriseapp

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class DayQuotesWidgetSquare : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (id in appWidgetIds) {
            updateWidget(context, appWidgetManager, id, R.layout.dayquotes_widget_square)
        }
    }
}

class DayQuotesWidgetRect : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (id in appWidgetIds) {
            updateWidget(context, appWidgetManager, id, R.layout.dayquotes_widget_rect)
        }
    }
}

private fun updateWidget(context: Context, manager: AppWidgetManager, id: Int, layout: Int) {
    val data = HomeWidgetPlugin.getData(context)
    val quote = data.getString("quote_text", "Reach for the skies, so if you fall you land on a cloud") ?: ""
    val author = data.getString("quote_author", "Unknown") ?: ""

    val views = RemoteViews(context.packageName, layout)
    views.setTextViewText(R.id.widget_quote, quote)
    views.setTextViewText(R.id.widget_author, "— $author")
    manager.updateAppWidget(id, views)
}
