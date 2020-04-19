use v6;

class Lifegame {
    has Int $.height is required;
    has Int $.width  is required;
    has Array @.field = [ [ (0,1).pick for 0 ..^ $!width ] for 0 ..^ $!height ];

    method forever() {
        while True {
            self.clear_screen();
            self.dump_field();
            sleep(0.1);
            @!field = self.evolve();
        }
    }

    method evolve() {
        my Array @new_field;
        for 0 ..^ $!height -> $y {
            for 0 ..^ $!width -> $x {
                my $alive_neighbours = self!count_alive_neighbours($y, $x);
                given $alive_neighbours {
                    when 2  { @new_field[$y; $x] = @!field[$y; $x]; }
                    when 3  { @new_field[$y; $x] = 1; }
                    default { @new_field[$y; $x] = 0; }
                }
            }
        }
        @new_field;
    }

    method !count_alive_neighbours(Int $y, Int $x) {
        my Int $count = 0;
        for -1..1 -> $yi {
            for -1..1 -> $xi {
                if $yi == 0 and $xi == 0 { next }
                if @!field[($y + $yi) % $!height; ($x + $xi) % $!width] == 1 {
                    $count++;
                }
            }
        }
        $count;
    }

    method dump_field() {
        say @!field.map({ .map({ $_ == 0 ?? ' ' !! 'o' }).join() }).join("\n");
    }

    method clear_screen() {
        print state $ = qx[clear]
    }
}

multi MAIN() {
    my $lifegame = Lifegame.new(height => 20, width => 40);
    $lifegame.forever();
}
