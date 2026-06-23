package com.ridehovr.hovr_native_platform_view

import android.content.Context
import android.content.ContextWrapper
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.setViewTreeLifecycleOwner
import androidx.savedstate.SavedStateRegistryOwner
import androidx.savedstate.setViewTreeSavedStateRegistryOwner

internal object ComposePlatformViewHelper {
    fun configure(composeView: ComposeView, context: Context) {
        val lifecycleOwner = context.findLifecycleOwner()
        if (lifecycleOwner != null) {
            composeView.setViewTreeLifecycleOwner(lifecycleOwner)
        }
        val savedStateOwner = context.findSavedStateRegistryOwner()
        if (savedStateOwner != null) {
            composeView.setViewTreeSavedStateRegistryOwner(savedStateOwner)
        }
        composeView.setViewCompositionStrategy(
            ViewCompositionStrategy.DisposeOnDetachedFromWindow,
        )
    }

    private fun Context.findLifecycleOwner(): LifecycleOwner? {
        var current: Context = this
        while (current is ContextWrapper) {
            if (current is LifecycleOwner) {
                return current
            }
            current = current.baseContext
        }
        return null
    }

    private fun Context.findSavedStateRegistryOwner(): SavedStateRegistryOwner? {
        var current: Context = this
        while (current is ContextWrapper) {
            if (current is SavedStateRegistryOwner) {
                return current
            }
            current = current.baseContext
        }
        return null
    }
}
