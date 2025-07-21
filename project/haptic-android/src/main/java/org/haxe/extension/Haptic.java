package org.haxe.extension;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.CombinedVibration;
import android.os.VibrationEffect;
import android.os.VibratorManager;
import android.os.Vibrator;
import android.Manifest;
import org.haxe.extension.Extension;
import java.util.ArrayList;

public class Haptic
{
	private static VibratorManager vibratorManager;
	private static Vibrator vibrator;

	@SuppressWarnings("deprecation")
	public static void initialize()
	{
		if (Extension.mainActivity.checkSelfPermission(Manifest.permission.VIBRATE) != PackageManager.PERMISSION_GRANTED)
			return;

		if (Build.VERSION.SDK_INT >= 31)
			vibratorManager = (VibratorManager) Extension.mainContext.getSystemService(Context.VIBRATOR_MANAGER_SERVICE);
		else
			vibrator = (Vibrator) Extension.mainContext.getSystemService(Context.VIBRATOR_SERVICE);
	}

	public static void dispose()
	{
		if (Build.VERSION.SDK_INT >= 31)
		{
			if (vibratorManager != null)
			{
				vibratorManager.cancel();
				vibratorManager = null;
			}
		}
		else
		{
			if (vibrator != null)
			{
				vibrator.cancel();
				vibrator = null;
			}
		}
	}

	public static void vibrateOneShot(final int duration, final int amplitude)
	{
		if (Build.VERSION.SDK_INT >= 31)
		{
			if (vibratorManager != null)
				vibratorManager.vibrate(CombinedVibration.createParallel(VibrationEffect.createOneShot(duration, amplitude)));
		}
		else
		{
			if (vibrator != null && vibrator.hasVibrator())
				vibrator.vibrate(VibrationEffect.createOneShot(duration, amplitude));
		}
	}

	public static void vibratePattern(final int[] timings, final int[] amplitudes)
	{
		if (Build.VERSION.SDK_INT >= 31)
		{
			if (vibratorManager == null)
				return;

			long[] longTimings = new long[timings.length];

			for (int i = 0; i < timings.length; i++)
				longTimings[i] = (long) timings[i];

			vibratorManager.vibrate(CombinedVibration.createParallel(VibrationEffect.createWaveform(longTimings, amplitudes, -1)));
		}
		else
		{
			if (vibrator == null || !vibrator.hasVibrator())
				return;

			long[] longTimings = new long[timings.length];

			for (int i = 0; i < timings.length; i++)
				longTimings[i] = (long) timings[i];

			vibrator.vibrate(VibrationEffect.createWaveform(longTimings, amplitudes, -1));
		}
	}

	public static boolean isPrimitiveSupported(int primitiveId)
	{
		if (Build.VERSION.SDK_INT >= 31)
		{
			if (vibratorManager != null)
			{
				Vibrator vibrator = vibratorManager.getDefaultVibrator();

				if (vibrator != null)
					return vibrator.areAllPrimitivesSupported(primitiveId);
			}
		}

		return false;
	}

	public static void vibratePredefined(int[] primitiveIds, double[] scales, int[] delays)
	{
		if (Build.VERSION.SDK_INT >= 31)
		{
			if (vibratorManager != null)
			{
				Vibrator vibrator = vibratorManager.getDefaultVibrator();

				if (vibrator != null && vibrator.areAllPrimitivesSupported(primitiveIds))
				{
					VibrationEffect.Composition effect = VibrationEffect.startComposition();

					for (int i = 0; i < primitiveIds.length; i++)
						effect.addPrimitive(primitiveIds[i], (float) scales[i], delays[i]);

					vibratorManager.vibrate(CombinedVibration.createParallel(effect.compose()));
				}
			}
		}
	}
}
