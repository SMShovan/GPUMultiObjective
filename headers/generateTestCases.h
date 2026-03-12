#ifndef GENERATE_TEST_CASES_H
#define GENERATE_TEST_CASES_H

#include <string>

/**
 * @brief Generate deterministic test cases for sanity-checking update algorithms.
 *
 * Creates 10 test case directories under `baseDir`, each containing:
 * - originalGraph/ (CSR files)
 * - changedEdges/ (insert.txt, delete.txt)
 * - updatedGraph/ (CSR files after applying changes)
 * - expected/ (distances and SSSP tree for original and updated graphs)
 *
 * @param baseDir Root directory for all test cases (e.g. "tests").
 * @return True on success; false otherwise.
 */
bool generateTestCases(const std::string &baseDir = "tests");

#endif
