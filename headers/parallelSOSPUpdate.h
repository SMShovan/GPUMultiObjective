#ifndef PARALLEL_SOSP_UPDATE_H
#define PARALLEL_SOSP_UPDATE_H

#include <string>

/**
 * @brief Update single-objective shortest path distances and SSSP tree
 *        using OpenMP parallelism, without recomputing from scratch.
 *
 * @details
 * Implements the parallel (OpenMP) version of the SOSP Update algorithm.
 * Produces identical results to sequentialSOSPUpdate() (and thus matches
 * Dijkstra recalculation on the updated graph).
 *
 * Phases 0 and 1 (preparation + initial edge processing) are sequential.
 * Phase 2 (iterative propagation) and the post-processing BFS are
 * parallelized with OpenMP using thread-local vectors, atomic
 * compare-exchange for flag deduplication, and critical-section merging.
 *
 * @param originalCsrPrefix  Prefix for original CSR files.
 * @param distancesInputPath Path to original distances file from Dijkstra.
 * @param treeInputPath      Path to original SSSP tree file from Dijkstra.
 * @param insertPath         Path to insert.txt.
 * @param deletePath         Path to delete.txt.
 * @param objectiveIndex     Which objective (0-indexed) to use as edge weight.
 * @param source             Source vertex (0-indexed, default 0).
 * @param distancesOutputPath Output path for updated distances.
 * @param treeOutputPath      Output path for updated SSSP tree.
 * @return True on success; false otherwise.
 */
bool parallelSOSPUpdate(
    const std::string &originalCsrPrefix, const std::string &distancesInputPath,
    const std::string &treeInputPath, const std::string &insertPath,
    const std::string &deletePath, int objectiveIndex, int source = 0,
    const std::string &distancesOutputPath =
        "output/parallelSospUpdateDistancesTrees/distancesCsr.txt",
    const std::string &treeOutputPath =
        "output/parallelSospUpdateDistancesTrees/SSSPTreeCsr.txt");

#endif
