package extension.haptics.backend;

#if android
import lime.system.JNI;
using Lambda;

/**
 * This class provides haptic feedback functionality for `Android` devices using native `Java` methods.
 * 
 * @see https://developer.android.com/reference/android/os/VibratorManager
 * @see https://developer.android.com/reference/android/os/Vibrator
 */
class AndroidHapticBackend implements IHapticBackend
{
	
	/**
	 * Cache for storing created static JNI method references.
	 */
	@:noCompletion
	private static var staticMethodsCache:Map<String, Dynamic> = [];

	public function new():Void {}
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
	 * @param sharpness The sharpness of the vibration (0.0 to 1.0, iOS only).
	 */
	public static function vibrateOneShot(duration:Float, amplitude:Float, sharpness:Float):Void
	{
		final vibrateJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/Haptic', 'vibrateOneShot', '(II)V');

		if (vibrateJNI != null)
			vibrateJNI(Math.floor(duration * 1000), Math.floor(Math.max(1, Math.min(255, amplitude * 255))));
	}

	/**
	 * Triggers a pattern vibration defined by arrays of timings and amplitudes.
	 * 
	 * @param durations An array of vibration durations in milliseconds.
	 * @param amplitudes An array of vibration intensities (0-255).
	 * @param sharpnesses unused on Android
	 */
	public static function vibratePattern(durations:Array<Float>, amplitudes:Array<Float>, sharpnesses:Array<Float>):Void
	{
		function durationToMilliseconds(duration:Float):Int return Std.int(Math.floor(duration * 1000));
		// scales amplitude between 0 and 255 for android amplitude input
		function rescaleAmplitudes(amplitude:Float):Int return Std.int(Math.floor(Math.max(1, Math.min(255, amplitude * 255))));

		// on Android, the first element is the delay. We want to start immediately, so 0
		durations.unshift(0);
		amplitudes.unshift(0);

		durations = durations.map(durationToMilliseconds);
		amplitudes = amplitudes.map(rescaleAmplitudes);

		final vibratePatternJNI:Null<Dynamic> = createJNIStaticMethod('org/haxe/extension/Haptic', 'vibratePattern', '([I[I)V');

		if (vibratePatternJNI != null)
			vibratePatternJNI(durations, amplitudes);
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
