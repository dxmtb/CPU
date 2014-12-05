GHDL=ghdl -a --ieee=synopsys
SRC=$(filter-out common.vhd, $(wildcard *.vhd))

all: common others elaborate

common: common.vhd
	$(GHDL) $?

others: $(SRC)
	$(GHDL) $?

elaborate: common.vhd $(SRC)
	ghdl -e --ieee=synopsys CPU

sim: all
	ghdl -r --ieee=synopsys CPU

tidy: $(SRC)
	$(foreach var,$(SRC),emacs --batch $(var) --eval="(setq-default vhdl-basic-offset 4)" --eval="(vhdl-beautify-buffer)"  -f save-buffer;)

clean:
	rm *.o *~

.PHONY: clean sim
