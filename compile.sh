set -e 

z80asm src/prometheus.asm --includepath src -o out/prometheus.bin
xxd out/prometheus.bin out/prometheus.bin.hex

diff out/prometheus.bin original/prometheus.bin


python3 skoolkit/bin2tap.py -o 24000 out/prometheus.bin out/prometheus.tap