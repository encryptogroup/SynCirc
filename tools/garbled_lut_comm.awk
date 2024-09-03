#!/usr/bin/env -S awk -f

# [[CITE]]
# David Heath; Vladimir Kolesnikov; Lucien K. L. Ng,
# "Garbled Circuit Lookup Tables with Logarithmic Number of Ciphertexts"
# EUROCRYPT 2024
#
# This script calculates the communication amount of a LUT circuit
# when garbled using the novel logrow approach by Heath et al. The
# input format is a custom Bristol-derived multi-output LUT format.

BEGIN {
    kappa = 128;
    bits = 0;
}

/^LUT/ {
    inputs = $2;
    outputs = $3;

    bits += (2 ^ inputs) * outputs + (inputs - 1) * kappa + inputs * outputs * kappa;
}

END {
    print bits " b"
    print (bits / 8) " B"
    print ((bits / 8) / 1024) " KB"
}
