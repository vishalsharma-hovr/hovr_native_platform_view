/// Method channel names and method identifiers for phone entry PlatformView.
abstract final class ChannelNames {
  static const phoneEntryBase = 'hovr_native_platform_view/phone_entry';

  static String phoneEntry(int viewId) => '${phoneEntryBase}_$viewId';
}

abstract final class ChannelMethods {
  static const onPhoneSubmitted = 'onPhoneSubmitted';
  static const updateSubmissionStatus = 'updateSubmissionStatus';
}
