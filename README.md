# Synchronous FIFO (32 × 8)

A simple synchronous First-In-First-Out (FIFO) buffer written in Verilog, plus an interactive browser-based simulator to visualize how it behaves cycle by cycle.

**🔴 Live simulator:** https://iamparv7043.github.io/Syncronous-FIFO/

## Overview

This is a 32-deep, 8-bit-wide FIFO with a single clock domain (read and write share the same clock). It supports:

- Write-only, read-only, and simultaneous read+write in the same cycle
- Full/empty detection using an extra pointer bit (no wasted memory slot needed)
- Synchronous reset

## Design details

- `wrptr` / `rdptr` are 6-bit registers addressing a 32-word memory (`mem[4:0]`)
- The extra bit (`[5]`) acts as a "lap" indicator, so the same 5-bit address can mean either **empty** or **full** depending on whether the write pointer has lapped the read pointer:
  - `empty` → `rdptr == wrptr` (same lap, same address)
  - `full` → `rdptr == {~wrptr[5], wrptr[4:0]}` (write pointer is exactly one lap ahead)
- On simultaneous read+write, both pointers advance together so occupancy never changes — this is why it's safe to allow read+write even while full.

## Files

| File | Description |
|---|---|
| `fifo.v` | The Verilog FIFO module |
| `index.html` | Interactive simulator (memory array, pointers, flags, waveform log) |

## Using the simulator

Open `index.html` (or the live link above) in any browser:

1. Enter a hex byte in the `din` field
2. Click **write**, **read**, or **write + read** to step one clock edge at a time
3. Watch the memory array update — WR/RD badges show pointer positions, and the waveform log shows exactly what each edge did
4. **rst** clears all pointers and memory

## Module ports

```verilog
module fifo(
    input clk, rst, rd, wr,
    input [7:0] din,
    output reg [7:0] dout,
    output full, empty
);
```

## License

MIT
