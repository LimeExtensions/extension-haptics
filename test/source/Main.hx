package;

class Main extends lime.app.Application
{
	public function new():Void
	{
		super();

		extension.haptics.Haptic.initialize();
	}

	public override function onWindowCreate():Void
	{
		extension.haptics.Haptic.vibratePattern([0.5, 0.1, 0.8, 0.2, 1.0], [1.0, 0.5, 1.0, 0.3, 0.8], [0.5, 0.5, 1.0, 0.3, 0.8]);
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
