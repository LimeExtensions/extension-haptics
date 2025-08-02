package extension.haptics;

#if android
import extension.haptics.backends.AndroidHapticBackend;

/**
 * Android specific haptics functions
 * Note: Make sure `Haptic.initialize()` gets called before you attempt using these!
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
	 * Checks if a specific vibration primitive is supported.
	 * 
	 * @param primitiveId The ID of the vibration primitive.
	 * 
	 * @return `true` if the primitive is supported, false otherwise.
	 */
	public static function isPrimitiveSupported(primitiveId:Int):Bool
	{
        @:privateAccess
		final isPrimitiveSupportedJNI:Null<Dynamic> = AndroidHapticBackend.createJNIStaticMethod('org/haxe/extension/Haptic', 'isPrimitiveSupported', '(I)Z');

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
        @:privateAccess
		final vibratePredefinedJNI:Null<Dynamic> = AndroidHapticBackend.createJNIStaticMethod('org/haxe/extension/Haptic', 'vibratePredefined', '([I[D[I)V');

		if (vibratePredefinedJNI != null)
			vibratePredefinedJNI(primitiveIds, scales, delays);
	}
}
