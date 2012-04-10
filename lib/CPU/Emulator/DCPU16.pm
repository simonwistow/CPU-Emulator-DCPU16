package CPU::Emulator::DCPU16;

=head1 NAME

CPU::Emulator::DCPU16 - an emulator for Notch's DCPU-16 virtual CPU for the game 0x10c

=head1 SYNOPSIS

    # Create a new CPU and load a file
    my $cpu = CPU::Emulator::DCPU16->new();
    $cpu->load("sample.dasm");
    
    # Run it ...
    $cpu->run;
    # ... which is basically the same as
    do { $cpu->step } until $cpu->halt;

=head1 DESCRIPTION 

DCPU-16 is a spec for a virtual CPU by Notch from Mojang (of Minecraft fame).

The spec is available here

http://0x10c.com/doc/dcpu-16.txt

=cut
    
    
=head1 METHODS

=cut

=head2 new

Create a new CPU.

=cut
sub new {
    my $class = shift;
    my %opts  = @_;
    my $self  = bless \%opts, $class;
    $self->_init;
    $self;
}

sub _init {
    my $self = shift;
    $self->halt(0);
}


=head2 run [opt[s]]

Run CPU until completion.

Options available are:

=over 4

=item debug 

Whether or not we should print debug information and at what level. 

Default is 0 (no debug output).

=back

=cut
sub run {
    my $self = shift;
    my %opts = @_;
    do { $self->step(%opts) } until $self->halt;
    return !$self->halt(0);
}

=head2 halt [halt state]

Halt the CPU or check to see whether it's halted.

=cut
sub halt {
    my $self = shift;
    $self->{_halt} = shift if @_;
    $self->{_halt};
}

=head1 load <file>



=head2 step [opt[s]]

Run a single clock cycle of the CPU.

Takes the same options as C<run>.
    
=cut
sub step {
    my $self = shift;
    my %opts = @_;
}

=head1 SEE ALSO

L<CPU::Emulator::DCPU16::Assembler>

L<CPU::Emulator::DCPU16::Disassembler>

=head1 AUTHOR

Simon Wistow <simon@thegestalt.org>

=head1 COPYRIGHT

Copyright 2011 - Simon Wistow

Released under the same terms as Perl itself.

=head1 DEVELOPMENT

Latest development version available from

https://github.com/simonwistow/CPU-Emulator-DCPU16

=cut

1;