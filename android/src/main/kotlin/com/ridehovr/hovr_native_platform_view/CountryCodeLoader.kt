package com.ridehovr.hovr_native_platform_view

import android.content.Context
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONArray
import com.ridehovr.hovr_native_platform_view.ui.CountryItem

object CountryCodeLoader {
    private const val TAG = "CountryCodeLoader"

    @Volatile
    private var cached: List<CountryItem>? = null

    fun loadSync(context: Context): List<CountryItem> {
        cached?.let { return it }

        val loaded = loadFromAssets(context)
        cached = loaded
        return loaded
    }

    suspend fun load(context: Context): List<CountryItem> {
        cached?.let { return it }

        return withContext(Dispatchers.IO) {
            cached?.let { return@withContext it }
            val loaded = loadFromAssets(context)
            cached = loaded
            loaded
        }
    }

    private fun loadFromAssets(context: Context): List<CountryItem> {
        return try {
            val json = context.assets.open("country_code.json")
                .bufferedReader()
                .use { it.readText() }
            val array = JSONArray(json)
            buildList {
                for (index in 0 until array.length()) {
                    val item = array.getJSONObject(index)
                    add(
                        CountryItem(
                            name = item.getString("name"),
                            flag = item.getString("flag"),
                            code = item.getString("code"),
                            dialCode = item.getString("dial_code"),
                        ),
                    )
                }
            }
        } catch (error: Exception) {
            Log.e(TAG, "Failed to load country_code.json", error)
            listOf(CountryItem("Canada", "🇨🇦", "CA", "+1"))
        }
    }
}
