#!perl -w

use strict;
use Test::More tests => 20;
use CPU::Emulator::DCPU16::Assembler;

my $bytes;

ok($bytes =  CPU::Emulator::DCPU16::Assembler->assemble("SET A, 0x30"), "Assemble SET");
is(unpack("H*", $bytes), "7c010030", "Got 7c01 0030");

$bytes =  eval { CPU::Emulator::DCPU16::Assembler->assemble("SET A, 0x30, wrong") };
ok($@, "Got error assembling invalid SET");
is($bytes, undef, "Got no bytes assembling invalid SET");

ok($bytes =  CPU::Emulator::DCPU16::Assembler->assemble(":test JSR test"), "Assemble JSR");
is(unpack("H*", $bytes), "7c100000", "Got 7c10 0000");

$bytes =  eval { CPU::Emulator::DCPU16::Assembler->assemble(":test JSR test, wrong") };
ok($@, "Got error assembling invalid JSR");
is($bytes, undef, "Got no bytes assembling invalid JSR");

ok($bytes =  CPU::Emulator::DCPU16::Assembler->assemble(":test SET PC, test"), "Assemble SET PC");
is(unpack("H*", $bytes), "7dc10000", "Got 7dc1 0000");

ok($bytes =  CPU::Emulator::DCPU16::Assembler->assemble("IFN A, 0x10\nSUB A, [0x1000]"), "Assemble IFN and SUB");
is(unpack("H*", $bytes), "c00d78031000", "Got c00d 7803 1000");

ok($bytes =  CPU::Emulator::DCPU16::Assembler->assemble("SET [0x2000+I], [A]"), "Assemble SET to memory location from indirect register");
is(unpack("H*", $bytes), "21612000", "Got 2161 2000");

ok($bytes =  CPU::Emulator::DCPU16::Assembler->assemble('DAT 0x170, 0x2E1'), "Assemble short DAT line");
is(unpack("H*", $bytes), "017002e1", "Got 0170 0048 0065 006c 006c 006f 0020 02e1");

ok($bytes =  CPU::Emulator::DCPU16::Assembler->assemble(':data DAT 0x170, "Hello ", 0x2e1'), "Assemble long DAT line");
is(unpack("H*", $bytes), "017000480065006c006c006f002002e1", "Got 0170 0048 0065 006c 006c 006f 0020 02e1");

$bytes =  eval { CPU::Emulator::DCPU16::Assembler->assemble("DAT") };
ok($@, "Got error assembling invalid DAT");
is($bytes, undef, "Got no bytes assembling invalid DAT");