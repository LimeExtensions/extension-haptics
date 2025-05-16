package;

import lime.utils.Assets;

class Main extends lime.app.Application
{
	public function new():Void
	{
		super();

		extension.haptics.Haptic.initialize();
	}

	public override function onWindowCreate():Void
	{
		#if android
		extension.haptics.Haptic.vibratePattern([0.5, 0.1, 0.8, 0.2, 1.0], [1.0, 0.5, 1.0, 0.3, 0.8], [0.5, 0.5, 1.0, 0.3, 0.8]);
		#else
		extension.haptics.ios.HapticIOS.vibratePatternFromFile(Assets.getPath('assets/Heartbeats.ahap'));
		#end
	}

	public override function render(context:lime.graphics.RenderContext):Void
	{
		switch (context.type)
		{
			case OPENGL, OPENGLES, WEBGL:
				context.webgl.clearColor(0.75, 1, 0, 1);
				context.webgl.clear(context.webgl.COLOR_BUFFER_BIT);
			default:
		}
	}
}
