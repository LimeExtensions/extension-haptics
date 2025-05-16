package extension.haptics.ios;

#if ios
import haxe.io.Bytes;

/**
 * This class provides haptic feedback functionality for `iOS` devices using the `CoreHaptics` framework.
 * 
 * @see https://developer.apple.com/documentation/corehaptics
 */
@:buildXml('<include name="${haxelib:extension-haptics}/project/haptic-ios/Build.xml" />')
@:headerInclude('haptic.hpp')
class HapticIOS
{
	/**
	 * Initializes the haptic engine.
	 * 
	 * Must be called before using any haptic feedback functions.
	 */
	public static function initialize():Void
	{
		hapticInitialize();
	}

	/**
	 * Disposes of the haptic engine.
	 * 
	 * Should be called to release resources when haptic feedback is no longer needed.
	 */
	public static function dispose():Void
	{
		hapticDispose();
	}

	/**
	 * Triggers a one-shot vibration with the specified duration, intensity, and sharpness.
	 * 
	 * @param duration The vibration duration in seconds.
	 * @param amplitude The intensity of the vibration (range: 0.0 to 1.0).
	 * @param sharpness The sharpness of the vibration (range: 0.0 to 1.0, where 0.0 is smooth and 1.0 is sharp).
	 */
	public static function vibrateOneShot(duration:Float, amplitude:Single, sharpness:Single):Void
	{
		hapticVibrateOneShot(duration, amplitude, sharpness);
	}

	/**
	 * Triggers a pattern vibration defined by arrays of durations, intensities, and sharpness values.
	 * 
	 * @param timings An array of vibration durations in seconds.
	 * @param amplitudes An array of vibration intensities (range: 0.0 to 1.0).
	 * @param sharpnesses An array of vibration sharpness values (range: 0.0 to 1.0, where 0.0 is smooth and 1.0 is sharp).
	 * 
	 * All arrays must have the same length.
	 */
	public static function vibratePattern(timings:Array<Float>, amplitudes:Array<Single>, sharpnesses:Array<Single>):Void
	{
		hapticVibratePattern(cpp.Pointer.ofArray(timings).constRaw, cpp.Pointer.ofArray(amplitudes).constRaw, cpp.Pointer.ofArray(sharpnesses).constRaw,
			timings.length);
	}

	/**
	 * Triggers a haptic vibration pattern using the provided pattern data.
	 * 
	 * @param data The AHAP pattern data as a `Bytes` object.
	 */
	public static function vibratePatternFromData(data:Bytes):Void
	{
		if (data != null && (data.b != null && data.b.length > 0))
			hapticVibratePatternFromData(cast cpp.Pointer.ofArray(data.b).constRaw, data.b.length);
	}

	/**
	 * Native function to initialize the haptic engine.
	 */
	@:native('hapticInitialize')
	extern public static function hapticInitialize():Void;

	/**
	 * Native function to dispose of the haptic engine.
	 */
	@:native('hapticDispose')
	extern public static function hapticDispose():Void;

	/**
	 * Native function to trigger a one-shot vibration.
	 * 
	 * @param duration The vibration duration in seconds.
	 * @param intensity The intensity of the vibration (range: 0.0 to 1.0).
	 * @param sharpness The sharpness of the vibration (range: 0.0 to 1.0, where 0.0 is smooth and 1.0 is sharp).
	 */
	@:native('hapticVibrateOneShot')
	extern public static function hapticVibrateOneShot(duration:Float, intensity:Single, sharpness:Single):Void;

	/**
	 * Native function to trigger a pattern vibration.
	 * 
	 * @param durations Pointer to an array of vibration durations in seconds.
	 * @param intensities Pointer to an array of vibration intensities (range: 0.0 to 1.0).
	 * @param sharpnesses Pointer to an array of vibration sharpness values (range: 0.0 to 1.0, where 0.0 is smooth and 1.0 is sharp).
	 * @param count The number of elements in the `durations`, `intensities`, and `sharpnesses` arrays.
	 */
	@:native('hapticVibratePattern')
	extern public static function hapticVibratePattern(durations:cpp.RawConstPointer<Float>, intensities:cpp.RawConstPointer<Single>,
		sharpnesses:cpp.RawConstPointer<Single>, count:Int):Void;

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
