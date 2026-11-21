# Memory UVM Verification Environment

A complete UVM (Universal Verification Methodology) testbench for verifying a synchronous
single-port memory (RAM) model written in SystemVerilog. The environment performs an
exhaustive write-then-read sweep across the entire memory depth and self-checks the results
using a reference model in the scoreboard.

## Design Under Test (DUT)

`memory.sv` is a parameterized synchronous memory:

| Parameter    | Default | Description                     |
|--------------|---------|---------------------------------|
| `DATA_WIDTH` | 32      | Width of each memory word       |
| `MEM_DEPTH`  | 64      | Number of memory locations      |
| `ADDR_WIDTH` | `$clog2(MEM_DEPTH)` | Address bus width |

Ports: `clk`, `rst_n`, `write_en`, `read_en`, `address`, `data_in`, `data_out`, `valid_out`.

Behavior:
- On a write (`write_en`), `data_in` is stored at `address`.
- On a read (`read_en`), `data_out` is updated from memory and `valid_out` is asserted.
- Reads are registered (data appears one cycle after the read command).

## Testbench Architecture

```
mem_top
 └── mem_env
      ├── mem_agent
      │    ├── mem_sequencer
      │    ├── mem_driver   ── drives signals via mem_if.drv_cb
      │    └── mem_monitor  ── samples signals via mem_if.mon_cb
      └── mem_scoreboard    ── reference model + pass/fail checks
```

| File | Description |
|------|-------------|
| `memory.sv` | DUT: synchronous single-port memory |
| `mem_if.sv` | Interface with driver/monitor clocking blocks and modports |
| `mem_pkg.sv` | Package that imports UVM and includes all components |
| `mem_seq_item.svh` | Sequence item (transaction) with randomization constraints |
| `mem_sequence.svh` | Sequence: writes all addresses, then reads/verifies all addresses |
| `mem_sequencer.svh` | Sequencer for `mem_seq_item` |
| `mem_driver.svh` | Drives transactions onto the interface |
| `mem_monitor.svh` | Observes bus activity and publishes items via analysis port |
| `mem_agent.svh` | Bundles driver, monitor, and sequencer |
| `mem_scoreboard.svh` | Reference memory model and read-data checker |
| `mem_env.svh` | Environment that instantiates agent and scoreboard |
| `mem_test.svh` | UVM test that creates the environment and starts the sequence |
| `mem_top.sv` | Top module: clock/reset generation, DUT + interface, `run_test()` |
| `run.do` | QuestaSim script to compile and run the simulation |
| `wave.do` | QuestaSim waveform setup |

## Transaction / Constraints

`mem_seq_item` randomizes:
- `op` — `MEM_WRITE` (40%), `MEM_READ` (40%), `MEM_IDLE` (20%)
- `address` — constrained within `[0, MEM_DEPTH)`
- `data_in` — random data

The sequence overrides these constraints inline to sweep every address for the write pass
and again for the read pass.

## Checking

The scoreboard maintains a reference array `ref_mem`. Every monitored write updates the
reference model; every monitored read with `valid_out` high is compared against it:

- Match → `PASS` message
- Mismatch → `uvm_error("FAIL: ...")`

## Running the Simulation (QuestaSim / ModelSim)

From the project root:

```tcl
vsim -c -do run.do
```

or interactively open QuestaSim and run:

```tcl
do run.do
```

`run.do` performs:

1. Recreate the `work` library.
2. Compile `memory.sv`, `mem_if.sv`, `mem_pkg.sv`, `mem_top.sv`.
3. Elaborate and simulate `mem_top` with `+UVM_TESTNAME=mem_test`.
4. Load `wave.do` and run to completion.

## Expected Output

```
UVM_INFO ... [mem_sequence] Starting Memory Fill: Writing to all addresses...
UVM_INFO ... [mem_scoreboard] SCOREBOARD WRITE: Addr = 0x..., Data = 0x...
UVM_INFO ... [mem_sequence] Starting Memory Verification: Reading all addresses...
UVM_INFO ... [mem_scoreboard] PASS: Read Addr = 0x... | Expected = 0x... | Actual = 0x...
...
UVM_INFO ... : REPORT SUMMARY
```

A successful run reports zero errors and `UVM_FATAL : 0`.

## Requirements

- A SystemVerilog simulator with UVM support (QuestaSim, ModelSim, or equivalent).
- UVM library available in the simulator installation.

## Repository Notes

The `.gitignore` excludes simulator-generated artifacts (`work/`, `*.wlf`, `*.mpf`, `*.qdb`,
archives, etc.). Only source files, scripts, and documentation are tracked.
