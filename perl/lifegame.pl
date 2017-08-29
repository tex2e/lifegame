
use Time::HiRes qw( usleep );

my $height = 20;
my $width = 40;
my @field = ();
my @newField = ();

sub initField {
    foreach my $y (0 .. $height - 1) {
        foreach my $x (0 .. $width - 1) {
            $field[$y][$x] = int rand(2);
        }
    }
}

sub evolve {
    foreach my $y (0 .. $height - 1) {
        foreach my $x (0 .. $width - 1) {
            my $aliveNeighbours = countAliveNeighbours($y, $x);
            if ($aliveNeighbours <= 1) { $newField[$y][$x] = 0; }
            if ($aliveNeighbours == 2) { $newField[$y][$x] = $field[$y][$x]; }
            if ($aliveNeighbours == 3) { $newField[$y][$x] = 1; }
            if ($aliveNeighbours >= 4) { $newField[$y][$x] = 0; }
        }
    }
}

sub countAliveNeighbours {
    my ($y, $x) = @_;
    my $count = 0;
    foreach my $yi (-1 .. 1) {
        foreach my $xi (-1 .. 1) {
            if ($yi == 0 && $xi == 0) { next; }
            if ($field[($y + $yi) % $height][($x + $xi) % $width] != 0) {
                $count++;
            }
        }
    }
    return $count;
}

sub prepareNext {
    @field = @newField; # In Perl it isn't a reference copy.
    @newField = ();
}

sub dumpField {
    foreach my $y (0 .. $height - 1) {
        foreach my $x (0 .. $width - 1) {
            print (($field[$y][$x] == 0) ? " " : "o");
        }
        print "\n";
    }
}

sub clearScreen {
    print "\033[;H\033[2J";
}


initField();
while (true) {
    clearScreen();
    dumpField();
    usleep(100000); # 100ms
    evolve();
    prepareNext();
}
