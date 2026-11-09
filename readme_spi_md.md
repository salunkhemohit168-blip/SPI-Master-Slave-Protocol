# I2C Master Protocol Controller (Verilog)

Verilog HDL implementation of an I2C master controller with FSM-based control, 7-bit slave
addressing, serial data transmission, and ACK/NACK handling, verified with a simulation testbench.

---

## 📌 Overview

I2C (Inter-Integrated Circuit) is a two-wire, synchronous serial protocol (SDA for data, SCL for
clock) that lets a master talk to multiple slave devices on a shared bus. This controller converts
parallel data into formatted I2C serial transactions and handles the protocol sequencing for write
and read operations.

## ✨ Key Features

- **13-state FSM** controlling START, slave address, R/W bit, ACK polling, data transfer and STOP.
- **Bi-directional SDA** driven with open-drain logic (`1'bz`) so master and slave can share the
  line without contention.
- **SCL generation** through a dedicated clock divider that scales the system clock down to an
  I2C-friendly rate and produces the `i2c_tick` used by the FSM.
- **Error handling** with an `ack_err` flag that signals a NACK from the slave during the address
  or data phase.
- **7-bit slave addressing.**

## 🗂️ File Structure

| File | Description |
|------|-------------|
| `top_i2c.v` | Top-level module; instantiates the FSM and clock divider and connects their signals |
| `i2c_fsm.v` | Core control logic: 13-state FSM, bit counter, shift registers |
| `i2c_clk_divider.v` | Generates the divided clock / `i2c_tick` that paces FSM transitions |
| `tb_i2c.v` | Testbench; models the bus with `pullup()` primitives and runs a full write transaction |
| `simulation_i2c.png` | Waveform screenshot from the behavioral simulation |

## ⚙️ How It Works

A typical write transaction proceeds through these phases:

1. **IDLE:** SDA and SCL are released (high via pull-ups).
2. **START:** the master pulls SDA low while SCL is high.
3. **ADDRESS:** the 7-bit slave address is shifted out MSB first, followed by the R/W bit.
4. **ADDRESS ACK:** the master releases SDA and samples the slave's ACK (low) or NACK (high).
5. **DATA:** the data byte is shifted out, followed by another ACK check.
6. **STOP:** the master drives SDA high while SCL is high, ending the transfer.

If the slave does not pull SDA low during an ACK slot, the controller raises `ack_err`.

## 🧪 Simulation

The testbench drives the master through a complete write transaction and checks the generation of
START/STOP conditions, address and data shifting, and completion flags. Pull-up primitives model the
physical open-drain bus.

**Run in Xilinx Vivado**

1. Create a new RTL project and add `top_i2c.v`, `i2c_fsm.v` and `i2c_clk_divider.v` as design
   sources.
2. Add `tb_i2c.v` as a simulation source and set it as the simulation top.
3. Click **Run Simulation → Run Behavioral Simulation**.
4. Inspect `sda`, `scl`, the FSM state and `ack_err` in the waveform window.

**Run with Icarus Verilog + GTKWave (optional)**

```bash
iverilog -o i2c_sim top_i2c.v i2c_fsm.v i2c_clk_divider.v tb_i2c.v
vvp i2c_sim
gtkwave dump.vcd   # if the testbench dumps a VCD file
```

## 🛠️ Tools

- Verilog HDL
- Xilinx Vivado (behavioral simulation)

## 🔧 My Contributions

_Fill in only what you have actually built and tested yourself, for example:_

- [ ] Added read-transaction support
- [ ] Added repeated START
- [ ] Added clock stretching
- [ ] Added a slave model and self-checking testbench with pass/fail output
- [ ] Added extra test cases (NACK on address, NACK on data, back-to-back transfers)

## 🚧 Possible Future Work

- 10-bit addressing
- Multi-byte burst transfers
- Multi-master arbitration
- Parameterized clock divider for different SCL frequencies