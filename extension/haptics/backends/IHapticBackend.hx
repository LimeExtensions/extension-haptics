package extension.haptics.backends;

interface IHapticBackend
{
    function initialize():Void;
    function dispose():Void;
    function vibrateOneShot(duration:Float, amplitude:Float, sharpness:Float):Void;
    function vibratePattern(durations:Array<Float>, amplitudes:Array<Float>, sharpnesses:Array<Float>):Void;
}
