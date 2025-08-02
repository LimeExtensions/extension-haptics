package extension.haptics.backends;

class EmptyHapticBackend implements IHapticBackend
{
    public function new():Void {}
    public function initialize():Void {}
    public function dispose():Void {}
    public function isSupported():Bool return false;
    public function vibrateOneShot(duration:Float,amplitude:Float, sharpness:Float):Void {}
    public function vibratePattern(durations:Array<Float>, amplitudes:Array<Float>, sharpnesses:Array<Float>):Void {}
}
