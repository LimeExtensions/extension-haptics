package extension.haptics;

#if android
import extension.haptics.android.HapticAndroid;
#elseif ios
import extension.haptics.ios.HapticIOS;
#end

/**
 * This class provides a cross-platform interface for haptic feedback functionality.
 */
class Haptic
{
	/**
	 * Initializes the haptic system for the current platform.
	 * 
	 * This method delegates to the platform-specific implementation:
	 * - Android: Calls `HapticAndroid.initialize()`.
	 * - iOS: Calls `HapticIOS.initialize()`.
	 */
	public static function initialize():Void
	{
		#if android
		HapticAndroid.initialize();
		#elseif ios
		HapticIOS.initialize();
		#end
	}

	/**
	 * Disposes of the haptic system for the current platform.
	 * 
	 * This method delegates to the platform-specific implementation:
	 * - Android: Calls `HapticAndroid.dispose()`.
	 * - iOS: Calls `HapticIOS.dispose()`.
	 */
	public static function dispose():Void
	{
		#if android
		HapticAndroid.dispose();
		#elseif ios
		HapticIOS.dispose();
		#end
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
		#if android
		HapticAndroid.vibrateOneShot(Math.floor(duration * 1000), Math.floor(Math.max(1, Math.min(255, amplitude * 255))));
		#elseif ios
		HapticIOS.vibrateOneShot(duration, Math.max(0, Math.min(1, amplitude)), Math.max(0, Math.min(1, sharpness)));
		#end
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
		#if android
		final intTimings:Array<Int> = [0]; // The first element is the delay.

		for (i in 0...durations.length)
			intTimings.push(Math.floor(durations[i] * 1000));

		final intAmplitudes:Array<Int> = [0]; // Since the first element is the delay, it won't have an amplitude.

		for (i in 0...amplitudes.length)
			intAmplitudes.push(Math.floor(Math.max(1, Math.min(255, amplitudes[i] * 255))));

		HapticAndroid.vibratePattern(intTimings, intAmplitudes);
		#elseif ios
		final singleAmplitudes:Array<Single> = [];

		for (i in 0...amplitudes.length)
			singleAmplitudes[i] = (amplitudes[i] : Single);

		final singleSharpnesses:Array<Single> = [];

		for (i in 0...sharpnesses.length)
			singleSharpnesses[i] = (sharpnesses[i] : Single);

		HapticIOS.vibratePattern(durations, singleAmplitudes, singleSharpnesses);
		#end
	}
}
