# MOSPOpenMP Makefile
CXX      := g++-15
CXXFLAGS := -std=c++17 -Wall -Wextra -Iheaders
SRCDIR   := src
BINDIR   := bin
BUILDDIR := build

APP      := $(BINDIR)/main

# Base sources (shared by all targets)
BASE_SRCS := $(SRCDIR)/generateGraph.cpp $(SRCDIR)/generateGraphCSR.cpp $(SRCDIR)/generateChangedEdges.cpp $(SRCDIR)/updateGraphCSR.cpp $(SRCDIR)/generateTestCases.cpp $(SRCDIR)/Dijkstra.cpp $(SRCDIR)/read.cpp

# Main application (includes sequential SOSP update)
MAIN_SRCS := $(SRCDIR)/main.cpp $(BASE_SRCS) $(SRCDIR)/sequentialSOSPUpdate.cpp $(SRCDIR)/parallelSOSPUpdate.cpp $(SRCDIR)/parallelCombinedGraph.cpp
MAIN_OBJS := $(MAIN_SRCS:$(SRCDIR)/%.cpp=$(BUILDDIR)/%.o)

# Sequential stress test
STRESS_SRCS := $(SRCDIR)/stressTest.cpp $(BASE_SRCS) $(SRCDIR)/sequentialSOSPUpdate.cpp
STRESS_OBJS := $(STRESS_SRCS:$(SRCDIR)/%.cpp=$(BUILDDIR)/%.o)

# Parallel stress test (OpenMP)
PARALLEL_STRESS_SRCS := $(SRCDIR)/parallelStressTest.cpp $(BASE_SRCS) $(SRCDIR)/parallelSOSPUpdate.cpp $(SRCDIR)/sequentialSOSPUpdate.cpp
PARALLEL_STRESS_OBJS := $(PARALLEL_STRESS_SRCS:$(SRCDIR)/%.cpp=$(BUILDDIR)/parallel_%.o)

.PHONY: all clean run stressTest parallelStressTest

all: $(APP)

$(BINDIR) $(BUILDDIR):
	@mkdir -p $@

# --- Main application ---
$(APP): $(MAIN_OBJS) | $(BINDIR)
	$(CXX) $(CXXFLAGS) -fopenmp -o $@ $^

$(BUILDDIR)/%.o: $(SRCDIR)/%.cpp | $(BUILDDIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# parallelSOSPUpdate.o always needs -fopenmp regardless of target
$(BUILDDIR)/parallelSOSPUpdate.o: $(SRCDIR)/parallelSOSPUpdate.cpp | $(BUILDDIR)
	$(CXX) $(CXXFLAGS) -fopenmp -c -o $@ $<

# parallelCombinedGraph.o always needs -fopenmp regardless of target
$(BUILDDIR)/parallelCombinedGraph.o: $(SRCDIR)/parallelCombinedGraph.cpp | $(BUILDDIR)
	$(CXX) $(CXXFLAGS) -fopenmp -c -o $@ $<

# --- Sequential stress test ---
stressTest: $(BINDIR)/stressTest

$(BINDIR)/stressTest: $(STRESS_OBJS) | $(BINDIR)
	$(CXX) $(CXXFLAGS) -o $@ $^

# --- Parallel stress test (OpenMP) ---
parallelStressTest: $(BINDIR)/parallelStressTest

$(BINDIR)/parallelStressTest: $(PARALLEL_STRESS_OBJS) | $(BINDIR)
	$(CXX) $(CXXFLAGS) -fopenmp -o $@ $^

$(BUILDDIR)/parallel_%.o: $(SRCDIR)/%.cpp | $(BUILDDIR)
	$(CXX) $(CXXFLAGS) -fopenmp -c -o $@ $<

clean:
	rm -rf $(BINDIR) $(BUILDDIR)

run: $(APP)
	./$(APP)
