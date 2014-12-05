GHDL=ghdl -a --ieee=synopsys
SRC=$(wildcard *.vhd)

all: common others

common: common.vhd
	$(GHDL) $?

others: $(SRC)
	$(GHDL) $?

tidy: $(SRC)
	$(foreach var,$(SRC),emacs --batch $(var) --eval="(setq-default vhdl-basic-offset 4)" --eval="(vhdl-beautify-buffer)"  -f save-buffer;)

clean:
	rm *.o *~

.PHONY: clean
