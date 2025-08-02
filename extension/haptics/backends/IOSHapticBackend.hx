package extension.haptics.backends;

#if ios
import haxe.io.Bytes;
using Lambda;

/**
 * This class provides haptic feedback functionality for `iOS` devices using the `CoreHaptics` framework.
 * 
 * @see https://developer.apple.com/documentation/corehaptics
 */
@:buildXml('<include name="${haxelib:extension-haptics}/project/haptic-ios/Build.xml" />')
@:headerInclude('haptic.hpp')
class IOSHapticBackend implements IHapticBackend
{
	public function new():Void {}
	/**
	 * Initializes the haptic engine.
	 * 
	 * Must be called before using any haptic feedback functions.
	 */
	public function initialize():Void
	{
		hapticInitialize();
	}

	/**
	 * Disposes of the haptic engine.
	 * 
	 * Should be called to release resources when haptic feedback is no longer needed.
	 */
	public function dispose():Void
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
	public function vibrateOneShot(duration:Float, amplitude:Single, sharpness:Single):Void
	{
		hapticVibrateOneShot(duration, Math.max(0, Math.min(1, amplitude)), Math.max(0, Math.min(1, sharpness)));
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
	public function vibratePattern(timings:Array<Float>, amplitudes:Array<Float>, sharpnesses:Array<Float>):Void
	{
		// casts Floats -> Singles, since iOS / obj-c expects that as their inputs :thinking:
		final singleAmplitudes:Array<Single> = amplitudes.map(a -> (a : Single));
		final singleSharpnesses:Array<Single> = sharpnesses.map(s -> (s : Single));

		hapticVibratePattern(cpp.Pointer.ofArray(timings).constRaw, cpp.Pointer.ofArray(singleAmplitudes).constRaw, cpp.Pointer.ofArray(singleSharpnesses).constRaw,
			timings.length);
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

}
#end
