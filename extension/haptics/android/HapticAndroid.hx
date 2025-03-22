package extension.haptics.android;

#if android
import extension.haptics.android.util.JNICache;

/**
 * This class provides haptic feedback functionality for `Android` devices using native `Java` methods.
 * 
 * @see https://developer.android.com/reference/android/os/VibratorManager
 * @see https://developer.android.com/reference/android/os/Vibrator
 */
class HapticAndroid
{
	/**
	 * Represents a short, sharp click vibration.
	 */
	public static final PRIMITIVE_CLICK:Int = 1;

	/**
	 * Represents a low-intensity tick vibration.
	 */
	public static final PRIMITIVE_LOW_TICK:Int = 8;

	/**
	 * Represents a quick, falling vibration pattern.
	 */
	public static final PRIMITIVE_QUICK_FALL:Int = 6;

	/**
	 * Represents a quick, rising vibration pattern.
	 */
	public static final PRIMITIVE_QUICK_RISE:Int = 4;

	/**
	 * Represents a slow, rising vibration pattern.
	 */
	public static final PRIMITIVE_SLOW_RISE:Int = 5;

	/**
	 * Represents a spinning vibration pattern.
	 */
	public static final PRIMITIVE_SPIN:Int = 3;

	/**
	 * Represents a heavy, thud-like vibration.
	 */
	public static final PRIMITIVE_THUD:Int = 2;

	/**
	 * Represents a standard tick vibration.
	 */
	public static final PRIMITIVE_TICK:Int = 7;

	/**
	 * Initializes the haptic system by calling the corresponding Java method.
	 */
	public static function initialize():Void
	{
		final initializeJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Haptic', 'initialize', '()V');

		if (initializeJNI != null)
			initializeJNI();
	}

	/**
	 * Disposes of the haptic system by calling the corresponding Java method.
	 */
	public static function dispose():Void
	{
		final disposeJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Haptic', 'dispose', '()V');

		if (disposeJNI != null)
			disposeJNI();
	}

	/**
	 * Triggers a oneshot vibration with the specified duration and intensity (amplitude).
	 * 
	 * @param duration The vibration duration in milliseconds.
	 * @param amplitude The intensity of the vibration (0-255).
	 */
	public static function vibrateOneShot(duration:Int, amplitude:Int):Void
	{
		final vibrateJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Haptic', 'vibrateOneShot', '(II)V');

		if (vibrateJNI != null)
			vibrateJNI(duration, amplitude);
	}

	/**
	 * Triggers a directional one-shot vibration with the specified duration, intensity (amplitude) and direction weights (directionX, directionY).
	 * 
	 * @param duration The vibration duration in milliseconds.
	 * @param amplitude The intensity of the vibration (0-255).
	 * @param directionX The horizontal direction weight (-1.0 to 1.0).
	 * @param directionY The vertical direction weight (-1.0 to 1.0).
	 */
	public static function vibrateDirectionalOneShot(duration:Int, amplitude:Int, directionX:Float, directionY:Float):Void
	{
		final vibrateDirectionalJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Haptic', 'vibrateDirectionalOneShot', '(IIDD)V');

		if (vibrateDirectionalJNI != null)
			vibrateDirectionalJNI(duration, amplitude, directionX, directionY);
	}

	/**
	 * Triggers a pattern vibration defined by arrays of timings and amplitudes.
	 * 
	 * @param timings An array of vibration durations in milliseconds.
	 * @param amplitudes An array of vibration intensities (0-255).
	 */
	public static function vibratePattern(timings:Array<Int>, amplitudes:Array<Int>):Void
	{
		final vibratePatternJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Haptic', 'vibratePattern', '([I[I)V');

		if (vibratePatternJNI != null)
			vibratePatternJNI(timings, amplitudes);
	}

	/**
	 * Triggers a directional vibration pattern using specified timings, amplitudes and directional weights.
	 * 
	 * @param timings An array of vibration durations in milliseconds.
	 * @param amplitudes An array of vibration intensities (0-255).
	 * @param directionX The X component of the direction.
	 * @param directionY The Y component of the direction.
	 */
	public static function vibrateDirectionalPattern(timings:Array<Int>, amplitudes:Array<Int>, directionX:Float, directionY:Float):Void
	{
		final vibrateDirectionalPatternJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Haptic', 'vibrateDirectionalPattern', '([I[IDD)V');

		if (vibrateDirectionalPatternJNI != null)
			vibrateDirectionalPatternJNI(timings, amplitudes, directionX, directionY);
	}

	/**
	 * Checks if a specific vibration primitive is supported.
	 * 
	 * @param primitiveId The ID of the vibration primitive.
	 * 
	 * @return `true` if the primitive is supported, false otherwise.
	 */
	public static function isPrimitiveSupported(primitiveId:Int):Bool
	{
		final isPrimitiveSupportedJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Haptic', 'isPrimitiveSupported', '(I)Z');

		if (isPrimitiveSupportedJNI != null)
			return isPrimitiveSupportedJNI(primitiveId);

		return false;
	}

	/**
	 * Triggers a predefined vibration pattern using primitive IDs, scales, and delays.
	 * 
	 * @param primitiveIds An array of integers representing predefined vibration primitive IDs.
	 * @param scales An array of scaling factors (0.0 to 1.0) for the intensity of each primitive.
	 * @param delays An array of delays in milliseconds before each primitive is triggered.
	 */
	public static function vibratePredefined(primitiveIds:Array<Int>, scales:Array<Float>, delays:Array<Int>):Void
	{
		final vibratePredefinedJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Haptic', 'vibratePredefined', '([I[D[I)V');

		if (vibratePredefinedJNI != null)
			vibratePredefinedJNI(primitiveIds, scales, delays);
	}
}
#end
