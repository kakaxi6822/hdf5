#!/bin/bash

#SBATCH -C haswell
#SBATCH --nodes=1
#SBATCH -t 00:30:00
#SBATCH --mail-type=BEGIN,END,FAIL
##SBATCH --mail-user=<username>@sandia.gov
#SBATCH --export=ALL
#SBATCH --job-name=h5_ctestS

cd @HDF5_BINARY_DIR@
CMD="ctest . -E TEST_PAR|H5DIFF|PERFORM|ph5example -C Release -j 32 -T test"

echo "Run $CMD. Test output will be in build/ctestS.out"
$CMD  >& ctestS.out
echo "Done running $CMD"