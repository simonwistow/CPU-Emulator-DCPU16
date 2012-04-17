package CPU::Emulator::DCPU16::Disassembler;

=head1 NAME

CPU::Emulator::DCPU16::Disassembler -  a disassembler for DCPU-16 bytecode

=cut

our @OPCODES   = qw(NOOP SET ADD SUB MUL DIV MOD SHL SHR AND BOR XOR IFE IFN IFG IFB);
our @REGISTERS = qw(A B C X Y Z I J);


sub _get_operand {
    my $n    = shift;
    my $pc   = shift;
    my @mem  = @_;
    if ($n < 0x08) {
        sprintf("%s", $REGISTERS[$n & 7]);
    } elsif ($n < 0x10) {
        sprintf("[%s]", $REGISTERS[$n & 7]);
    } elsif ($n < 0x18) {
        sprintf("[0x%04x+%s]", $mem[$$pc++], $REGISTERS[$n & 7]);
    } elsif ($n  == 0x18) {
        "POP"
    } elsif ($n  == 0x19) {
        "PEEK"
    } elsif ($n  == 0x1A) {
        "PUSH"
    } elsif ($n  == 0x1B) {
        "SP"
    } elsif ($n  == 0x1C) {
        "PC"
    } elsif ($n  == 0x1D) {
        "O"
    } elsif ($n  == 0x1E) {
        sprintf("[0x%04x]", $mem[$$pc++]);
    } elsif ($n  == 0x1F) {
        sprintf("0x%04x", $mem[$$pc++]);
    } else {
        ($n - 0x20);
    } 
}

sub disassemble {
    my $class = shift;
    my $pc    = shift;
    my @mem   = @_;
    my $word  = $mem[$pc++];
    my $op    = $word & 0xF;
    my $a     = ($word >> 4) & 0x3F;
    my $b     = ($word >> 10);
    
    my $ret   = "";
    if ($op > 0) {
        $ret .= $OPCODES[$op]." ";
        $ret .= _get_operand($a, \$pc, @mem);
        $ret .= ", ";
        $ret .= _get_operand($b, \$pc, @mem);
    } elsif ($a == 0x01) {
        $ret .= "JSR "._get_operand($b, \$pc, @mem);
    } else {
        $ret .= sprintf("UNK[%02x] ", $a)._get_operand($b, \$pc, @mem);
    }
}
1;