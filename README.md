# Proof of Paternal Similarity using Groth16 ZK Proof

This Zero-Knowledge Proof (ZKP) system allows a user to prove that a child shares a sufficient number of genetic markers with a supposed parent without revealing any sensitive genetic information. Specifically, it proves that the number of matching genetic markers between the parent and child meets or exceeds a certain threshold, indicating likely parenthood.

### What are Genetic Markers?

Genetic markers are specific sequences within DNA that are used to identify similarities between individuals. Each marker can represent a specific gene variant, allele, or DNA region, helping to compare genetic traits between a parent and child. For this ZKP, each genetic marker is represented by a number, making it easy to perform comparisons without revealing actual genetic details.

### How It Works:

Genetic Markers (M_p and M_c): Arrays representing the genetic markers of the parent and child, respectively. These numbers are placeholders for real genetic traits. Each position in the array corresponds to a specific genetic marker.
Blinding Factors (r_p and r_c): Random numbers added to each genetic marker to protect privacy. Blinding factors prevent the exact genetic markers from being exposed, as only the combined value is used in commitments. Each blinding factor is unique for each marker, ensuring data security.
Commitments (C_p and C_c): Hashes of the genetic markers combined with blinding factors, ensuring privacy. The commitments allow the verification of genetic similarity without directly revealing genetic markers.
Threshold (T): The minimum number of matching markers required to indicate likely parenthood. In this example, T = 7, meaning that at least 7 out of 10 markers must match for the proof to verify likely parenthood.

### Instructions:
Enter the genetic markers and blinding factors for both the parent and the child. Each array should contain exactly 10 integers separated by commas. The genetic markers should be integers representing specific genetic traits or markers.