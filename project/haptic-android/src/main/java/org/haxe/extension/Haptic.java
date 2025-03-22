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

	public static void vibrateDirectionalOneShot(final int duration, final int amplitude, final double directionX, final double directionY)
	{
		if (Build.VERSION.SDK_INT >= 31)
		{
			if (vibratorManager == null)
				return;

			int[] vibrators = vibratorManager.getVibratorIds();

			if (vibrators.length > 1)
			{
				double totalMagnitude = Math.sqrt(directionX * directionX + directionY * directionY);
				double leftWeight = Math.max(0, -directionX) / totalMagnitude;
				double rightWeight = Math.max(0, directionX) / totalMagnitude;
				double topWeight = Math.max(0, directionY) / totalMagnitude;
				double bottomWeight = Math.max(0, -directionY) / totalMagnitude;

				CombinedVibration.ParallelCombination composition = CombinedVibration.startParallel();

				int midpoint = vibrators.length / 2;

				for (int i = 0; i < vibrators.length; i++)
				{
					double weight = (i < midpoint) ? leftWeight / midpoint + topWeight / (vibrators.length / 2) : rightWeight / (vibrators.length - midpoint) + bottomWeight / (vibrators.length / 2);

					if (weight > 0)
						composition.addVibrator(vibratorManager.getVibrator(i).getId(), VibrationEffect.createOneShot(duration, (int) (amplitude * weight)));
				}

				vibratorManager.vibrate(composition.combine());
			}
			else
				vibratorManager.vibrate(CombinedVibration.createParallel(VibrationEffect.createOneShot(duration, amplitude)));
		}
		else
			vibrateOneShot(duration, amplitude);
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

	public static void vibrateDirectionalPattern(final int[] timings, final int[] amplitudes, final double directionX, final double directionY)
	{
		if (Build.VERSION.SDK_INT >= 31)
		{
			if (vibratorManager == null)
				return;

			long[] longTimings = new long[timings.length];

			for (int i = 0; i < timings.length; i++)
				longTimings[i] = (long) timings[i];

			int[] vibrators = vibratorManager.getVibratorIds();

			if (vibrators.length > 1)
			{
				double totalMagnitude = Math.sqrt(directionX * directionX + directionY * directionY);
				double leftWeight = Math.max(0, -directionX) / totalMagnitude;
				double rightWeight = Math.max(0, directionX) / totalMagnitude;
				double topWeight = Math.max(0, directionY) / totalMagnitude;
				double bottomWeight = Math.max(0, -directionY) / totalMagnitude;

				CombinedVibration.ParallelCombination composition = CombinedVibration.startParallel();

				int midpoint = vibrators.length / 2;

				for (int i = 0; i < vibrators.length; i++)
				{
					double weight = (i < midpoint) ? leftWeight / midpoint + topWeight / (vibrators.length / 2) : rightWeight / (vibrators.length - midpoint) + bottomWeight / (vibrators.length / 2);

					if (weight > 0)
					{
						int[] scaledAmplitudes = new int[amplitudes.length];

						for (int j = 0; j < amplitudes.length; j++)
							scaledAmplitudes[j] = (int) (amplitudes[j] * weight);

						composition.addVibrator(vibratorManager.getVibrator(i).getId(), VibrationEffect.createWaveform(longTimings, scaledAmplitudes, -1));
					}
				}

				vibratorManager.vibrate(composition.combine());
			}
			else
				vibratorManager.vibrate(CombinedVibration.createParallel(VibrationEffect.createWaveform(longTimings, amplitudes, -1)));
		}
		else
			vibratePattern(timings, amplitudes);
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
