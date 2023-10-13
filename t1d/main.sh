#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 6
#SBATCH --mem 128g

sbatch scripts/script_qc_base.sh
sbatch scripts/script_tagging.sh
sbatch scripts/script_sumhers.sh
sbatch scripts/script_cors.sh
sbatch scripts/script_megaprs.sh