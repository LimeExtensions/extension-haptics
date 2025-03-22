#pragma once

void hapticInitialize(void);
void hapticDispose(void);
void hapticVibrateOneShot(double duration, float intensity, float sharpness);
void hapticVibratePattern(const double *durations, const float *intensities, const float *sharpnesses, int count);
