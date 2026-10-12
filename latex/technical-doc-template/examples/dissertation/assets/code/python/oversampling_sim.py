"""Oversampling and averaging with an ideal N-bit ADC.

Produces the two result files used in the dissertation example:
  enob_vs_osr.csv   sine-wave test, effective bits against OSR
  dc_error.csv      static-input test, error at several noise levels

Standard library only. Run it with:  python oversampling_sim.py
"""
import csv
import math
import random
from pathlib import Path

N_BITS = 12
FULL_SCALE = 2 ** N_BITS - 1          # highest output code
OSR_VALUES = [1, 4, 16, 64, 256]
NOISE_LEVELS = [0.0, 0.25, 0.5, 1.0]  # input-referred noise, LSB rms
SINE_NOISE = 0.5                      # noise used for the sine-wave test
OUTPUT_SAMPLES = 4096                 # output samples per sine-wave run
DC_TRIALS = 2000                      # static levels tried per run
DATA_DIR = Path(__file__).resolve().parents[2] / "data"

rng = random.Random(20260614)         # fixed seed, so the results repeat


def adc(voltage_lsb, noise_rms):
    """Ideal quantiser: add noise, round to the nearest code, clip."""
    if noise_rms:
        voltage_lsb += rng.gauss(0.0, noise_rms)
    return min(max(math.floor(voltage_lsb + 0.5), 0), FULL_SCALE)


def enob(error_rms_lsb):
    """Effective bits, from the rms error against an ideal ADC's."""
    return N_BITS - math.log2(error_rms_lsb * math.sqrt(12.0))


def sine_test(osr, noise_rms):
    """Rms error of the averaged output for a sine wave input, in LSB."""
    amplitude, offset = 2000.0, FULL_SCALE / 2.0
    # The input frequency is 3.71 % of the output sample rate.
    step = 2.0 * math.pi * 0.0371 / osr
    total = 0.0
    for k in range(OUTPUT_SAMPLES):
        ideal = measured = 0.0
        for i in range(osr):
            v = offset + amplitude * math.sin(step * (k * osr + i))
            ideal += v
            measured += adc(v, noise_rms)
        total += ((measured - ideal) / osr) ** 2
    return math.sqrt(total / OUTPUT_SAMPLES)


def dc_test(osr, noise_rms):
    """Rms error of the averaged output for static inputs, in LSB."""
    total = 0.0
    for _ in range(DC_TRIALS):
        v = 1000.0 + rng.random()         # anywhere between two codes
        measured = sum(adc(v, noise_rms) for _ in range(osr)) / osr
        total += (measured - v) ** 2
    return math.sqrt(total / DC_TRIALS)


def write_csv(name, header, rows):
    """Write one result file, with Unix line endings."""
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    with open(DATA_DIR / name, "w", newline="") as f:
        out = csv.writer(f, lineterminator="\n")
        out.writerow(header)
        out.writerows(rows)


def main():
    rows = []
    for osr in OSR_VALUES:
        theory = enob(math.sqrt((1 / 12 + SINE_NOISE ** 2) / osr))
        err = sine_test(osr, SINE_NOISE)
        bits = [f"{theory:.3f}", f"{enob(err):.3f}"]
        rows.append([osr] + bits + [f"{err:.4f}"])
    write_csv("enob_vs_osr.csv", ["osr", "theory", "sim", "error"], rows)

    rows = []
    for osr in OSR_VALUES:
        errors = [dc_test(osr, n) for n in NOISE_LEVELS]
        rows.append([osr] + [f"{e:.4f}" for e in errors])
    header = ["osr"] + [f"n{int(n * 100):03d}" for n in NOISE_LEVELS]
    write_csv("dc_error.csv", header, rows)


if __name__ == "__main__":
    main()
