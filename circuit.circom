pragma circom 2.0.0;

include "circomlib/circuits/poseidon.circom";    // For hashing
include "circomlib/circuits/comparators.circom"; // For comparisons
include "circomlib/circuits/bitify.circom";      // For Num2Bits

// Commitment component using Poseidon hash
template Commitment() {
    signal input msg;      // Message to commit (genetic marker)
    signal input blinding; // Blinding factor
    signal output com;     // Commitment output

    // Instantiate the Poseidon hash function with 2 inputs
    component hash = Poseidon(2);

    // Connect inputs
    hash.inputs[0] <== msg;
    hash.inputs[1] <== blinding;

    // Connect output
    com <== hash.out;
}

// MatchMarkers component
template MatchMarkers() {
    signal input marker_p;  // Parent's marker
    signal input marker_c;  // Child's marker
    signal output is_match; // 1 if match, 0 otherwise

    component isEqual = IsEqual();
    isEqual.in[0] <== marker_p;
    isEqual.in[1] <== marker_c;
    is_match <== isEqual.out;
}

// GreaterThanEq component with parameter `n`
template GreaterThanEq(n) {
    signal input in[2]; // in[0]: a, in[1]: b
    signal output out;  // 1 if a >= b, 0 otherwise

    component lt = LessThan(n);
    lt.in[0] <== in[0];
    lt.in[1] <== in[1];

    out <== 1 - lt.out;
}

// Main circuit with parameters N, T, and n
template PaternityTest(N, T, n) {
    // Inputs
    signal input M_p[N];    // Parent's markers (private)
    signal input M_c[N];    // Child's markers (private)
    signal input r_p[N];    // Parent's blinding factors (private)
    signal input r_c[N];    // Child's blinding factors (private)

    // Output
    signal output result;   // 1 if parenthood is likely, 0 otherwise

    // Constraints
    var total_matches = 0;

    // Declare components outside the loop
    component com_p[N];
    component com_c[N];
    component match[N];

    for (var i = 0; i < N; i++) {
        // Generate Parent's Commitment
        com_p[i] = Commitment();
        com_p[i].msg <== M_p[i];
        com_p[i].blinding <== r_p[i];

        // Generate Child's Commitment
        com_c[i] = Commitment();
        com_c[i].msg <== M_c[i];
        com_c[i].blinding <== r_c[i];

        // Check for Match
        match[i] = MatchMarkers();
        match[i].marker_p <== M_p[i];
        match[i].marker_c <== M_c[i];
        total_matches += match[i].is_match;
    }

    // Verify Threshold
    // Ensure total_matches >= T
    component gte = GreaterThanEq(n);
    gte.in[0] <== total_matches;
    gte.in[1] <== T;
    result <== gte.out;
}

// Instantiate the main component with specific N, T, and n values
component main = PaternityTest(10, 7, 4);
