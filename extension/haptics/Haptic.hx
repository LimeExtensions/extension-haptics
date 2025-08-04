package extension.haptics;

import extension.haptics.backends.IHapticBackend;
#if android
import extension.haptics.backends.AndroidHapticBackend;
#elseif ios
import extension.haptics.backends.IOSHapticBackend;
#end

/**
 * This class provides a cross-platform interface for haptic feedback functionality.
 * Can be safely accessed cross platform, as any unsupported platforms (desktop/html5) simply just call empty backend functions
 * So usage is generally
 * Haptic.initialize(); 
 * Haptic.vibrateOneShot(0.5, 0.2, 0.8); // Calls a one-shot vibration that lasts 0.5 seconds, at 0.2 intensity, and at 0.8 sharpness
 * 
 * #if ios
 * // iOS specific functions are in HapticIOS.hx 
 * HapticIOS.vibratePatternFromData(Assets.getBytes("data/heartbeats.ahap")); 
 * #end
 * 
 * #if android
 * // Android specific functions are in HapticAndroid.hx
 * if(HapticAndroid.isPrimitiveSupported(HapticAndroid.PRIMITIVE_CLICK))
 * 		trace("Has Android Click Primitive!");
 * #end
 */
class Haptic
{

	private static var _backend:Null<IHapticBackend>;
	public static var backend(get, never):IHapticBackend;

	static function get_backend():IHapticBackend
	{
		if (_backend == null) _backend = createBackend();
		return _backend;
	}

	static function createBackend():IHapticBackend
	{
		#if android
        return new AndroidHapticBackend();
        #elseif ios
        return new IOSHapticBackend();
        #else
        return new EmptyHapticBackend();
        #end
	}

	/**
	 * Initializes the haptic system for the current platform.
	 */
	public static function initialize():Void
	{
		backend.initialize();
	}

	/**
	 * Disposes of the haptic system for the current platform.
	 */
	public static function dispose():Void
	{
		backend.dispose();
	}

	/**
	 * Triggers a one-shot vibration with the specified duration, amplitude, and sharpness.
	 * 
	 * This method converts the platform-agnostic inputs into platform-specific formats:
	 * - Android: Converts duration to milliseconds and amplitude to a scale of 1-255.
	 * - iOS: Uses duration in seconds, amplitude and sharpness as floats between 0 and 1.
	 * 
	 * @param duration The duration of the vibration in seconds (platform-agnostic).
	 * @param amplitude The intensity of the vibration (0.0 to 1.0).
	 * @param sharpness The sharpness of the vibration (0.0 to 1.0, iOS only).
	 */
	public static function vibrateOneShot(duration:Float, amplitude:Float, sharpness:Float):Void
	{
		backend.vibrateOneShot(duration, amplitude, sharpness);
	}

	/**
	 * Triggers a pattern vibration defined by arrays of durations, amplitudes, and sharpness values.
	 * 
	 * This method converts the platform-agnostic inputs into platform-specific formats:
	 * - Android: Converts durations to milliseconds and amplitudes to a scale of 1-255.
	 * - iOS: Uses durations in seconds and amplitudes and sharpness values as floats between 0 and 1.
	 * 
	 * @param durations An array of vibration durations in seconds (platform-agnostic).
	 * @param amplitudes An array of vibration intensities (0.0 to 1.0).
	 * @param sharpnesses An array of vibration sharpness values (0.0 to 1.0, iOS only).
	 */
	public static function vibratePattern(durations:Array<Float>, amplitudes:Array<Float>, sharpnesses:Array<Float>):Void
	{
		backend.vibratePattern(durations, amplitudes, sharpnesses);
	}
}
