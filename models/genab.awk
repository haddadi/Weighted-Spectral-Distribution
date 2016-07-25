BEGIN{

p=ARGV[1];
q=ARGV[2];
N=ARGV[3];

       print "BriteConfig " > "out_.conf"
       print "BeginModel" > "out_.conf"
       print "Name =  10" > "out_.conf"
       print "N = ", N > "out_.conf"
       print "HS = 1000" > "out_.conf"
       print "LS = 100" > "out_.conf"
       print "NodePlacement = 1" > "out_.conf"
       print "m = 2" > "out_.conf"
       print "BWDist = 1" > "out_.conf"
       print "BWMin = 10.0" > "out_.conf"
       print "BWMax = 1024.0" > "out_.conf"
       print "p = ", p > "out_.conf"
       print "q = ", q > "out_.conf"
       print "EndModel" > "out_.conf"
       print "BeginOutput" > "out_.conf"
       print "BRITE = 1 " > "out_.conf"
       print "OTTER = 0" > "out_.conf"
       print "DML = 0 " > "out_.conf"
       print "NS = 0" > "out_.conf"
       print "Javasim = 0" > "out_.conf"
       print "EndOutput" > "out_.conf"

system("unset LD_LIBRARY_PATH; ./cppgen out_.conf ab2_out ab_good_seed")
system("awk 'NR > "N+6"{print $2, $3}' ab2_out.brite > edges.txt")
system("cp edges.txt ab_edges.txt")
system("cp edges.txt ab_finished.txt")

}


