#!/bin/sh
vpd2vcd vcdplus.vpd > out.vcd && gzip -f out.vcd
