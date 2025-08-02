package extension.haptics;

import extension.haptics.backends.IOSHapticBackend;
#if ios
/**
 * IOS specific haptics functions and features
 * Note: Make sure `Haptic.initialize()` gets called before you attempt using these!
 */
@:buildXml('<include name="${haxelib:extension-haptics}/project/haptic-ios/Build.xml" />')
@:headerInclude('haptic.hpp')
class HapticIOS
{
    /**
	 * Triggers a haptic vibration pattern using the provided pattern data.
	 * 
	 * @param data The AHAP pattern data as a `Bytes` object.
	 */
	public static function vibratePatternFromData(data:Bytes):Void
	{
		if (data != null)
			hapticVibratePatternFromData(cast cpp.Pointer.arrayElem(data.getData(), 0).constRaw, data.length);
	}

    /**
	 * Native function to triggers a pattern vibration using a pattern file (.ahap).
	 *
	 * @param bytes The buffer containing data for the new object.
	 * @param length The number of bytes to copy from bytes.
	 */
	@:native('hapticVibratePatternFromData')
	extern public static function hapticVibratePatternFromData(bytes:cpp.RawConstPointer<cpp.Void>, len:cpp.SizeT):Void;
}
#end
