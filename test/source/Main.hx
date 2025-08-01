package;

import lime.utils.Assets;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.Shape;
import openfl.events.Event;

import openfl.events.TouchEvent;
import openfl.events.MouseEvent;

class Main extends Sprite
{
	var btnPattern:TextButton;
	public function new():Void
	{
		super();
		extension.haptics.Haptic.initialize();

		btnPattern = new TextButton("Test Patterned Haptics", vibratePattern);
		addChild(btnPattern);
		
		stage.addEventListener (Event.RESIZE, resizeDisplay);
	}

	function resizeDisplay(_):Void
	{
		btnPattern.x = (stage.stageWidth / 2) - (btnPattern.width / 2);
		btnPattern.y = stage.stageHeight / 2;
	}

	function vibratePattern():Void
	{
		#if android
		extension.haptics.Haptic.vibratePattern([0.5, 0.1, 0.8, 0.2, 1.0], [1.0, 0.5, 1.0, 0.3, 0.8], [0.5, 0.5, 1.0, 0.3, 0.8]);
		#elseif ios
		extension.haptics.ios.HapticIOS.vibratePatternFromData(Assets.getBytes('assets/Heartbeats.ahap'));
		#end
	}

}

class TextButton extends Sprite
{
	var format:TextFormat;
	var textField:TextField;

    public function new(text:String, clickCallback:Void->Void):Void
    {
        super();

		var testShape:Shape = new Shape();
		
		addChild(testShape);

		textField = new TextField();
        textField.text = text;
        textField.autoSize = LEFT;
        textField.selectable = false;
		
		format = new TextFormat();
		format.color = 0x00000000;
		format.size = 24;
		textField.setTextFormat(format);
		addChild(textField);

		testShape.graphics.beginFill(0xFF0000, 0.5);
		testShape.graphics.drawRect (-5, 0, textField.width + 10, textField.height * 1.5);
		testShape.graphics.endFill();

		// These should work on mobile by default as well
		addEventListener(MouseEvent.MOUSE_OVER, handleOver);
		addEventListener(MouseEvent.MOUSE_DOWN, handleDown);
		addEventListener(MouseEvent.MOUSE_UP, handleUp);
		addEventListener(MouseEvent.MOUSE_OUT, handleOut);
		addEventListener(MouseEvent.CLICK, _ -> clickCallback());
    }


	function handleOver(_):Void
	{
		format.underline = true;
		textField.setTextFormat(format);
	}

	function handleOut(_):Void
	{
		format.underline = false;
		alpha = 1;
		textField.setTextFormat(format);
	}

	function handleDown(_):Void
	{
		alpha = 0.5;
		textField.setTextFormat(format);
	}
	function handleUp(_):Void
	{
		alpha = 1;
		textField.setTextFormat(format);
	}
}
