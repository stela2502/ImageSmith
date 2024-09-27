#!/bin/bash
#SBATCH --ntasks-per-node 1
#SBATCH -N 1
#SBATCH -t 08:00:00
#SBATCH -A lu2024-7-5
#SBATCH -J start_Si
#SBATCH -o start_Si.%j.out
#SBATCH -e start_Si.%j.err

#apptainer run -B /local,/projects --cleanenv /sw/pkg/ImageSmith/1.0/ImageSmith_v1.0.sif

./run.sh

exit 0
