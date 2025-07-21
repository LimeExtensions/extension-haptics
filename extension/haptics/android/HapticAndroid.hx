package extension.haptics.android;

#if android
import lime.system.JNI;

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
	 * Cache for storing created static JNI method references.
	 */
	@:noCompletion
	private static var staticMethodsCache:Map<String, Dynamic> = [];

	/**
	 * Initializes the haptic system by calling the corresponding Java method.
	 */
	public static function initialize():Void
	{
		final initializeJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/Haptic', 'initialize', '()V');

		if (initializeJNI != null)
			initializeJNI();
	}

	/**
	 * Disposes of the haptic system by calling the corresponding Java method.
	 */
	public static function dispose():Void
	{
		final disposeJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/Haptic', 'dispose', '()V');

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
		final vibrateJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/Haptic', 'vibrateOneShot', '(II)V');

		if (vibrateJNI != null)
			vibrateJNI(duration, amplitude);
	}

	/**
	 * Triggers a pattern vibration defined by arrays of timings and amplitudes.
	 * 
	 * @param timings An array of vibration durations in milliseconds.
	 * @param amplitudes An array of vibration intensities (0-255).
	 */
	public static function vibratePattern(timings:Array<Int>, amplitudes:Array<Int>):Void
	{
		final vibratePatternJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/Haptic', 'vibratePattern', '([I[I)V');

		if (vibratePatternJNI != null)
			vibratePatternJNI(timings, amplitudes);
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
		final isPrimitiveSupportedJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/Haptic', 'isPrimitiveSupported', '(I)Z');

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
		final vibratePredefinedJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/Haptic', 'vibratePredefined', '([I[D[I)V');

		if (vibratePredefinedJNI != null)
			vibratePredefinedJNI(primitiveIds, scales, delays);
	}

	/**
	 * Retrieves or creates a cached static method reference.
	 * @param className The name of the Java class containing the method.
	 * @param methodName The name of the method to call.
	 * @param signature The JNI method signature string (e.g., "()V", "(Ljava/lang/String;)V").
	 * @param cache Whether to cache the result (default true).
	 * @return A dynamic reference to the static method, or null if it couldn't be created.
	 */
	@:noCompletion
	private static function createJNIStaticMethod(className:String, methodName:String, signature:String, cache:Bool = true):Null<Dynamic>
	{
		@:privateAccess
		className = JNI.transformClassName(className);

		final key:String = '$className::$methodName::$signature';

		if (cache && !staticMethodsCache.exists(key))
			staticMethodsCache.set(key, JNI.createStaticMethod(className, methodName, signature));
		else if (!cache)
			return JNI.createStaticMethod(className, methodName, signature);

		return staticMethodsCache.get(key);
	}
}
#end
