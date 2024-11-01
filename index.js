const snarkjs = require("snarkjs");
const fs = require("fs");

async function run() {
    const { proof, publicSignals } = await snarkjs.groth16.fullProve({
        "M_p": [
            23,
            45,
            67,
            89,
            12,
            34,
            56,
            78,
            90,
            11
        ],
        "M_c": [
            23,
            45,
            67,
            88,
            12,
            34,
            56,
            77,
            90,
            10
        ],
        "r_p": [
            1023,
            2045,
            3067,
            4089,
            5012,
            6034,
            7056,
            8078,
            9090,
            10011
        ],
        "r_c": [
            1123,
            2245,
            3367,
            4489,
            5512,
            6634,
            7756,
            8878,
            9990,
            11011
        ]
    }, "circuit.wasm", "circuit_final.zkey");

    console.log("Proof: ");
    console.log(JSON.stringify(proof, null, 1));

    const vKey = JSON.parse(fs.readFileSync("verification_key.json"));

    const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);

    if (res === true) {
        console.log("Verification OK");
    } else {
        console.log("Invalid proof");
    }

}

run().then(() => {
    process.exit(0);
});