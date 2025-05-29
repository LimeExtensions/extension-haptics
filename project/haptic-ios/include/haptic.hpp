#pragma once

#include <cstddef>

void hapticInitialize(void);
void hapticDispose(void);
void hapticVibrateOneShot(double duration, float intensity, float sharpness);
void hapticVibratePattern(const double *durations, const float *intensities, const float *sharpnesses, int count);
void hapticVibratePatternFromData(const void *bytes, size_t len);
