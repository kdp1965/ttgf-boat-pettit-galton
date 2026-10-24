# Verilator gate-level simulation for tt_um_pettit_galton.
#
# Usage:
#   make           # build the simulator
#   make run       # build and capture frame.ppm
#   make clean
#
# The GF180 netlist and cell models are not checked in.  Harden the design
# first (or download the GDS action artifact) and point NETLIST at the
# unpowered netlist, e.g. runs/wokwi/final/nl/tt_um_pettit_galton.nl.v.
# The cell models come from the gf180mcuD PDK under $(PDK_ROOT).

TEST_DIR    := $(abspath $(CURDIR))
PDK_ROOT    ?= $(HOME)/.ciel
PDK         ?= gf180mcuD
SCL_DIR     := $(PDK_ROOT)/$(PDK)/libs.ref/gf180mcu_fd_sc_mcu7t5v0/verilog

NETLIST     ?= $(TEST_DIR)/tt_um_pettit_galton.nl.v
CELL_LIB    ?= $(SCL_DIR)/gf180mcu_fd_sc_mcu7t5v0.v
PRIMITIVES  ?= $(SCL_DIR)/primitives.v

TOP         := tt_um_pettit_galton
OBJ_DIR     := obj_dir
BIN         := $(OBJ_DIR)/V$(TOP)

WARMUP      ?= 1

# FUNCTIONAL    -> use the behavioural cell models (no SDF timing).
# UNIT_DELAY=   -> drop the unit-delay annotations (Verilator ignores delays).
DEFINES := \
    +define+FUNCTIONAL \
    +define+UNIT_DELAY=

# Suppress noisy warnings that come from the auto-generated PDK Verilog.
WARN_FLAGS := \
    -Wno-fatal \
    -Wno-MULTITOP \
    -Wno-UNOPTFLAT \
    -Wno-WIDTH \
    -Wno-CASEINCOMPLETE \
    -Wno-UNUSED \
    -Wno-UNDRIVEN \
    -Wno-PINMISSING \
    -Wno-IMPLICIT \
    -Wno-SELRANGE \
    -Wno-TIMESCALEMOD \
    -Wno-STMTDLY \
    -Wno-INITIALDLY \
    -Wno-MULTIDRIVEN \
    -Wno-LATCH \
    -Wno-COMBDLY \
    -Wno-DECLFILENAME \
    -Wno-EOFNEWLINE

VERILATOR_FLAGS := \
    --cc --exe --build -j 0 \
    --top-module $(TOP) \
    --no-timing \
    -O2 -CFLAGS "-O2 -std=c++17" \
    $(WARN_FLAGS) $(DEFINES)

SOURCES := $(PRIMITIVES) $(CELL_LIB) $(NETLIST) sim_main.cpp

all: $(BIN)

$(BIN): sim_main.cpp $(NETLIST) $(CELL_LIB) $(PRIMITIVES)
	verilator $(VERILATOR_FLAGS) $(SOURCES)

run: $(BIN)
	$(BIN) -o frame.ppm --warmup $(WARMUP)

clean:
	rm -rf $(OBJ_DIR) frame.ppm

.PHONY: all run clean
